---
layout: default
title: Project Documentation Hub — Carlos Keglevich
description: Technical documentation, demos, and references for my public projects
---

<div class="hero">
  <h1>Project Documentation Hub</h1>
  <p>Technical documentation, live demos, and API references for my public projects. Built from real business problems — procurement, inventory, and supplier management.</p>
  <div class="hero-links">
    <a class="hero-link" href="https://carloskeglevich.vercel.app/" target="_blank">Portfolio</a>
    <a class="hero-link" href="https://github.com/Keglev" target="_blank">GitHub</a>
    <a class="hero-link" href="https://www.linkedin.com/in/carloskeglevich" target="_blank">LinkedIn</a>
  </div>
</div>

<div class="section-label">Featured</div>

<div class="featured-card">
  <div class="featured-label">Personal Portfolio</div>
  <h2>carloskeglevich.vercel.app</h2>
  <p>My professional portfolio — background, projects, skills, and contact. Includes JSDoc API documentation, test coverage reports, and deployment notes.</p>
  <div class="featured-links">
    <a class="featured-link-primary" href="https://carloskeglevich.vercel.app/" target="_blank">Visit Portfolio</a>
    <a class="featured-link-secondary" href="https://keglev.github.io/my-portfolio/" target="_blank">Docs & Coverage</a>
    <a class="featured-link-secondary" href="https://github.com/Keglev/my-portfolio" target="_blank">Repository</a>
  </div>
</div>

<div class="section-label">Project Documentation</div>

<div class="grid">
  {% include project_card.html
    title="SmartSupplyPro — Procurement & Supplier Management"
    status="Production-ready · Deployed on Fly.io"
    description="Enterprise-grade API for purchasing and supplier evaluation. 36 endpoints, WAC inventory valuation, price trend analysis, automatic shortage alerts. Replaces manual Excel workflows."
    docs_url="https://keglev.github.io/inventory-service/"
    repo_url="https://github.com/Keglev/inventory-service"
    badges="Java 21, Spring Boot 3, Oracle Autonomous DB, React, TypeScript, Docker, OAuth2/JWT, CI/CD, JaCoCo >85%"
  %}

  {% include project_card.html
    title="StockEase — Inventory Management"
    status="Production-ready · Deployed on Fly.io"
    description="Full-stack inventory system for small businesses. Capital value visualization and Excel BI export — without expensive ERP software. Split into backend API and React frontend repositories."
    docs_url="https://keglev.github.io/stockease/"
    repo_url="https://github.com/Keglev/stockease"
    repo2_url="https://github.com/Keglev/frontend"
    badges="Java 17, Spring Boot 3, PostgreSQL, React, TypeScript, OAuth2, CRUD"
  %}

  {% include project_card.html
    title="Restaurant Speisekarte — Static Menu App"
    description="Lightweight React app for publishing a restaurant menu. Clean UI, zero-backend architecture, fast static deployment."
    docs_url="https://keglev.github.io/restaurant-speisekarte/"
    repo_url="https://github.com/Keglev/restaurant-speisekarte"
    badges="React, JavaScript, Vite, Static Hosting"
  %}
</div>

<div class="standards">
  <h2>Standards & Conventions</h2>
  <ul>
    <li><strong>Documentation first.</strong> Each project includes a structured README, architecture notes, and API or usage guides.</li>
    <li><strong>Reproducible builds.</strong> CI/CD pipelines handle linting, testing, and publishing docs and demos automatically.</li>
    <li><strong>Clarity over noise.</strong> Minimal styling, consistent navigation, and practical examples throughout.</li>
  </ul>
</div>
