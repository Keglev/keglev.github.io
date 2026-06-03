# keglev.github.io

Project documentation hub for Carlos Keglevich's public projects. Built with Jekyll and hosted on GitHub Pages.

Live at: https://keglev.github.io/

## Structure

```
├── _config.yml              # Jekyll configuration
├── _layouts/
│   └── default.html         # Main layout template (HTML structure only)
├── _includes/
│   └── project_card.html    # Reusable project card component
├── assets/
│   └── css/
│       └── main.css         # All styles and design tokens
├── index.md                 # Homepage content
├── Gemfile                  # Ruby dependencies
└── README.md                # This file
```

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

## Adding a New Project

Edit `index.md` and add a card inside the `.grid` div:

```html
<div class="card">
  <span class="card-label project">Project</span>
  <div class="status">Production-ready · Deployed on Fly.io</div>
  <h3>Project Name</h3>
  <p>Short description.</p>
  <div class="kv">
    <span class="kv-label">Docs</span>
    <span><a href="https://keglev.github.io/your-project/" target="_blank">keglev.github.io/your-project</a></span>
    <span class="kv-label">Repository</span>
    <span><a href="https://github.com/Keglev/your-project" target="_blank">github.com/Keglev/your-project</a></span>
  </div>
  <div class="badges">
    <span class="badge">Java 21</span>
    <span class="badge">Spring Boot 3</span>
  </div>
</div>
```

To modify colors or layout, edit `assets/css/main.css`. Design tokens (colors, radius, spacing) are all in the `:root` block at the top of that file.

## Deployment

Pushes to `main` deploy automatically via GitHub Pages.
