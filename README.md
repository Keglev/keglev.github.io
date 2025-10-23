# keglev.github.io

Personal project documentation hub built with Jekyll and hosted on GitHub Pages.

## Local Development

1. Install Ruby and Bundler
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

## Project Structure

```
├── _config.yml           # Jekyll configuration
├── _layouts/
│   └── default.html      # Main layout template
├── _includes/
│   └── project_card.html # Reusable project card component
├── index.md              # Homepage content
├── Gemfile               # Ruby dependencies
└── README.md            # This file
```

## Adding New Projects

Edit `index.md` and add a new project card in the grid section, or use the include:

```markdown
{% include project_card.html 
   title="Your Project Name"
   description="Project description here"
   docs_url="https://keglev.github.io/your-project/"
   repo_url="https://github.com/Keglev/your-project"
   badges="React,TypeScript,API" %}
```

## Features

- ✅ Minimal, professional design
- ✅ Dark/light mode support
- ✅ Responsive grid layout
- ✅ SEO optimization with jekyll-seo-tag
- ✅ GitHub Pages compatible
- ✅ Fast loading with minimal CSS
- ✅ Accessible and clean markup

## Deployment

This site automatically deploys to GitHub Pages when pushed to the main branch.