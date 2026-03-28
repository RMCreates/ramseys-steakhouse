# Three New Pages Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create menu.html, about.html, contact.html and update nav on index.html and booking.html to link to all new pages.

**Architecture:** Each page is fully self-contained HTML with inline CSS and JS, matching the existing pattern. The EN/NL i18n system uses localStorage for language persistence. No shared CSS or JS files.

**Tech Stack:** Plain HTML5, CSS3, vanilla JS. Google Fonts (Playfair Display + Barlow). Google Maps iframe.

> **i18n note for Tasks 3–5:** After pasting the shared JS and the `Object.assign(translations, {...})` block, add this as the **final line** of every page's `<script>` tag — it must come after translations are loaded:
> ```js
> (function(){ var s=localStorage.getItem('lang'); if(s && s!=='en') applyLang(s); }());
> ```

---

## File Map

| File | Action | Purpose |
|------|--------|---------|
| `index.html` | Modify | Update nav + footer anchor links → page links |
| `booking.html` | Modify | Add full nav component |
| `menu.html` | Create | Full menu page with set menu, sections, i18n |
| `about.html` | Create | Story, image grid, stats, Google Reviews |
| `contact.html` | Create | Contact info, map, reviews, contact form |

---

## Shared HTML Snippets (reference for Tasks 3–5)

### Nav HTML (use on all new pages)
```html
<header id="nav">
  <div class="container">
    <nav class="nav-inner">
      <a href="index.html" class="nav-logo">
        <img src="logo.png" alt="Ramsey's Steakhouse" style="height:80px;width:auto;display:block;" />
      </a>
      <ul class="nav-links">
        <li><a href="menu.html" data-i18n="nav_menu">Menu</a></li>
        <li><a href="booking.html" data-i18n="nav_reservations">Reservations</a></li>
        <li><a href="about.html" data-i18n="nav_about">About</a></li>
        <li><a href="contact.html" data-i18n="nav_contact">Contact</a></li>
      </ul>
      <div class="nav-right">
        <div class="lang-switcher">
          <button class="lang-btn active" data-lang="en">EN</button>
          <span class="lang-sep">|</span>
          <button class="lang-btn" data-lang="nl">NL</button>
        </div>
        <a href="booking.html" class="btn btn--gold" data-i18n="nav_reserve">Reserve a Table</a>
      </div>
      <button class="nav-burger" id="navBurger" aria-label="Toggle menu">
        <span></span><span></span><span></span>
      </button>
    </nav>
  </div>
  <div class="nav-drawer" id="navDrawer">
    <a href="menu.html" data-i18n="nav_menu">Menu</a>
    <a href="booking.html" data-i18n="nav_reservations">Reservations</a>
    <a href="about.html" data-i18n="nav_about">About</a>
    <a href="contact.html" data-i18n="nav_contact">Contact</a>
    <div class="lang-switcher" style="padding:0.4rem 0;border-bottom:1px solid var(--iron);">
      <button class="lang-btn active" data-lang="en">EN</button>
      <span class="lang-sep" style="margin:0 4px;">|</span>
      <button class="lang-btn" data-lang="nl">NL</button>
    </div>
    <a href="booking.html" class="btn btn--gold" data-i18n="nav_reserve">Reserve a Table</a>
  </div>
</header>
```

### Footer HTML (use on all new pages)
```html
<footer id="footer">
  <div class="container">
    <div class="footer-grid">
      <div class="footer-brand">
        <div class="footer-brand__name">Ramsey's</div>
        <div class="footer-brand__sub" data-i18n="footer_sub">Steakhouse &middot; Groningen</div>
        <p data-i18n="footer_p">Premium steakhouse in the heart of Groningen. No compromises, no pretense. Just fire and beef, done right.</p>
      </div>
      <div class="footer-col">
        <h4 data-i18n="footer_nav_h4">Navigate</h4>
        <ul>
          <li><a href="menu.html" data-i18n="nav_menu">Menu</a></li>
          <li><a href="booking.html" data-i18n="nav_reservations">Reservations</a></li>
          <li><a href="about.html" data-i18n="nav_about">About</a></li>
          <li><a href="contact.html" data-i18n="nav_contact">Contact</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4 data-i18n="footer_hours_h4">Opening Hours</h4>
        <div class="footer-hours-row"><span data-i18n="hours_mon">Mon &ndash; Tue</span><span data-i18n="hours_closed">Closed</span></div>
        <div class="footer-hours-row"><span data-i18n="hours_wed">Wed &ndash; Thu</span><span>17:30 &ndash; 22:00</span></div>
        <div class="footer-hours-row"><span data-i18n="hours_fri">Fri &ndash; Sat</span><span>17:00 &ndash; 22:30</span></div>
        <div class="footer-hours-row"><span data-i18n="hours_sun">Sunday</span><span>17:00 &ndash; 21:30</span></div>
      </div>
      <div class="footer-col">
        <h4 data-i18n="footer_contact_h4">Contact</h4>
        <ul>
          <li>Schuitendiep 56<br>9711 RE Groningen</li>
          <li style="margin-top:0.75rem"><a href="tel:+31500000000">+31 50 000 0000</a></li>
          <li><a href="mailto:info@ramseyssteakhouse.nl">info@ramseyssteakhouse.nl</a></li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">
      <p data-i18n="footer_copy">&copy; 2026 Ramsey's Steakhouse. All rights reserved.</p>
      <p><a href="#" data-i18n="footer_privacy">Privacy Policy</a> &nbsp;&middot;&nbsp; <a href="#" data-i18n="footer_terms">Terms</a></p>
    </div>
  </div>
</footer>
```

### Shared Nav+Footer JS (use on all new pages — paste before </script>)
```js
/* ── Sticky nav ── */
const nav = document.getElementById('nav');
window.addEventListener('scroll', () => {
  nav.classList.toggle('scrolled', window.scrollY > 60);
}, { passive: true });

/* ── Mobile nav ── */
const burger = document.getElementById('navBurger');
const drawer = document.getElementById('navDrawer');
burger.addEventListener('click', () => {
  const open = drawer.classList.toggle('open');
  burger.classList.toggle('open', open);
  burger.setAttribute('aria-expanded', open);
});
function closeDrawer() {
  drawer.classList.remove('open');
  burger.classList.remove('open');
  burger.setAttribute('aria-expanded', false);
}
drawer.querySelectorAll('a').forEach(a => a.addEventListener('click', closeDrawer));

/* ── Language switcher ── */
const translations = { en: {}, nl: {} }; // filled per page below
let currentLang = 'en';
function applyLang(lang) {
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.dataset.i18n;
    if (translations[lang] && translations[lang][key] !== undefined)
      el.innerHTML = translations[lang][key];
  });
  document.querySelectorAll('.lang-btn').forEach(b =>
    b.classList.toggle('active', b.dataset.lang === lang));
  document.documentElement.lang = lang;
  currentLang = lang;
  localStorage.setItem('lang', lang);
}
document.addEventListener('click', e => {
  const btn = e.target.closest('.lang-btn');
  if (btn) applyLang(btn.dataset.lang);
});
// NOTE: Do NOT call applyLang here — translations not yet loaded.
// Add the restore call AFTER Object.assign in each page's script (see each task).
```

### Shared CSS block (paste inside `<style>` on all new pages)
```css
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
:root {
  --black:#0a0a0a; --charcoal:#141414; --coal:#1e1e1e; --iron:#2c2c2c;
  --ash:#3d3d3d; --smoke:#6b6b6b; --light:#c8c0b8; --white:#f4f0ea;
  --red:#b5271e; --red-hi:#d4332a; --gold:#c9a227; --gold-hi:#e0b93a; --gold-dim:#7a601a;
}
html { scroll-behavior: smooth; }
body { font-family:'Barlow',sans-serif; background:var(--black); color:var(--light); font-size:16px; line-height:1.6; -webkit-font-smoothing:antialiased; overflow-x:hidden; }
h1,h2,h3,h4 { font-family:'Playfair Display',serif; color:var(--white); line-height:1.2; }
a { color:inherit; text-decoration:none; }
img { display:block; max-width:100%; }
::-webkit-scrollbar { width:6px; } ::-webkit-scrollbar-track { background:var(--black); } ::-webkit-scrollbar-thumb { background:var(--gold-dim); border-radius:3px; }
.container { width:100%; max-width:1140px; margin:0 auto; padding:0 1.25rem; }
.section-label { font-family:'Barlow',sans-serif; font-size:0.7rem; font-weight:600; letter-spacing:0.25em; text-transform:uppercase; color:var(--gold); display:block; margin-bottom:0.75rem; }
.divider { width:48px; height:2px; background:var(--gold); margin:1.25rem 0 2rem; }
.divider--center { margin-left:auto; margin-right:auto; }
.btn { display:inline-block; font-family:'Barlow',sans-serif; font-size:0.8rem; font-weight:700; letter-spacing:0.18em; text-transform:uppercase; padding:0.85rem 2rem; border-radius:2px; cursor:pointer; border:none; transition:background 0.2s,color 0.2s,transform 0.15s; }
.btn:active { transform:scale(0.97); }
.btn--gold { background:var(--gold); color:var(--black); } .btn--gold:hover { background:var(--gold-hi); }
.btn--outline { background:transparent; color:var(--gold); border:1px solid var(--gold); } .btn--outline:hover { background:var(--gold); color:var(--black); }
/* NAV */
#nav { position:fixed; top:0; left:0; right:0; z-index:100; padding:0; background:rgba(10,10,10,0.85); transition:background 0.3s,box-shadow 0.3s; }
#nav.scrolled { background:rgba(10,10,10,0.97); box-shadow:0 2px 24px rgba(0,0,0,0.6); }
.nav-inner { display:flex; align-items:center; justify-content:space-between; padding:12px 48px; }
@media(max-width:767px){ .nav-inner { padding:10px 1.25rem; } }
.nav-logo { display:flex; align-items:center; flex-shrink:0; }
.nav-links { display:none; list-style:none; gap:2rem; align-items:center; }
@media(min-width:768px){ .nav-links { display:flex; } }
.nav-links a { font-size:13px; font-weight:600; letter-spacing:2px; text-transform:uppercase; color:var(--smoke); transition:color 0.2s; }
.nav-links a:hover { color:#c9a84c; }
.nav-right { display:none; align-items:center; gap:1.25rem; }
@media(min-width:768px){ .nav-right { display:flex; } }
.lang-switcher { display:flex; align-items:center; gap:2px; }
.lang-btn { background:none; border:none; color:var(--smoke); cursor:pointer; font-family:'Barlow',sans-serif; font-size:0.72rem; font-weight:700; letter-spacing:0.1em; padding:3px 5px; transition:color 0.2s; line-height:1; }
.lang-btn:hover { color:var(--light); } .lang-btn.active { color:#c9a84c; }
.lang-sep { color:var(--ash); font-size:0.7rem; line-height:1; user-select:none; }
.nav-burger { display:flex; flex-direction:column; gap:5px; cursor:pointer; background:none; border:none; padding:4px; }
@media(min-width:768px){ .nav-burger { display:none; } }
.nav-burger span { display:block; width:24px; height:2px; background:var(--white); border-radius:2px; transition:transform 0.25s,opacity 0.25s; }
.nav-burger.open span:nth-child(1) { transform:translateY(7px) rotate(45deg); }
.nav-burger.open span:nth-child(2) { opacity:0; }
.nav-burger.open span:nth-child(3) { transform:translateY(-7px) rotate(-45deg); }
.nav-drawer { display:none; flex-direction:column; background:rgba(10,10,10,0.99); border-top:1px solid var(--iron); padding:1.5rem 1.25rem 2rem; gap:1.25rem; }
.nav-drawer.open { display:flex; }
@media(min-width:768px){ .nav-drawer { display:none !important; } }
.nav-drawer a { font-size:0.85rem; font-weight:600; letter-spacing:0.18em; text-transform:uppercase; color:var(--light); padding:0.4rem 0; border-bottom:1px solid var(--iron); }
.nav-drawer .btn { width:100%; text-align:center; margin-top:0.5rem; }
/* INNER PAGE HERO */
.page-hero { padding:9rem 0 4rem; background:var(--charcoal); position:relative; border-bottom:1px solid var(--iron); }
.page-hero h1 { font-size:clamp(2.4rem,6vw,4rem); font-weight:700; margin-bottom:0.5rem; }
.page-hero .hero-sub { font-size:1rem; color:var(--smoke); margin-top:0.75rem; max-width:560px; }
/* FOOTER */
#footer { background:var(--charcoal); border-top:1px solid var(--iron); padding:4rem 0 2rem; }
.footer-grid { display:grid; grid-template-columns:1fr; gap:2.5rem; margin-bottom:3rem; }
@media(min-width:640px){ .footer-grid { grid-template-columns:1fr 1fr; } }
@media(min-width:960px){ .footer-grid { grid-template-columns:2fr 1fr 1fr 1fr; } }
.footer-brand__name { font-family:'Playfair Display',serif; font-size:1.4rem; font-weight:900; color:var(--white); letter-spacing:0.05em; text-transform:uppercase; margin-bottom:0.25rem; }
.footer-brand__sub { font-size:0.62rem; font-weight:500; letter-spacing:0.25em; text-transform:uppercase; color:var(--gold); margin-bottom:1rem; }
.footer-brand p { font-size:0.85rem; color:var(--smoke); line-height:1.7; max-width:260px; }
.footer-col h4 { font-family:'Barlow',sans-serif; font-size:0.68rem; font-weight:700; letter-spacing:0.2em; text-transform:uppercase; color:var(--gold); margin-bottom:1.25rem; }
.footer-col ul { list-style:none; }
.footer-col ul li { font-size:0.85rem; color:var(--smoke); margin-bottom:0.5rem; line-height:1.5; }
.footer-col ul li a { color:var(--smoke); transition:color 0.2s; } .footer-col ul li a:hover { color:var(--gold); }
.footer-hours-row { display:flex; justify-content:space-between; font-size:0.82rem; color:var(--smoke); padding:0.35rem 0; border-bottom:1px solid var(--iron); }
.footer-hours-row:first-child { border-top:1px solid var(--iron); }
.footer-hours-row span:last-child { color:var(--light); }
.footer-bottom { border-top:1px solid var(--iron); padding-top:1.5rem; display:flex; flex-wrap:wrap; gap:0.75rem; justify-content:space-between; align-items:center; }
.footer-bottom p { font-size:0.75rem; color:var(--ash); }
.footer-bottom a { color:var(--ash); } .footer-bottom a:hover { color:var(--gold); }
/* ANIMATIONS */
@keyframes fadeUp { from{opacity:0;transform:translateY(22px)} to{opacity:1;transform:translateY(0)} }
.fade-up { animation:fadeUp 0.6s ease both; }
.fade-up--d1 { animation-delay:0.1s; } .fade-up--d2 { animation-delay:0.22s; } .fade-up--d3 { animation-delay:0.36s; }
```

---

## Task 1: Update nav links on index.html

**Files:** Modify `index.html`

- [ ] **Step 1: Update desktop nav links**

In `index.html`, replace:
```html
<li><a href="#menu" data-i18n="nav_menu">Menu</a></li>
<li><a href="booking.html" data-i18n="nav_reservations">Reservations</a></li>
<li><a href="#about" data-i18n="nav_about">About</a></li>
<li><a href="#footer" data-i18n="nav_contact">Contact</a></li>
```
With:
```html
<li><a href="menu.html" data-i18n="nav_menu">Menu</a></li>
<li><a href="booking.html" data-i18n="nav_reservations">Reservations</a></li>
<li><a href="about.html" data-i18n="nav_about">About</a></li>
<li><a href="contact.html" data-i18n="nav_contact">Contact</a></li>
```

- [ ] **Step 2: Update mobile drawer links**

Replace:
```html
<a href="#menu" onclick="closeDrawer()" data-i18n="nav_menu">Menu</a>
<a href="booking.html" onclick="closeDrawer()" data-i18n="nav_reservations">Reservations</a>
<a href="#about" onclick="closeDrawer()" data-i18n="nav_about">About</a>
<a href="#footer" onclick="closeDrawer()" data-i18n="nav_contact">Contact</a>
```
With:
```html
<a href="menu.html" data-i18n="nav_menu">Menu</a>
<a href="booking.html" data-i18n="nav_reservations">Reservations</a>
<a href="about.html" data-i18n="nav_about">About</a>
<a href="contact.html" data-i18n="nav_contact">Contact</a>
```
(Remove `onclick="closeDrawer()"` — the JS in Step 3 auto-closes on any link click.)

- [ ] **Step 3: Update footer nav links**

Replace:
```html
<li><a href="#menu" data-i18n="nav_menu">Menu</a></li>
<li><a href="booking.html" data-i18n="nav_reservations">Reservations</a></li>
<li><a href="#about" data-i18n="nav_about">About</a></li>
<li><a href="#footer" data-i18n="nav_contact">Contact</a></li>
```
With:
```html
<li><a href="menu.html" data-i18n="nav_menu">Menu</a></li>
<li><a href="booking.html" data-i18n="nav_reservations">Reservations</a></li>
<li><a href="about.html" data-i18n="nav_about">About</a></li>
<li><a href="contact.html" data-i18n="nav_contact">Contact</a></li>
```

- [ ] **Step 4: Add auto-close to drawer links in JS**

Find the `closeDrawer` function block in index.html's `<script>` and add after it:
```js
drawer.querySelectorAll('a').forEach(a => a.addEventListener('click', closeDrawer));
```

- [ ] **Step 5: Verify**

Open `index.html` in browser. Click Menu, About, Contact in nav — they should navigate away (404 is fine, pages don't exist yet). Confirm mobile drawer closes on link tap.

- [ ] **Step 6: Commit**
```bash
cd /Users/admin/Desktop/remsys-steakhouse
git add index.html
git commit -m "nav: update index.html links to new pages"
```

---

## Task 2: Add full nav to booking.html

**Files:** Modify `booking.html`

- [ ] **Step 1: Read the current top of booking.html**

Identify what exists at the top of `<body>` — currently just a simple back-link header.

- [ ] **Step 2: Replace booking.html's header with full nav**

Find the existing header (the simple one with a back link) and replace the entire `<header>` element with the full nav HTML from the Shared HTML Snippets section above (nav + drawer). Keep all existing booking page content below.

- [ ] **Step 3: Add nav CSS**

Inside booking.html's `<style>` block, add the full **NAV** CSS block from the Shared CSS section above (everything from `/* NAV */` through `.nav-drawer .btn { ... }`).

- [ ] **Step 4: Add nav JS**

Inside booking.html's `<script>` block, add at the top:
```js
const nav = document.getElementById('nav');
window.addEventListener('scroll', () => {
  nav.classList.toggle('scrolled', window.scrollY > 60);
}, { passive: true });
const burger = document.getElementById('navBurger');
const drawer = document.getElementById('navDrawer');
burger.addEventListener('click', () => {
  const open = drawer.classList.toggle('open');
  burger.classList.toggle('open', open);
  burger.setAttribute('aria-expanded', open);
});
function closeDrawer() {
  drawer.classList.remove('open');
  burger.classList.remove('open');
  burger.setAttribute('aria-expanded', false);
}
drawer.querySelectorAll('a').forEach(a => a.addEventListener('click', closeDrawer));
```

- [ ] **Step 5: Adjust booking page body top padding**

The booking content will now be pushed down by the fixed nav (~80px). Find any top-padding on the booking page's first section and set it to at least `padding-top: 7rem` to clear the nav.

- [ ] **Step 6: Verify**

Open `booking.html`. Full nav appears at top. Mobile hamburger works. "Reserve a Table" button is not redundant (it can stay as a secondary CTA or be hidden — leave it).

- [ ] **Step 7: Commit**
```bash
git add booking.html
git commit -m "nav: add full nav component to booking.html"
```

---

## Task 3: Create menu.html

**Files:** Create `menu.html`

- [ ] **Step 1: Create the file with this complete content**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>The Menu — Ramsey's Steakhouse</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;0,900;1,400;1,700&family=Barlow:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  <style>
    /* SHARED — paste shared CSS block here */
    /* MENU PAGE */
    .set-menu-banner {
      background: var(--coal);
      border: 1px solid var(--gold-dim);
      border-radius: 3px;
      padding: 2rem 2.5rem;
      margin: 3rem 0;
      display: flex;
      flex-wrap: wrap;
      gap: 1.5rem 3rem;
      align-items: center;
    }
    .set-menu-banner__label {
      font-family: 'Barlow', sans-serif;
      font-size: 0.68rem;
      font-weight: 700;
      letter-spacing: 0.2em;
      text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 1rem;
      flex-basis: 100%;
    }
    .set-menu-option {
      display: flex;
      align-items: baseline;
      gap: 0.75rem;
    }
    .set-menu-option__name {
      font-family: 'Playfair Display', serif;
      font-size: 1.1rem;
      color: var(--white);
    }
    .set-menu-option__price {
      font-family: 'Barlow', sans-serif;
      font-size: 1.1rem;
      font-weight: 700;
      color: var(--gold);
    }
    .set-menu-option__note {
      font-size: 0.75rem;
      color: var(--smoke);
    }
    .menu-section { padding: 3rem 0; border-bottom: 1px solid var(--iron); }
    .menu-section:last-of-type { border-bottom: none; }
    .menu-section__header { margin-bottom: 2rem; }
    .menu-section__header h2 { font-size: 1.75rem; margin-bottom: 0.5rem; }
    .menu-section__subtitle { font-size: 0.85rem; color: var(--smoke); font-style: italic; }
    .menu-items { display: grid; gap: 1.5rem; }
    @media(min-width: 768px) { .menu-items--2col { grid-template-columns: 1fr 1fr; } }
    .menu-card {
      background: var(--coal);
      border: 1px solid var(--iron);
      border-radius: 3px;
      padding: 1.25rem 1.5rem;
      display: flex;
      justify-content: space-between;
      gap: 1rem;
      transition: border-color 0.2s;
    }
    .menu-card:hover { border-color: var(--gold-dim); }
    .menu-card__info { flex: 1; }
    .menu-card__tag {
      font-family: 'Barlow', sans-serif;
      font-size: 0.62rem;
      font-weight: 700;
      letter-spacing: 0.2em;
      text-transform: uppercase;
      color: var(--red);
      margin-bottom: 0.3rem;
    }
    .menu-card__name {
      font-family: 'Playfair Display', serif;
      font-size: 1.05rem;
      color: var(--white);
      margin-bottom: 0.35rem;
    }
    .menu-card__desc {
      font-size: 0.82rem;
      color: var(--smoke);
      font-style: italic;
      line-height: 1.5;
      margin-bottom: 0.35rem;
    }
    .menu-card__serving {
      font-size: 0.75rem;
      color: var(--ash);
    }
    .menu-card__price {
      font-family: 'Barlow', sans-serif;
      font-size: 1.05rem;
      font-weight: 700;
      color: var(--gold);
      white-space: nowrap;
      align-self: flex-start;
      padding-top: 0.15rem;
    }
    .sauce-list {
      display: flex;
      flex-wrap: wrap;
      gap: 0.5rem;
      margin-top: 1.5rem;
    }
    .sauce-pill {
      background: var(--iron);
      border-radius: 2px;
      padding: 0.35rem 0.85rem;
      font-size: 0.78rem;
      color: var(--light);
      font-family: 'Barlow', sans-serif;
      letter-spacing: 0.05em;
    }
    .allergy-bar {
      background: var(--coal);
      border-top: 1px solid var(--iron);
      padding: 1.5rem 0;
      text-align: center;
      font-size: 0.82rem;
      color: var(--smoke);
      font-style: italic;
    }
  </style>
</head>
<body>

<!-- NAV — paste Shared Nav HTML here -->

<!-- HERO -->
<section class="page-hero">
  <div class="container">
    <span class="section-label fade-up" data-i18n="hero_eyebrow">Schuitendiep 56 &middot; Groningen</span>
    <h1 class="fade-up fade-up--d1" data-i18n="page_title">The Menu</h1>
    <p class="hero-sub fade-up fade-up--d2" data-i18n="page_sub">Seasonal ingredients. Open fire. No shortcuts.</p>
  </div>
</section>

<!-- MENU CONTENT -->
<main>
  <div class="container">

    <!-- SET MENU BANNER -->
    <div class="set-menu-banner">
      <span class="set-menu-banner__label" data-i18n="set_label">Set Menus &mdash; Per Person</span>
      <div class="set-menu-option">
        <span class="set-menu-option__name" data-i18n="set_3">3-Course Menu</span>
        <span class="set-menu-option__price">&euro;54</span>
        <span class="set-menu-option__note" data-i18n="set_pp">p.p.</span>
      </div>
      <div class="set-menu-option">
        <span class="set-menu-option__name" data-i18n="set_4">4-Course Menu</span>
        <span class="set-menu-option__price">&euro;63</span>
        <span class="set-menu-option__note" data-i18n="set_pp">p.p.</span>
      </div>
      <div class="set-menu-option">
        <span class="set-menu-option__name" data-i18n="set_5">5-Course Menu</span>
        <span class="set-menu-option__price">&euro;69</span>
        <span class="set-menu-option__note" data-i18n="set_pp">p.p.</span>
      </div>
    </div>

    <!-- STARTERS -->
    <section class="menu-section">
      <div class="menu-section__header">
        <span class="section-label" data-i18n="starters_label">To Start</span>
        <h2 data-i18n="starters_h2">Starters</h2>
      </div>
      <div class="menu-items menu-items--2col">
        <!-- PLACEHOLDER — replace with client content -->
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="s1_name">Beef Tartare</div>
            <div class="menu-card__desc" data-i18n="s1_desc">Hand-cut Black Angus, capers, shallots, quail egg</div>
            <div class="menu-card__serving" data-i18n="s1_serving">Served with sourdough crisps</div>
          </div>
          <div class="menu-card__price">&euro;16</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="s2_name">Bone Marrow</div>
            <div class="menu-card__desc" data-i18n="s2_desc">Roasted veal bone marrow, gremolata, fleur de sel</div>
            <div class="menu-card__serving" data-i18n="s2_serving">Served with toasted brioche</div>
          </div>
          <div class="menu-card__price">&euro;14</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="s3_name">Burrata &amp; Heirloom</div>
            <div class="menu-card__desc" data-i18n="s3_desc">Creamy burrata, heirloom tomatoes, aged balsamic, basil oil</div>
            <div class="menu-card__serving" data-i18n="s3_serving">Served with seasonal leaves</div>
          </div>
          <div class="menu-card__price">&euro;13</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="s4_name">Seared Scallops</div>
            <div class="menu-card__desc" data-i18n="s4_desc">Pan-seared king scallops, cauliflower pur&eacute;e, crispy pancetta</div>
            <div class="menu-card__serving" data-i18n="s4_serving">Finished with truffle oil</div>
          </div>
          <div class="menu-card__price">&euro;18</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="s5_name">French Onion Soup</div>
            <div class="menu-card__desc" data-i18n="s5_desc">Rich beef broth, caramelized onions, cognac</div>
            <div class="menu-card__serving" data-i18n="s5_serving">Topped with Gruy&egrave;re crouton</div>
          </div>
          <div class="menu-card__price">&euro;12</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="s6_name">Wagyu Sliders</div>
            <div class="menu-card__desc" data-i18n="s6_desc">Three mini wagyu burgers, aged cheddar, pickled mustard seeds</div>
            <div class="menu-card__serving" data-i18n="s6_serving">Served with truffle aioli</div>
          </div>
          <div class="menu-card__price">&euro;17</div>
        </div>
      </div>
    </section>

    <!-- MAINS -->
    <section class="menu-section">
      <div class="menu-section__header">
        <span class="section-label" data-i18n="mains_label">From the Grill</span>
        <h2 data-i18n="mains_h2">Main Courses &mdash; Beef</h2>
        <p class="menu-section__subtitle" data-i18n="mains_sub">Served with seasonal vegetables and sauce of choice</p>
      </div>
      <div class="menu-items">
        <!-- PLACEHOLDER — replace with client content -->
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__tag" data-i18n="m1_tag">Dry-Aged 28 Days</div>
            <div class="menu-card__name" data-i18n="m1_name">Ribeye — 400g</div>
            <div class="menu-card__desc" data-i18n="m1_desc">Black Angus, intense marbling, bone marrow butter</div>
          </div>
          <div class="menu-card__price">&euro;48</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__tag" data-i18n="m2_tag">Signature Cut</div>
            <div class="menu-card__name" data-i18n="m2_name">Tomahawk — 1.1kg</div>
            <div class="menu-card__desc" data-i18n="m2_desc">Long-bone ribeye, reverse-seared over charcoal — for two</div>
          </div>
          <div class="menu-card__price">&euro;89</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__tag" data-i18n="m3_tag">Dry-Aged 35 Days</div>
            <div class="menu-card__name" data-i18n="m3_name">Porterhouse — 600g</div>
            <div class="menu-card__desc" data-i18n="m3_desc">T-bone with both tenderloin and strip — the full experience</div>
          </div>
          <div class="menu-card__price">&euro;58</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__tag" data-i18n="m4_tag">Prime Cut</div>
            <div class="menu-card__name" data-i18n="m4_name">Filet Mignon — 220g</div>
            <div class="menu-card__desc" data-i18n="m4_desc">Centre-cut tenderloin, wrapped in aged pancetta</div>
          </div>
          <div class="menu-card__price">&euro;44</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__tag" data-i18n="m5_tag">Chef's Pick</div>
            <div class="menu-card__name" data-i18n="m5_name">New York Strip — 350g</div>
            <div class="menu-card__desc" data-i18n="m5_desc">Bold flavour, firm bite, finished with compound herb butter</div>
          </div>
          <div class="menu-card__price">&euro;42</div>
        </div>
      </div>
      <div style="margin-top:1.75rem">
        <p style="font-size:0.75rem;color:var(--smoke);text-transform:uppercase;letter-spacing:0.15em;font-weight:600;margin-bottom:0.75rem;" data-i18n="sauce_label">Sauce of Choice</p>
        <div class="sauce-list">
          <span class="sauce-pill" data-i18n="sauce_1">Peppercorn</span>
          <span class="sauce-pill" data-i18n="sauce_2">Chimichurri</span>
          <span class="sauce-pill" data-i18n="sauce_3">Red Wine Jus</span>
          <span class="sauce-pill" data-i18n="sauce_4">B&eacute;arnaise</span>
        </div>
      </div>
    </section>

    <!-- SIDES -->
    <section class="menu-section">
      <div class="menu-section__header">
        <span class="section-label" data-i18n="sides_label">Alongside</span>
        <h2 data-i18n="sides_h2">Sides</h2>
      </div>
      <div class="menu-items menu-items--2col">
        <!-- PLACEHOLDER — replace with client content -->
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="si1_name">Truffle Fries</div>
            <div class="menu-card__desc" data-i18n="si1_desc">Truffle oil, Parmesan, fresh thyme</div>
          </div>
          <div class="menu-card__price">&euro;9</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="si2_name">Creamed Spinach</div>
            <div class="menu-card__desc" data-i18n="si2_desc">Nutmeg, garlic, aged Gruy&egrave;re</div>
          </div>
          <div class="menu-card__price">&euro;8</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="si3_name">Roasted Mushrooms</div>
            <div class="menu-card__desc" data-i18n="si3_desc">Wild mushroom mix, garlic confit, brown butter</div>
          </div>
          <div class="menu-card__price">&euro;9</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="si4_name">Twice-Baked Potato</div>
            <div class="menu-card__desc" data-i18n="si4_desc">Sour cream, chives, aged cheddar, smoked bacon</div>
          </div>
          <div class="menu-card__price">&euro;10</div>
        </div>
      </div>
    </section>

    <!-- DESSERTS -->
    <section class="menu-section">
      <div class="menu-section__header">
        <span class="section-label" data-i18n="desserts_label">To Finish</span>
        <h2 data-i18n="desserts_h2">Desserts</h2>
      </div>
      <div class="menu-items menu-items--2col">
        <!-- PLACEHOLDER — replace with client content -->
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="d1_name">Chocolate Fondant</div>
            <div class="menu-card__desc" data-i18n="d1_desc">Dark Valrhona, molten centre, vanilla ice cream</div>
          </div>
          <div class="menu-card__price">&euro;11</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="d2_name">Cr&egrave;me Br&ucirc;l&eacute;e</div>
            <div class="menu-card__desc" data-i18n="d2_desc">Madagascan vanilla, caramelized sugar crust</div>
          </div>
          <div class="menu-card__price">&euro;10</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="d3_name">Cheesecake</div>
            <div class="menu-card__desc" data-i18n="d3_desc">New York-style, seasonal berry compote</div>
          </div>
          <div class="menu-card__price">&euro;10</div>
        </div>
        <div class="menu-card">
          <div class="menu-card__info">
            <div class="menu-card__name" data-i18n="d4_name">Cheese Board</div>
            <div class="menu-card__desc" data-i18n="d4_desc">Selection of aged Dutch and French cheeses, honeycomb, crackers</div>
          </div>
          <div class="menu-card__price">&euro;16</div>
        </div>
      </div>
    </section>

  </div><!-- /.container -->

  <div class="allergy-bar">
    <div class="container">
      <p data-i18n="allergy_note">Menu is subject to change. Please inform us of any dietary requirements or allergies when booking.</p>
    </div>
  </div>
</main>

<!-- FOOTER — paste Shared Footer HTML here -->

<script>
  /* paste Shared Nav+Footer JS here */

  /* ── Menu page translations ── */
  Object.assign(translations, {
    en: {
      nav_menu:'Menu', nav_reservations:'Reservations', nav_about:'About', nav_contact:'Contact', nav_reserve:'Reserve a Table',
      hero_eyebrow:'Schuitendiep 56 \u00b7 Groningen', page_title:'The Menu', page_sub:'Seasonal ingredients. Open fire. No shortcuts.',
      set_label:'Set Menus \u2014 Per Person', set_3:'3-Course Menu', set_4:'4-Course Menu', set_5:'5-Course Menu', set_pp:'p.p.',
      starters_label:'To Start', starters_h2:'Starters',
      s1_name:'Beef Tartare', s1_desc:'Hand-cut Black Angus, capers, shallots, quail egg', s1_serving:'Served with sourdough crisps',
      s2_name:'Bone Marrow', s2_desc:'Roasted veal bone marrow, gremolata, fleur de sel', s2_serving:'Served with toasted brioche',
      s3_name:'Burrata &amp; Heirloom', s3_desc:'Creamy burrata, heirloom tomatoes, aged balsamic, basil oil', s3_serving:'Served with seasonal leaves',
      s4_name:'Seared Scallops', s4_desc:'Pan-seared king scallops, cauliflower pur\u00e9e, crispy pancetta', s4_serving:'Finished with truffle oil',
      s5_name:'French Onion Soup', s5_desc:'Rich beef broth, caramelized onions, cognac', s5_serving:'Topped with Gruy\u00e8re crouton',
      s6_name:'Wagyu Sliders', s6_desc:'Three mini wagyu burgers, aged cheddar, pickled mustard seeds', s6_serving:'Served with truffle aioli',
      mains_label:'From the Grill', mains_h2:'Main Courses \u2014 Beef', mains_sub:'Served with seasonal vegetables and sauce of choice',
      m1_tag:'Dry-Aged 28 Days', m1_name:'Ribeye \u2014 400g', m1_desc:'Black Angus, intense marbling, bone marrow butter',
      m2_tag:'Signature Cut', m2_name:'Tomahawk \u2014 1.1kg', m2_desc:'Long-bone ribeye, reverse-seared over charcoal \u2014 for two',
      m3_tag:'Dry-Aged 35 Days', m3_name:'Porterhouse \u2014 600g', m3_desc:'T-bone with both tenderloin and strip \u2014 the full experience',
      m4_tag:'Prime Cut', m4_name:'Filet Mignon \u2014 220g', m4_desc:'Centre-cut tenderloin, wrapped in aged pancetta',
      m5_tag:"Chef's Pick", m5_name:'New York Strip \u2014 350g', m5_desc:'Bold flavour, firm bite, finished with compound herb butter',
      sauce_label:'Sauce of Choice', sauce_1:'Peppercorn', sauce_2:'Chimichurri', sauce_3:'Red Wine Jus', sauce_4:'B\u00e9arnaise',
      sides_label:'Alongside', sides_h2:'Sides',
      si1_name:'Truffle Fries', si1_desc:'Truffle oil, Parmesan, fresh thyme',
      si2_name:'Creamed Spinach', si2_desc:'Nutmeg, garlic, aged Gruy\u00e8re',
      si3_name:'Roasted Mushrooms', si3_desc:'Wild mushroom mix, garlic confit, brown butter',
      si4_name:'Twice-Baked Potato', si4_desc:'Sour cream, chives, aged cheddar, smoked bacon',
      desserts_label:'To Finish', desserts_h2:'Desserts',
      d1_name:'Chocolate Fondant', d1_desc:'Dark Valrhona, molten centre, vanilla ice cream',
      d2_name:'Cr\u00e8me Br\u00fbl\u00e9e', d2_desc:'Madagascan vanilla, caramelized sugar crust',
      d3_name:'Cheesecake', d3_desc:'New York-style, seasonal berry compote',
      d4_name:'Cheese Board', d4_desc:'Selection of aged Dutch and French cheeses, honeycomb, crackers',
      allergy_note:'Menu is subject to change. Please inform us of any dietary requirements or allergies when booking.',
      footer_sub:'Steakhouse \u00b7 Groningen', footer_p:'Premium steakhouse in the heart of Groningen. No compromises, no pretense. Just fire and beef, done right.',
      footer_nav_h4:'Navigate', footer_hours_h4:'Opening Hours', footer_contact_h4:'Contact',
      hours_mon:'Mon \u2013 Tue', hours_closed:'Closed', hours_wed:'Wed \u2013 Thu', hours_fri:'Fri \u2013 Sat', hours_sun:'Sunday',
      footer_copy:'\u00a9 2026 Ramsey\'s Steakhouse. All rights reserved.', footer_privacy:'Privacy Policy', footer_terms:'Terms'
    },
    nl: {
      nav_menu:'Menu', nav_reservations:'Reserveringen', nav_about:'Over Ons', nav_contact:'Contact', nav_reserve:'Reserveer een tafel',
      hero_eyebrow:'Schuitendiep 56 \u00b7 Groningen', page_title:'Het Menu', page_sub:'Seizoensgebonden ingredi\u00ebnten. Open vuur. Geen shortcuts.',
      set_label:'Arrangementen \u2014 Per Persoon', set_3:'3-Gangen Menu', set_4:'4-Gangen Menu', set_5:'5-Gangen Menu', set_pp:'p.p.',
      starters_label:'Om Te Beginnen', starters_h2:'Voorgerechten',
      s1_name:'Beef Tartare', s1_desc:'Handgesneden Black Angus, kappertjes, sjalotten, kwartelei', s1_serving:'Geserveerd met zuurdesemkroketjes',
      s2_name:'Beenmerg', s2_desc:'Geroosterd kalfsmerg, gremolata, fleur de sel', s2_serving:'Geserveerd met geroosterde brioche',
      s3_name:'Burrata &amp; Erfstuk', s3_desc:'Romige burrata, erfstuk tomaten, oude balsamico, basilicumolie', s3_serving:'Geserveerd met seizoenssla',
      s4_name:'Gebakken Coquilles', s4_desc:'Gebakken koningscoquilles, bloemkoolpur\u00e9e, knapperig pancetta', s4_serving:'Afgewerkt met truffelolie',
      s5_name:'Franse Uiensoep', s5_desc:'Rijke runderbouillon, gekarameliseerde uien, cognac', s5_serving:'Gegratineerd met Gruy\u00e8re crouton',
      s6_name:'Wagyu Sliders', s6_desc:'Drie mini wagyu burgers, belegen cheddar, ingelegde mosterdzaadjes', s6_serving:'Geserveerd met truffelaioli',
      mains_label:'Van de Grill', mains_h2:'Hoofdgerechten \u2014 Vlees', mains_sub:'Geserveerd met seizoensgroenten en saus naar keuze',
      m1_tag:'28 Dagen Dry Aged', m1_name:'Ribeye \u2014 400g', m1_desc:'Black Angus, intense marmering, beenmergboter',
      m2_tag:'Signature Cut', m2_name:'Tomahawk \u2014 1,1kg', m2_desc:'Ribeye op het bot, reverse-seared boven houtskool \u2014 voor twee',
      m3_tag:'35 Dagen Dry Aged', m3_name:'Porterhouse \u2014 600g', m3_desc:'T-bone met ossenhaas en entrecote \u2014 de volledige ervaring',
      m4_tag:'Prime Cut', m4_name:'Filet Mignon \u2014 220g', m4_desc:'Midden-gesneden ossenhaas, gewikkeld in belegen pancetta',
      m5_tag:'Keuze van de Chef', m5_name:'New York Strip \u2014 350g', m5_desc:'Krachtige smaak, stevig beet, afgewerkt met kruidenboter',
      sauce_label:'Saus naar Keuze', sauce_1:'Pepersaus', sauce_2:'Chimichurri', sauce_3:'Rode Wijnjus', sauce_4:'B\u00e9arnaise',
      sides_label:'Erbij', sides_h2:'Bijgerechten',
      si1_name:'Truffelfrites', si1_desc:'Truffelolie, Parmesan, verse tijm',
      si2_name:'Romige Spinazie', si2_desc:'Nootmuskaat, knoflook, belegen Gruy\u00e8re',
      si3_name:'Geroosterde Paddenstoelen', si3_desc:'Wilde paddenstoelenmelange, gekonfijte knoflook, bruine boter',
      si4_name:'Twice-Baked Aardappel', si4_desc:'Zure room, bieslook, belegen cheddar, gerookt spek',
      desserts_label:'Om Af Te Sluiten', desserts_h2:'Nagerechten',
      d1_name:'Chocolade Fondant', d1_desc:'Donkere Valrhona, vloeibaar hart, vanille-ijs',
      d2_name:'Cr\u00e8me Br\u00fbl\u00e9e', d2_desc:'Madagassische vanille, gekarameliseerde suikerkorst',
      d3_name:'Cheesecake', d3_desc:'New York-stijl, seizoensgebonden bessencoulis',
      d4_name:'Kaasplank', d4_desc:'Selectie van belegen Hollandse en Franse kazen, honingcake, crackers',
      allergy_note:'Het menu kan wijzigen. Geef eventuele di\u00ebtwensen of allergenen aan bij uw reservering.',
      footer_sub:'Steakhouse \u00b7 Groningen', footer_p:'Premium steakhouse in het hart van Groningen. Geen compromissen, geen pretentie. Alleen vuur en vlees, zoals het hoort.',
      footer_nav_h4:'Navigeer', footer_hours_h4:'Openingstijden', footer_contact_h4:'Contact',
      hours_mon:'Ma \u2013 Di', hours_closed:'Gesloten', hours_wed:'Wo \u2013 Do', hours_fri:'Vr \u2013 Za', hours_sun:'Zondag',
      footer_copy:'\u00a9 2026 Ramsey\'s Steakhouse. Alle rechten voorbehouden.', footer_privacy:'Privacybeleid', footer_terms:'Voorwaarden'
    }
  });
</script>
</body>
</html>
```

- [ ] **Step 2: Paste the shared CSS block into the `<style>` where the comment says so**

Copy the entire Shared CSS block from this plan and paste it at the top of the `<style>` tag, replacing the comment `/* SHARED — paste shared CSS block here */`.

- [ ] **Step 3: Paste the shared Nav HTML and Footer HTML**

Replace the two comments (`<!-- NAV — paste Shared Nav HTML here -->` and `<!-- FOOTER — paste Shared Footer HTML here -->`) with the Nav HTML and Footer HTML from the Shared HTML Snippets section.

- [ ] **Step 4: Paste the shared Nav+Footer JS**

In the `<script>` block, replace `/* paste Shared Nav+Footer JS here */` with the Shared Nav+Footer JS from this plan (everything up to and including the `applyLang` call and saved-language restore).

- [ ] **Step 5: Verify in browser**

Open `menu.html`. Check: nav renders, set menu banner shows 3 pricing options, all 4 sections display, sauce pills appear, allergy bar at bottom. Switch to NL — all text translates. Resize to 375px — cards stack, nav collapses to burger.

- [ ] **Step 6: Commit**
```bash
git add menu.html
git commit -m "feat: add menu.html"
```

---

## Task 4: Create about.html

**Files:** Create `about.html`

- [ ] **Step 1: Create the file with this complete content**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Our Story — Ramsey's Steakhouse</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;0,900;1,400;1,700&family=Barlow:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  <style>
    /* SHARED — paste shared CSS block here */
    /* ABOUT PAGE */
    .about-story { padding: 5rem 0; }
    .about-story p {
      font-size: 1.05rem;
      color: var(--light);
      line-height: 1.8;
      max-width: 720px;
      margin-bottom: 1.25rem;
    }
    .about-story p strong { color: var(--white); font-weight: 600; }
    .about-story h2 { font-size: clamp(1.75rem, 4vw, 2.5rem); margin-bottom: 0.5rem; }

    .about-images { padding: 3rem 0 5rem; background: var(--coal); border-top: 1px solid var(--iron); border-bottom: 1px solid var(--iron); }
    .image-grid {
      display: grid;
      grid-template-columns: 1fr;
      gap: 1.5rem;
      margin-top: 2rem;
    }
    @media(min-width: 640px) { .image-grid { grid-template-columns: 1fr 1fr; } }
    @media(min-width: 900px) { .image-grid { grid-template-columns: 1fr 1fr 1fr; } }
    .image-placeholder {
      background: var(--charcoal);
      border: 1px solid var(--iron);
      border-radius: 3px;
      min-height: 280px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 0.75rem;
      transition: border-color 0.2s;
    }
    .image-placeholder:hover { border-color: var(--gold-dim); }
    .image-placeholder__label {
      font-family: 'Playfair Display', serif;
      font-size: 1.1rem;
      color: var(--white);
    }
    .image-placeholder__note {
      font-size: 0.75rem;
      color: var(--ash);
      letter-spacing: 0.1em;
      text-transform: uppercase;
    }

    .about-stats-section { padding: 5rem 0; }
    .stats-row {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 2rem;
      margin-top: 2.5rem;
    }
    .stat-block { text-align: center; }
    .stat-block__num {
      font-family: 'Playfair Display', serif;
      font-size: clamp(3rem, 8vw, 5rem);
      font-weight: 900;
      color: var(--gold);
      line-height: 1;
      margin-bottom: 0.5rem;
    }
    .stat-block__label {
      font-family: 'Barlow', sans-serif;
      font-size: 0.75rem;
      font-weight: 600;
      letter-spacing: 0.2em;
      text-transform: uppercase;
      color: var(--smoke);
    }
    .stat-block__unit {
      font-size: 0.7rem;
      color: var(--ash);
      margin-top: 0.25rem;
    }

    .reviews-section {
      padding: 4rem 0;
      background: var(--coal);
      border-top: 1px solid var(--iron);
      text-align: center;
    }
    .reviews-section h2 { font-size: 1.75rem; margin-bottom: 0.75rem; }
    .reviews-section p { color: var(--smoke); margin-bottom: 2rem; font-size: 0.95rem; }
    .reviews-btn {
      display: inline-flex;
      align-items: center;
      gap: 0.6rem;
      background: var(--gold);
      color: var(--black);
      font-family: 'Barlow', sans-serif;
      font-size: 0.8rem;
      font-weight: 700;
      letter-spacing: 0.15em;
      text-transform: uppercase;
      padding: 1rem 2rem;
      border-radius: 2px;
      transition: background 0.2s, transform 0.15s;
    }
    .reviews-btn:hover { background: var(--gold-hi); transform: translateY(-2px); }
  </style>
</head>
<body>

<!-- NAV — paste Shared Nav HTML here -->

<!-- HERO -->
<section class="page-hero">
  <div class="container">
    <span class="section-label fade-up" data-i18n="hero_eyebrow">Ramsey's Steakhouse &middot; Est. 2026</span>
    <h1 class="fade-up fade-up--d1" data-i18n="page_title">Our Story</h1>
    <p class="hero-sub fade-up fade-up--d2" data-i18n="page_sub">A small room. A tight team. Standards that don't move.</p>
  </div>
</section>

<!-- STORY -->
<section class="about-story">
  <div class="container">
    <span class="section-label" data-i18n="about_label">About Us</span>
    <h2 data-i18n="about_h2">No Gimmicks. Just Beef.</h2>
    <div class="divider"></div>
    <p data-i18n="about_p1">Ramsey's Steakhouse was born from a simple obsession: <strong>the perfect steak</strong>. Not drowned in sauce, not buried under garnish — just exceptional meat, honest fire, and the skill to know when to leave it alone.</p>
    <p data-i18n="about_p2">Our cuts are sourced directly from trusted Dutch and European farms, dry-aged in-house, and grilled over live charcoal by chefs who treat their craft with the seriousness it deserves. Every plate that leaves our kitchen has been earned.</p>
    <p data-i18n="about_p3">We are located in the heart of Groningen. A small room. A tight team. Standards that don't move.</p>
  </div>
</section>

<!-- IMAGE GRID -->
<section class="about-images">
  <div class="container">
    <span class="section-label" data-i18n="photos_label">The Restaurant</span>
    <div class="image-grid">
      <div class="image-placeholder">
        <div class="image-placeholder__label" data-i18n="img1_label">The Kitchen</div>
        <div class="image-placeholder__note" data-i18n="img_note">Photo coming soon</div>
      </div>
      <div class="image-placeholder">
        <div class="image-placeholder__label" data-i18n="img2_label">The Grill</div>
        <div class="image-placeholder__note" data-i18n="img_note">Photo coming soon</div>
      </div>
      <div class="image-placeholder">
        <div class="image-placeholder__label" data-i18n="img3_label">The Team</div>
        <div class="image-placeholder__note" data-i18n="img_note">Photo coming soon</div>
      </div>
    </div>
  </div>
</section>

<!-- STATS -->
<section class="about-stats-section">
  <div class="container">
    <span class="section-label divider--center" style="text-align:center;display:block;" data-i18n="stats_label">By the Numbers</span>
    <div class="stats-row">
      <div class="stat-block">
        <div class="stat-block__num">28</div>
        <div class="stat-block__label" data-i18n="stat1_label">Days Dry Aged</div>
        <div class="stat-block__unit" data-i18n="stat1_unit">Minimum</div>
      </div>
      <div class="stat-block">
        <div class="stat-block__num">800°</div>
        <div class="stat-block__label" data-i18n="stat2_label">Sear Temperature</div>
        <div class="stat-block__unit" data-i18n="stat2_unit">Celsius</div>
      </div>
      <div class="stat-block">
        <div class="stat-block__num" data-i18n="stat3_num">Premium</div>
        <div class="stat-block__label" data-i18n="stat3_label">Cuts Only</div>
        <div class="stat-block__unit" data-i18n="stat3_unit">No exceptions</div>
      </div>
    </div>
  </div>
</section>

<!-- GOOGLE REVIEWS -->
<section class="reviews-section">
  <div class="container">
    <span class="section-label divider--center" style="display:block;text-align:center;" data-i18n="reviews_label">Guest Reviews</span>
    <h2 data-i18n="reviews_h2">What Our Guests Say</h2>
    <p data-i18n="reviews_p">We let our food do the talking. Read what our guests have to say on Google.</p>
    <a
      href="https://search.google.com/local/writereview?placeid=PLACEHOLDER"
      target="_blank"
      rel="noopener"
      class="reviews-btn"
      data-i18n="reviews_btn"
    >Leave us a Review on Google</a>
  </div>
</section>

<!-- FOOTER — paste Shared Footer HTML here -->

<script>
  /* paste Shared Nav+Footer JS here */

  Object.assign(translations, {
    en: {
      nav_menu:'Menu', nav_reservations:'Reservations', nav_about:'About', nav_contact:'Contact', nav_reserve:'Reserve a Table',
      hero_eyebrow:"Ramsey's Steakhouse \u00b7 Est. 2026", page_title:'Our Story', page_sub:"A small room. A tight team. Standards that don't move.",
      about_label:'About Us', about_h2:'No Gimmicks. Just Beef.',
      about_p1:"Ramsey's Steakhouse was born from a simple obsession: <strong>the perfect steak</strong>. Not drowned in sauce, not buried under garnish \u2014 just exceptional meat, honest fire, and the skill to know when to leave it alone.",
      about_p2:'Our cuts are sourced directly from trusted Dutch and European farms, dry-aged in-house, and grilled over live charcoal by chefs who treat their craft with the seriousness it deserves. Every plate that leaves our kitchen has been earned.',
      about_p3:"We are located in the heart of Groningen. A small room. A tight team. Standards that don't move.",
      photos_label:'The Restaurant', img1_label:'The Kitchen', img2_label:'The Grill', img3_label:'The Team', img_note:'Photo coming soon',
      stats_label:'By the Numbers',
      stat1_label:'Days Dry Aged', stat1_unit:'Minimum',
      stat2_label:'Sear Temperature', stat2_unit:'Celsius',
      stat3_num:'Premium', stat3_label:'Cuts Only', stat3_unit:'No exceptions',
      reviews_label:'Guest Reviews', reviews_h2:'What Our Guests Say',
      reviews_p:'We let our food do the talking. Read what our guests have to say on Google.',
      reviews_btn:'Leave us a Review on Google',
      footer_sub:'Steakhouse \u00b7 Groningen', footer_p:'Premium steakhouse in the heart of Groningen. No compromises, no pretense. Just fire and beef, done right.',
      footer_nav_h4:'Navigate', footer_hours_h4:'Opening Hours', footer_contact_h4:'Contact',
      hours_mon:'Mon \u2013 Tue', hours_closed:'Closed', hours_wed:'Wed \u2013 Thu', hours_fri:'Fri \u2013 Sat', hours_sun:'Sunday',
      footer_copy:'\u00a9 2026 Ramsey\'s Steakhouse. All rights reserved.', footer_privacy:'Privacy Policy', footer_terms:'Terms'
    },
    nl: {
      nav_menu:'Menu', nav_reservations:'Reserveringen', nav_about:'Over Ons', nav_contact:'Contact', nav_reserve:'Reserveer een tafel',
      hero_eyebrow:"Ramsey's Steakhouse \u00b7 Opgericht 2026", page_title:'Ons Verhaal', page_sub:'Een kleine ruimte. Een hecht team. Normen die niet verschuiven.',
      about_label:'Over Ons', about_h2:'Geen Fratsen. Gewoon Vlees.',
      about_p1:"Ramsey's Steakhouse is geboren uit een simpele obsessie: <strong>de perfecte steak</strong>. Niet verdronken in saus, niet begraven onder garnering \u2014 gewoon uitzonderlijk vlees, eerlijk vuur, en de kunde om het los te laten wanneer dat nodig is.",
      about_p2:'Onze cuts worden direct gesourced bij vertrouwde Nederlandse en Europese boerderijen, in huis dry-aged en gegrild boven levend houtskool door koks die hun vak met de nodige ernst benaderen. Elk bord dat onze keuken verlaat is verdiend.',
      about_p3:'We zijn gevestigd in het hart van Groningen. Een kleine ruimte. Een hecht team. Normen die niet verschuiven.',
      photos_label:'Het Restaurant', img1_label:'De Keuken', img2_label:'De Grill', img3_label:'Het Team', img_note:'Foto binnenkort beschikbaar',
      stats_label:'In Cijfers',
      stat1_label:'Dagen Dry Aged', stat1_unit:'Minimaal',
      stat2_label:'Schroei Temperatuur', stat2_unit:'Celsius',
      stat3_num:'Premium', stat3_label:'Alleen Premium Cuts', stat3_unit:'Zonder uitzondering',
      reviews_label:'Gastrecensies', reviews_h2:'Wat Onze Gasten Zeggen',
      reviews_p:'We laten ons eten voor zich spreken. Lees wat onze gasten zeggen op Google.',
      reviews_btn:'Laat een Recensie Achter op Google',
      footer_sub:'Steakhouse \u00b7 Groningen', footer_p:'Premium steakhouse in het hart van Groningen. Geen compromissen, geen pretentie. Alleen vuur en vlees, zoals het hoort.',
      footer_nav_h4:'Navigeer', footer_hours_h4:'Openingstijden', footer_contact_h4:'Contact',
      hours_mon:'Ma \u2013 Di', hours_closed:'Gesloten', hours_wed:'Wo \u2013 Do', hours_fri:'Vr \u2013 Za', hours_sun:'Zondag',
      footer_copy:'\u00a9 2026 Ramsey\'s Steakhouse. Alle rechten voorbehouden.', footer_privacy:'Privacybeleid', footer_terms:'Voorwaarden'
    }
  });
</script>
</body>
</html>
```

- [ ] **Step 2: Paste shared CSS, Nav HTML, Footer HTML, and Nav+Footer JS** (same as Task 3 steps 2–4)

- [ ] **Step 3: Verify in browser**

Open `about.html`. Check: story text renders, 3 image placeholder boxes display in grid, stats row shows 28 / 800° / Premium, Google Reviews button visible. Switch to NL. Resize to 375px.

- [ ] **Step 4: Commit**
```bash
git add about.html
git commit -m "feat: add about.html"
```

---

## Task 5: Create contact.html

**Files:** Create `contact.html`

- [ ] **Step 1: Create the file with this complete content**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Contact — Ramsey's Steakhouse</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;0,900;1,400;1,700&family=Barlow:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  <style>
    /* SHARED — paste shared CSS block here */
    /* CONTACT PAGE */
    .contact-section { padding: 5rem 0; }
    .contact-grid {
      display: grid;
      grid-template-columns: 1fr;
      gap: 3rem;
    }
    @media(min-width: 768px) {
      .contact-grid { grid-template-columns: 1fr 1fr; gap: 4rem; }
    }
    .contact-info h2 { font-size: 1.5rem; margin-bottom: 1.5rem; }
    .contact-detail {
      display: flex;
      flex-direction: column;
      gap: 0.25rem;
      margin-bottom: 1.25rem;
    }
    .contact-detail__label {
      font-family: 'Barlow', sans-serif;
      font-size: 0.65rem;
      font-weight: 700;
      letter-spacing: 0.2em;
      text-transform: uppercase;
      color: var(--gold);
    }
    .contact-detail__value {
      font-size: 0.95rem;
      color: var(--light);
    }
    .contact-detail__value a { color: var(--light); transition: color 0.2s; }
    .contact-detail__value a:hover { color: var(--gold); }
    .hours-table { width: 100%; border-collapse: collapse; margin-top: 0.5rem; }
    .hours-table td {
      font-size: 0.85rem;
      color: var(--smoke);
      padding: 0.4rem 0;
      border-bottom: 1px solid var(--iron);
    }
    .hours-table td:last-child { text-align: right; color: var(--light); }
    .hours-table tr:first-child td { border-top: 1px solid var(--iron); }
    .map-wrap {
      border: 1px solid var(--iron);
      border-radius: 3px;
      overflow: hidden;
      height: 440px;
    }
    .map-wrap iframe { width: 100%; height: 100%; display: block; border: 0; }
    @media(max-width: 767px) { .map-wrap { height: 300px; } }

    .reviews-section {
      padding: 4rem 0;
      background: var(--coal);
      border-top: 1px solid var(--iron);
      border-bottom: 1px solid var(--iron);
      text-align: center;
    }
    .reviews-section h2 { font-size: 1.75rem; margin-bottom: 0.75rem; }
    .reviews-section p { color: var(--smoke); margin-bottom: 2rem; max-width: 480px; margin-left: auto; margin-right: auto; }
    .reviews-btns { display: flex; flex-wrap: wrap; gap: 1rem; justify-content: center; }
    .reviews-btn {
      display: inline-flex; align-items: center; gap: 0.5rem;
      background: var(--gold); color: var(--black);
      font-family: 'Barlow', sans-serif; font-size: 0.8rem; font-weight: 700;
      letter-spacing: 0.15em; text-transform: uppercase;
      padding: 0.9rem 1.75rem; border-radius: 2px;
      transition: background 0.2s, transform 0.15s;
    }
    .reviews-btn:hover { background: var(--gold-hi); transform: translateY(-2px); }
    .reviews-btn--outline {
      background: transparent; color: var(--gold); border: 1px solid var(--gold);
    }
    .reviews-btn--outline:hover { background: var(--gold); color: var(--black); }

    .contact-form-section { padding: 5rem 0; }
    .contact-form-section h2 { font-size: 1.75rem; margin-bottom: 0.5rem; }
    .contact-form-section .divider { margin-bottom: 2rem; }
    .contact-form { max-width: 640px; }
    .form-field { margin-bottom: 1.1rem; }
    .form-field label {
      display: block;
      font-family: 'Barlow', sans-serif; font-size: 0.68rem; font-weight: 600;
      letter-spacing: 0.14em; text-transform: uppercase; color: var(--light);
      margin-bottom: 0.4rem;
    }
    .form-field input,
    .form-field textarea {
      width: 100%; background: var(--coal); border: 1px solid var(--iron);
      border-radius: 3px; color: var(--white);
      font-family: 'Barlow', sans-serif; font-size: 0.9rem;
      padding: 0.7rem 1rem; outline: none; transition: border-color 0.2s;
    }
    .form-field input::placeholder,
    .form-field textarea::placeholder { color: var(--ash); }
    .form-field input:focus,
    .form-field textarea:focus { border-color: var(--gold-dim); }
    .form-field textarea { min-height: 130px; resize: vertical; }
    .form-success-msg {
      display: none; text-align: center; padding: 2rem;
      background: var(--coal); border: 1px solid var(--gold-dim);
      border-radius: 3px; margin-top: 1rem;
    }
    .form-success-msg.show { display: block; }
    .form-success-msg h3 { color: var(--gold); margin-bottom: 0.5rem; }
    .form-success-msg p { color: var(--smoke); font-size: 0.9rem; }
  </style>
</head>
<body>

<!-- NAV — paste Shared Nav HTML here -->

<!-- HERO -->
<section class="page-hero">
  <div class="container">
    <span class="section-label fade-up" data-i18n="hero_eyebrow">Schuitendiep 56 &middot; Groningen</span>
    <h1 class="fade-up fade-up--d1" data-i18n="page_title">Find Us</h1>
    <p class="hero-sub fade-up fade-up--d2" data-i18n="page_sub">In the heart of Groningen. Wednesday through Sunday.</p>
  </div>
</section>

<!-- CONTACT INFO + MAP -->
<section class="contact-section">
  <div class="container">
    <div class="contact-grid">

      <!-- LEFT: contact details -->
      <div class="contact-info">
        <div class="contact-detail">
          <span class="contact-detail__label" data-i18n="detail_address_label">Address</span>
          <span class="contact-detail__value">Schuitendiep 56<br>9711 RE Groningen</span>
        </div>
        <div class="contact-detail">
          <span class="contact-detail__label" data-i18n="detail_phone_label">Phone</span>
          <span class="contact-detail__value"><a href="tel:+31500000000">+31 50 000 0000</a></span>
        </div>
        <div class="contact-detail">
          <span class="contact-detail__label" data-i18n="detail_email_label">Email</span>
          <span class="contact-detail__value"><a href="mailto:info@ramseyssteakhouse.nl">info@ramseyssteakhouse.nl</a></span>
        </div>
        <div class="contact-detail">
          <span class="contact-detail__label" data-i18n="detail_instagram_label">Instagram</span>
          <span class="contact-detail__value"><a href="https://instagram.com/ramseyssteakhouse" target="_blank" rel="noopener">@ramseyssteakhouse</a></span>
        </div>
        <div class="contact-detail" style="margin-top:1.5rem;">
          <span class="contact-detail__label" data-i18n="detail_hours_label">Opening Hours</span>
          <table class="hours-table">
            <tr><td data-i18n="hours_mon">Mon &ndash; Tue</td><td data-i18n="hours_closed">Closed</td></tr>
            <tr><td data-i18n="hours_wed">Wed &ndash; Thu</td><td>17:30 &ndash; 22:00</td></tr>
            <tr><td data-i18n="hours_fri">Fri &ndash; Sat</td><td>17:00 &ndash; 22:30</td></tr>
            <tr><td data-i18n="hours_sun">Sunday</td><td>17:00 &ndash; 21:30</td></tr>
          </table>
        </div>
      </div>

      <!-- RIGHT: Map -->
      <div class="map-wrap">
        <iframe
          src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2390.3!2d6.5665!3d53.2194!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47c83272cde8a48f%3A0x1!2sSchuitendiep%2056%2C%209711%20RE%20Groningen!5e0!3m2!1sen!2snl!4v1"
          allowfullscreen
          loading="lazy"
          referrerpolicy="no-referrer-when-downgrade"
          title="Ramsey's Steakhouse location"
        ></iframe>
      </div>

    </div>
  </div>
</section>

<!-- GOOGLE REVIEWS -->
<section class="reviews-section">
  <div class="container">
    <span class="section-label" style="display:block;text-align:center;" data-i18n="reviews_label">Google Reviews</span>
    <h2 data-i18n="reviews_h2">What Our Guests Say</h2>
    <p data-i18n="reviews_p">We're proud of every plate we serve. See what our guests say on Google.</p>
    <div class="reviews-btns">
      <a href="https://www.google.com/maps/place/PLACEHOLDER" target="_blank" rel="noopener" class="reviews-btn" data-i18n="reviews_read">Read our Google Reviews</a>
      <a href="https://search.google.com/local/writereview?placeid=PLACEHOLDER" target="_blank" rel="noopener" class="reviews-btn reviews-btn--outline" data-i18n="reviews_write">Leave a Review</a>
    </div>
  </div>
</section>

<!-- CONTACT FORM -->
<section class="contact-form-section">
  <div class="container">
    <span class="section-label" data-i18n="form_label">Get in Touch</span>
    <h2 data-i18n="form_h2">Send Us a Message</h2>
    <div class="divider"></div>
    <div class="contact-form" id="contactFormWrap">
      <form id="contactForm" novalidate>
        <div class="form-field">
          <label for="cf-name" data-i18n="form_name_label">Full Name</label>
          <input type="text" id="cf-name" placeholder="Jan de Vries" required />
        </div>
        <div class="form-field">
          <label for="cf-email" data-i18n="form_email_label">Email Address</label>
          <input type="email" id="cf-email" placeholder="jan@email.com" required />
        </div>
        <div class="form-field">
          <label for="cf-msg" data-i18n="form_msg_label">Message</label>
          <textarea id="cf-msg" placeholder="Your message..." required></textarea>
        </div>
        <button type="submit" class="btn btn--gold" data-i18n="form_submit">Send Message</button>
      </form>
      <div class="form-success-msg" id="formSuccess">
        <h3 data-i18n="form_success_h">Message Sent</h3>
        <p data-i18n="form_success_p">Thank you for reaching out. We'll be in touch shortly.</p>
      </div>
    </div>
  </div>
</section>

<!-- FOOTER — paste Shared Footer HTML here -->

<script>
  /* paste Shared Nav+Footer JS here */

  /* ── Contact form ── */
  document.getElementById('contactForm').addEventListener('submit', function(e) {
    e.preventDefault();
    let valid = true;
    this.querySelectorAll('[required]').forEach(function(el) {
      el.style.borderColor = '';
      if (!el.value.trim()) { el.style.borderColor = 'var(--red-hi)'; valid = false; }
    });
    if (!valid) return;
    this.style.display = 'none';
    document.getElementById('formSuccess').classList.add('show');
  });

  Object.assign(translations, {
    en: {
      nav_menu:'Menu', nav_reservations:'Reservations', nav_about:'About', nav_contact:'Contact', nav_reserve:'Reserve a Table',
      hero_eyebrow:'Schuitendiep 56 \u00b7 Groningen', page_title:'Find Us', page_sub:'In the heart of Groningen. Wednesday through Sunday.',
      detail_address_label:'Address', detail_phone_label:'Phone', detail_email_label:'Email',
      detail_instagram_label:'Instagram', detail_hours_label:'Opening Hours',
      hours_mon:'Mon \u2013 Tue', hours_closed:'Closed', hours_wed:'Wed \u2013 Thu', hours_fri:'Fri \u2013 Sat', hours_sun:'Sunday',
      reviews_label:'Google Reviews', reviews_h2:'What Our Guests Say',
      reviews_p:"We're proud of every plate we serve. See what our guests say on Google.",
      reviews_read:'Read our Google Reviews', reviews_write:'Leave a Review',
      form_label:'Get in Touch', form_h2:'Send Us a Message',
      form_name_label:'Full Name', form_email_label:'Email Address', form_msg_label:'Message',
      form_submit:'Send Message',
      form_success_h:'Message Sent', form_success_p:"Thank you for reaching out. We'll be in touch shortly.",
      footer_sub:'Steakhouse \u00b7 Groningen', footer_p:'Premium steakhouse in the heart of Groningen. No compromises, no pretense. Just fire and beef, done right.',
      footer_nav_h4:'Navigate', footer_hours_h4:'Opening Hours', footer_contact_h4:'Contact',
      footer_copy:'\u00a9 2026 Ramsey\'s Steakhouse. All rights reserved.', footer_privacy:'Privacy Policy', footer_terms:'Terms'
    },
    nl: {
      nav_menu:'Menu', nav_reservations:'Reserveringen', nav_about:'Over Ons', nav_contact:'Contact', nav_reserve:'Reserveer een tafel',
      hero_eyebrow:'Schuitendiep 56 \u00b7 Groningen', page_title:'Vind Ons', page_sub:'In het hart van Groningen. Woensdag tot en met zondag.',
      detail_address_label:'Adres', detail_phone_label:'Telefoon', detail_email_label:'E-mail',
      detail_instagram_label:'Instagram', detail_hours_label:'Openingstijden',
      hours_mon:'Ma \u2013 Di', hours_closed:'Gesloten', hours_wed:'Wo \u2013 Do', hours_fri:'Vr \u2013 Za', hours_sun:'Zondag',
      reviews_label:'Google Reviews', reviews_h2:'Wat Onze Gasten Zeggen',
      reviews_p:'We zijn trots op elk bord dat we serveren. Bekijk wat onze gasten zeggen op Google.',
      reviews_read:'Lees onze Google Reviews', reviews_write:'Schrijf een Recensie',
      form_label:'Neem Contact Op', form_h2:'Stuur Ons een Bericht',
      form_name_label:'Volledige Naam', form_email_label:'E-mailadres', form_msg_label:'Bericht',
      form_submit:'Verstuur Bericht',
      form_success_h:'Bericht Verzonden', form_success_p:'Bedankt voor uw bericht. We nemen binnenkort contact met u op.',
      footer_sub:'Steakhouse \u00b7 Groningen', footer_p:'Premium steakhouse in het hart van Groningen. Geen compromissen, geen pretentie. Alleen vuur en vlees, zoals het hoort.',
      footer_nav_h4:'Navigeer', footer_hours_h4:'Openingstijden', footer_contact_h4:'Contact',
      footer_copy:'\u00a9 2026 Ramsey\'s Steakhouse. Alle rechten voorbehouden.', footer_privacy:'Privacybeleid', footer_terms:'Voorwaarden'
    }
  });
</script>
</body>
</html>
```

- [ ] **Step 2: Paste shared CSS, Nav HTML, Footer HTML, Nav+Footer JS** (same as Task 3 steps 2–4)

- [ ] **Step 3: Verify in browser**

Open `contact.html`. Check: contact details render, Google Maps iframe loads, two reviews buttons visible, contact form works (submit shows success message). Switch to NL. Resize to 375px — two columns stack.

- [ ] **Step 4: Commit**
```bash
git add contact.html
git commit -m "feat: add contact.html"
```

---

## Task 6: Deploy

- [ ] **Step 1: Run deploy script**
```bash
cd /Users/admin/Desktop/remsys-steakhouse
./deploy.sh "feat: add menu, about, contact pages"
```

Expected output:
```
[main xxxxxxx] feat: add menu, about, contact pages
 N files changed, ...
Deployed successfully!
```

- [ ] **Step 2: Verify live site**

Open the GitHub Pages URL. Navigate from homepage through Menu → About → Contact. Confirm language switcher persists across page navigations (set NL on one page, navigate to another, should remain NL).
