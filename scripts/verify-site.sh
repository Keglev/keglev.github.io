#!/usr/bin/env bash
#
# scripts/verify-site.sh
# ======================
# Asserts that the built site in _site/ is the site we meant to publish.
#
# WHAT IT PRODUCES
#   Nothing. It writes progress to stdout and exits 0 when every assertion
#   holds, or 1 on the first failure with a message naming what broke.
#
# HOW CI INVOKES IT
#   .github/workflows/build.yml runs `bundle exec jekyll build` and then
#   `scripts/verify-site.sh`. It is also the whole local check:
#
#       bundle exec jekyll build && ./scripts/verify-site.sh
#
#   That is why the assertions live here rather than inline in the workflow:
#   inline YAML shell cannot be run locally, so a contributor could only
#   discover a failure by opening a pull request.
#
# FAILURE MODE
#   `set -euo pipefail` — an unset variable, a failed command, or a broken
#   pipe aborts immediately. Every check calls fail() rather than `exit 1`
#   directly, so no failure can leave the reason unprinted.
#
# WHAT IT DELIBERATELY DOES NOT DO
#   It does not deploy, lint, or reformat. It reads _site/ and the source
#   catalogue and reports. A check that mutates what it measures cannot be
#   trusted the second time it runs.
#
# A NOTE ON THE COUNTS
#   Several assertions pin a number (three demo rows, badge counts, one
#   centred card). Adding a project makes them fail. That is the intent:
#   the failure forces the change to be deliberate rather than incidental.

set -euo pipefail

readonly SITE="_site"
readonly EN="${SITE}/index.html"
readonly DE="${SITE}/de/index.html"

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

pass() {
    echo "  ok  $*"
}

# ---------------------------------------------------------------------------
# Both language pages exist and are marked with the right language.
# ---------------------------------------------------------------------------
check_pages_built() {
    echo "Pages"
    [ -f "$EN" ] || fail "missing ${EN}"
    [ -f "$DE" ] || fail "missing ${DE}"
    grep -q 'html lang="de"' "$DE" || fail "German page is not marked lang=de"
    grep -q 'hreflang="en"' "$DE" || fail "German page does not link back to /"
    pass "both language pages built and linked"
}

# ---------------------------------------------------------------------------
# jekyll-seo-tag owns the title and the canonical link. A hand-written
# duplicate in the layout is easy to reintroduce, and a search engine then
# picks one of the two at random.
#
# Closing tags are counted, not opening ones: matching `<title` would also
# match prose inside an HTML comment that happens to name the element.
# ---------------------------------------------------------------------------
check_head_uniqueness() {
    echo "Document head"
    local page titles canon
    for page in "$EN" "$DE"; do
        titles=$(grep -c '</title>' "$page" || true)
        canon=$(grep -c '<link rel="canonical"' "$page" || true)
        [ "$titles" -eq 1 ] || fail "${page} has ${titles} title elements, expected 1"
        [ "$canon" -eq 1 ] || fail "${page} has ${canon} canonical links, expected 1"
    done
    pass "one title and one canonical link per page"
}

# ---------------------------------------------------------------------------
# Content that was deliberately removed and must not return.
# Each entry here is a regression that actually happened.
# ---------------------------------------------------------------------------
check_removed_content() {
    echo "Removed content"
    # The Restaurant Speisekarte card, replaced by the Maintenance Assistant.
    ! grep -riq "restaurant" "$SITE" || fail "Restaurant Speisekarte is referenced again"
    # StockEase's old split front-end repository.
    ! grep -rq "Keglev/frontend" "$SITE" || fail "the old StockEase frontend repo is linked again"
    # The archived React front end still serves the unedited Vite starter
    # title, so linking it from a documentation hub works against the project.
    ! grep -rq "stockeasefrontend" "$SITE" || fail "the archived React frontend is linked"
    # Stack claims corrected against the project READMEs.
    ! grep -rq "Spring Boot 3" "$SITE" || fail "a stale Spring Boot 3 reference is back"
    ! grep -rq "API layer expanding" "$SITE" || fail "the superseded StockEase status is back"
    ! grep -rq "API-Schicht im Ausbau" "$SITE" || fail "the superseded German StockEase status is back"
    # The subtitle's old closing denial.
    ! grep -rq "not from a tutorial" "$SITE" || fail "the English subtitle denies again"
    ! grep -rq "nicht von einem Tutorial" "$SITE" || fail "the German subtitle denies again"
    # The portfolio's previous address.
    ! grep -rq "carloskeglevich.vercel.app" "$SITE" || fail "the old portfolio URL is back"
    pass "no removed content has returned"
}

# ---------------------------------------------------------------------------
# Card order is a content decision, not an accident: the strongest project
# leads. Asserting it means a reorder has to be deliberate rather than a side
# effect of editing page_body.html.
#
# Only the leading ASCII word of each title is compared. The titles contain
# em dashes, and cutting by character count splits a multibyte sequence and
# produces an unstable comparison string.
# ---------------------------------------------------------------------------
check_card_order() {
    echo "Card order"
    local order first_de
    order=$(grep -o '<h3>[A-Za-z]*' "$EN" | sed 's|<h3>||' | paste -sd'|')
    [ "$order" = "AI|StockEase|SmartSupplyPro" ] \
        || fail "unexpected card order: ${order}"
    first_de=$(grep -o '<h3>[^<]*</h3>' "$DE" | head -1)
    case "$first_de" in
        *KI-Wartungsassistent*) ;;
        *) fail "German page does not lead with the KI-Wartungsassistent" ;;
    esac
    pass "AI card leads in both languages"
}

# ---------------------------------------------------------------------------
# Every card links a running deployment, so a reviewer can open the software
# from any card without first reading a README.
#
# Demo ROWS are matched on the kv-label element rather than on the words
# "Live demo": the Maintenance Assistant status line also begins with them
# and would inflate the count.
# ---------------------------------------------------------------------------
check_demo_links() {
    echo "Live demos"
    local url en_rows de_rows
    for url in "https://maintenance.smartsupply.com.de" \
               "https://bestandskontrolle.vercel.app" \
               "https://www.smartsupplypro.de"; do
        grep -q "href=\"${url}\"" "$EN" || fail "missing demo link on the English page: ${url}"
        grep -q "href=\"${url}\"" "$DE" || fail "missing demo link on the German page: ${url}"
    done
    en_rows=$(grep -c 'class="kv-label">Live demo<' "$EN" || true)
    de_rows=$(grep -c 'class="kv-label">Live-Demo<' "$DE" || true)
    [ "$en_rows" -eq 3 ] || fail "English page has ${en_rows} demo rows, expected 3"
    [ "$de_rows" -eq 3 ] || fail "German page has ${de_rows} demo rows, expected 3"
    pass "all three cards link a live demo in both languages"
}

# ---------------------------------------------------------------------------
# Link text drops the scheme and any trailing slash, keeping internal ones.
# The previous filter used `remove: '/'`, which deleted EVERY slash and
# rendered "keglev.github.ioinventory-service".
# ---------------------------------------------------------------------------
check_link_text() {
    echo "Link text"
    grep -q '>keglev.github.io/inventory-service<' "$EN" \
        || fail "docs link text is malformed"
    ! grep -q 'keglev.github.ioinventory-service' "$EN" \
        || fail "every slash was stripped from the URL again"
    grep -q '>www.smartsupplypro.de<' "$EN" \
        || fail "demo link text is malformed"
    pass "scheme and trailing slash dropped, internal slashes kept"
}

# ---------------------------------------------------------------------------
# Badges are produced by splitting a comma-separated string, so this count is
# also what catches a comma INSIDE a badge name silently becoming two badges.
# That is exactly how "Llama 3.3 70B (IONOS, EU)" rendered as two badges
# before it was written with a middot.
# ---------------------------------------------------------------------------
check_badge_counts() {
    echo "Badges"
    local page counts
    for page in "$EN" "$DE"; do
        counts=$(awk '/<div class="card/{c++} /class="badge"/{n[c]++} END{printf "%d,%d,%d", n[1], n[2], n[3]}' "$page")
        [ "$counts" = "13,13,12" ] || fail "${page} has badge counts ${counts}, expected 13,13,12"
    done
    pass "badge counts are 13, 13, 12 in grid order"
}

# ---------------------------------------------------------------------------
# Layout invariants that can each break independently while the page still
# looks broadly plausible: buttons pinned left under a centred heading, or
# centred text running the full content width.
# ---------------------------------------------------------------------------
check_layout_invariants() {
    echo "Layout"
    local css="${SITE}/assets/css/main.css" centred width_uses
    centred=$(grep -c 'card-centered' "$EN" || true)
    [ "$centred" -eq 1 ] || fail "card-centered appears ${centred} times, expected 1"
    grep -q -- '--content-width' "$css" || fail "the --content-width token is missing"
    width_uses=$(grep -c 'max-width: min(var(--content-width), 94vw)' "$css" || true)
    [ "$width_uses" -eq 2 ] \
        || fail ".wrapper and .site-header nav must both use --content-width (found ${width_uses})"
    ! grep -q "max-width: 860px" "$css" || fail "an 860px cap survives"
    grep -q "justify-content: center" "$css" || fail "the hero link row is no longer centred"
    grep -q "max-width: 68ch" "$css" || fail "the hero measure was dropped"
    pass "content width, hero centring and the single centred card hold"
}


# ---------------------------------------------------------------------------
# Capabilities that were removed from the repository, not merely from a page.
# Neither is visible in the rendered output, so nothing else would notice if
# they came back: re-listing jekyll-feed in _config.yml quietly starts
# publishing an empty feed again, and the second-repository markup would only
# surface as an extra row on a card nobody is looking at.
# ---------------------------------------------------------------------------
check_removed_capabilities() {
    echo "Removed capabilities"
    [ ! -f "${SITE}/feed.xml" ] || fail "feed.xml is back — jekyll-feed re-enabled?"
    ! grep -rq 'kv-multi' "$SITE" || fail "the second-repository markup is back"
    pass "no removed capability has returned"
}

# ---------------------------------------------------------------------------
# The key-value rows on each card: three per card, nine per page. StockEase is
# pinned to a single repository link because it once carried two, and the
# Maintenance Assistant's docs and repository URLs share a slug that no other
# assertion covers.
#
# Repository hrefs are counted rather than bare URLs: every repository URL
# appears twice by design, once as the link target and once as the link text.
# ---------------------------------------------------------------------------
check_kv_rows() {
    echo "Key-value rows"
    local page rows repos
    for page in "$EN" "$DE"; do
        rows=$(grep -c 'class="kv-label"' "$page" || true)
        [ "$rows" -eq 9 ] || fail "${page} has ${rows} kv rows, expected 9 (3 per card)"
    done
    repos=$(grep -c 'href="https://github.com/Keglev/stockease"' "$EN" || true)
    [ "$repos" -eq 1 ] || fail "StockEase has ${repos} repository links, expected 1"
    grep -q 'maintenance-assistant' "$EN" || fail "the Maintenance Assistant docs and repository links are missing"
    pass "nine kv rows per page, one repository link per card"
}
# ---------------------------------------------------------------------------
# The German page is translated, not an English copy served under /de/.
# ---------------------------------------------------------------------------
check_german_is_german() {
    echo "German page"
    grep -q 'Wartungsassistent' "$DE" || fail "German page is missing a translated project title"
    grep -q 'Projektdokumentation' "$DE" || fail "German page is missing the translated section label"
    grep -q 'durch Tests abgedeckt' "$DE" || fail "German subtitle is missing"
    pass "German page is translated"
}

# ---------------------------------------------------------------------------
# A key present under one language and missing under the other renders as an
# empty string, silently. This is the only check that catches it, and it runs
# against the source catalogue rather than the built pages because a key can
# be absent from both without either page looking wrong.
# ---------------------------------------------------------------------------
check_catalogue_parity() {
    echo "Catalogue"
    # Ruby is present in CI (the Jekyll build needs it) but may not be on a
    # contributor's machine. Say so plainly rather than letting the check
    # die on "command not found", and never skip it silently: a parity check
    # that quietly does not run is worse than no parity check at all.
    command -v ruby >/dev/null 2>&1 \
        || fail "ruby is required for the catalogue parity check and is not installed"
    ruby -ryaml -e '
        catalogue = YAML.load_file("_data/i18n.yml")
        en, de = catalogue["en"].keys.sort, catalogue["de"].keys.sort
        missing_de, missing_en = en - de, de - en
        abort("missing under de: #{missing_de.join(", ")}") unless missing_de.empty?
        abort("missing under en: #{missing_en.join(", ")}") unless missing_en.empty?
        puts "  ok  catalogue parity: #{en.size} keys under both en and de"
    '
}

main() {
    [ -d "$SITE" ] || fail "${SITE} does not exist — run 'bundle exec jekyll build' first"
    check_pages_built
    check_head_uniqueness
    check_removed_content
    check_card_order
    check_demo_links
    check_link_text
    check_badge_counts
    check_layout_invariants
    check_removed_capabilities
    check_kv_rows
    check_german_is_german
    check_catalogue_parity
    echo
    echo "All checks passed."
}

main "$@"
