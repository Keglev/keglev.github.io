# keglev.github.io

Project documentation hub for Carlos Keglevich's public projects. Built with Jekyll and hosted on GitHub Pages.

Live at: https://keglev.github.io/ (English) · https://keglev.github.io/de/ (German)

## Structure

```
├── _config.yml               # Jekyll configuration
├── _data/
│   └── i18n.yml              # EN/DE string catalogue — ALL visible text
├── _layouts/
│   └── default.html          # Main layout: head, header, footer, theme boot
├── _includes/
│   ├── page_body.html        # The whole landing page body, both languages
│   └── project_card.html     # Reusable project card component
├── assets/
│   ├── css/
│   │   └── main.css          # All styles, both theme palettes
│   └── js/
│       └── theme.js          # The only JavaScript: the theme toggle
├── index.md                  # English entry point  (/)
├── de/
│   └── index.md              # German entry point   (/de/)
├── .github/workflows/
│   └── build.yml             # Builds the site on every pull request
├── Gemfile                   # Ruby dependencies (pinned to GitHub Pages)
└── README.md                 # This file
```

## How the two languages work

Translation happens at **build** time. Each entry file declares `lang:` in its
front matter, and every template resolves text through the catalogue:

```liquid
{%- assign t = site.data.i18n[page.lang] -%}
{{ t['hero.title'] }}
```

Jekyll renders two complete static pages from one template and one catalogue.
Both are indexable, both have shareable URLs, and no JavaScript runs to produce
the text. The language switch in the header is a plain link between `/` and
`/de/`.

`index.md` and `de/index.md` contain nothing but front matter and a single
include, so the German page cannot drift out of sync with the English one.

## Local Development

1. Install Ruby (3.2 — the line GitHub Pages builds with) and Bundler
2. Clone this repository
3. Install dependencies:
   ```bash
   bundle install
   ```
4. Serve locally:
   ```bash
   bundle exec jekyll serve
   ```
5. Open http://localhost:4000

`Gemfile.lock` is intentionally not committed: GitHub Pages resolves its own gem
set server-side and ignores it. The `github-pages` gem in the `Gemfile` is what
pins the versions, including Jekyll 3.10 and Liquid 4.0.

Every pull request runs the same build in CI (`.github/workflows/build.yml`), so
a template error is caught before merge rather than after deployment.

## Adding a New Project

**Never paste literal text into a template.** A hardcoded string appears in only
one language and silently breaks the bilingual model.

1. Add the strings to `_data/i18n.yml`, under **both** `en` and `de`:

   ```yaml
   en:
     myproj.status: "Live · What a visitor can do without an account"
     myproj.title: "My Project — What It Does"
     myproj.desc: "One or two sentences about the business problem it solves."
   de:
     myproj.status: "Live · Was ohne Konto möglich ist"
     myproj.title: "Mein Projekt — was es leistet"
     myproj.desc: "Ein bis zwei Sätze zum betrieblichen Problem, das es löst."
   ```

   Write the status from the project's current README, not from memory. Two
   earlier cards claimed a deployment target the projects had already moved
   away from, and both survived several edits before anyone checked.

2. Add a card to the `.grid` in `_includes/page_body.html`:

   ```liquid
   {%- include project_card.html
       label_key="card.label.project"
       status_key="myproj.status"
       title_key="myproj.title"
       desc_key="myproj.desc"
       demo_url="https://my-project.example.com"
       docs_url="https://keglev.github.io/my-project/"
       repo_url="https://github.com/Keglev/my-project"
       badges="Java 21, Spring Boot 4.1, PostgreSQL 17"
   -%}
   ```

   Technology badges are product names and are deliberately not translated, so
   they are passed inline rather than through the catalogue.

   `badges` is split on commas, so **a badge name must never contain a comma of
   its own** — use a middot instead, as in `Llama 3.3 70B (IONOS · EU)`. A comma
   inside a name silently becomes two badges, and the per-card badge count in CI
   is what catches it.

   Note the version numbers above are current, not illustrative. CI fails the
   build on the string `Spring Boot 3`, which an earlier version of this example
   used — copying a stale example turned the build red.

3. If the new count leaves one card alone in the final row of the two-column
   grid, move `extra_class="card-centered"` onto that card — and only that one.
   See `_includes/project_card.html` for the full parameter list.

4. Update the assertions in `scripts/verify-site.sh` that carry a count: the
   per-card badge counts and the expected card order both change when a card
   is added, and CI will fail until they do. That failure is the mechanism
   working — it forces a card addition to be deliberate.

## Theming

Dark is the default and is written into the markup as `<html data-theme="dark">`.
Both palettes live as CSS custom properties in sections 1 and 2 of
`assets/css/main.css`; every component rule reads tokens and never references a
theme, so retheming means editing those two blocks and nothing else.

An inline boot script in `_layouts/default.html` applies the stored preference
before the stylesheet loads, which is what prevents a flash of the wrong theme.
It must stay inline and above the `<link>` — moving it into `theme.js` brings the
flash back.

## A note on documentation headers

Liquid runs before the browser sees a file and does not understand HTML
comments. A literal `{% include %}` example inside `<!-- ... -->` is still
executed, so a template that documents its own usage that way includes itself
forever: the build does not error, it hangs.

Any documentation header in `_includes/` or `_layouts/` that contains `{%` or
`{{` must be a Liquid `{% comment %}` block, with example tags additionally
wrapped in `{% raw %}`.

## Deployment

Pushes to `main` deploy automatically via GitHub Pages.
