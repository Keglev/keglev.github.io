source "https://rubygems.org"

# This site is built and served by GitHub Pages, which uses a fixed gem set.
# The `github-pages` gem mirrors that set exactly, so a local `bundle exec
# jekyll build` reproduces what Pages will do — including the Jekyll and
# Liquid versions:
#
#     github-pages 232  ->  jekyll 3.10.0, liquid 4.0.4, kramdown 2.4.0
#
# Do NOT also declare `gem "jekyll"` here. An explicit Jekyll requirement
# conflicts with the version github-pages pins and bundler refuses to
# resolve. (The previous Gemfile declared jekyll ~> 4.3.0 alongside
# github-pages and could not install at all.)
#
#     bundle install
#     bundle exec jekyll serve   # http://127.0.0.1:4000
#
gem "github-pages", "~> 232", group: :jekyll_plugins

# Plugins. These are all on the GitHub Pages allow-list, so they work on the
# deployed site and not only locally. Keep this list in sync with the
# `plugins:` key in _config.yml.
group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"
end

# Windows and JRuby ship no zoneinfo database.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Faster directory watching for `jekyll serve` on Windows.
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]
