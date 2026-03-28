# Ramsey's Steakhouse — Three New Pages Design Spec
**Date:** 2026-03-28
**Status:** Approved

---

## Overview

Add three new pages to the Ramsey's Steakhouse website: `menu.html`, `about.html`, and `contact.html`. Update navigation on `index.html` and `booking.html` to link to the new pages. `admin.html` is left unchanged.

---

## Implementation Approach

**Self-contained HTML files** — each page is a standalone `.html` file with inline `<style>` and `<script>`, matching the existing pattern of `index.html` and `booking.html`. No shared CSS file or JS injection.

---

## Shared Structure (All 3 New Pages)

### CSS Variables & Fonts
Copy from `index.html`:
- Variables: `--black #0a0a0a`, `--charcoal #141414`, `--coal #1e1e1e`, `--iron #2c2c2c`, `--ash #3d3d3d`, `--smoke #6b6b6b`, `--light #c8c0b8`, `--white #f4f0ea`, `--red #b5271e`, `--red-hi #d4332a`, `--gold #c9a227`, `--gold-hi #e0b93a`, `--gold-dim #7a601a`
- Fonts: Playfair Display + Barlow via Google Fonts

### Navigation
Same nav component as `index.html`. Links:
- **Menu** → `menu.html`
- **Reservations** → `booking.html`
- **About** → `about.html`
- **Contact** → `contact.html`
- **Reserve a Table** (gold CTA button) → `booking.html`
- Mobile hamburger drawer included on all pages

### Footer
Identical to `index.html` footer: address (Schuitendiep 56, 9711 RE Groningen), phone, email (info@ramseyssteakhouse.nl), opening hours, nav links.

### EN/NL Language Switcher
- Same `localStorage`-based switcher as `index.html`
- Each page carries its own full `translations` object with EN and NL strings
- Language choice persists across all pages automatically
- All visible text on each page is translatable

---

## Nav Updates — Existing Pages

### index.html
- `#menu` → `menu.html`
- `#about` → `about.html`
- `#footer` / Contact → `contact.html`
- Update both desktop nav links and mobile drawer links
- Update footer nav links to match

### booking.html
- Add full nav bar (currently only has a "back" link)
- Same nav component as above

### admin.html
- **No changes** — admin panel keeps its own separate navigation

---

## PAGE 1 — menu.html

### Hero
- Title: "The Menu" (Playfair Display, large)
- Eyebrow: "Schuitendiep 56 · Groningen"
- Dark background (no image needed, consistent with site palette)

### Set Menu Banner
Gold-bordered card near top displaying:
- 3-gangen menu — €54 p.p.
- 4-gangen menu — €63 p.p.
- 5-gangen menu — €69 p.p.

### Menu Sections

**Starters (6 items)**
Each item: Name · italic description · serving suggestion · price (EUR)
All names/descriptions marked `<!-- PLACEHOLDER -->` for client replacement.

Example structure:
- Beef Tartare — Hand-cut Black Angus, capers, shallots, quail egg · Sourdough crisps · €16
- Bone Marrow — Roasted veal bone, brioche, gremolata · Fleur de sel · €14
- Burrata — Heirloom tomatoes, aged balsamic, basil oil · Seasonal leaves · €13
- Seared Scallops — Pan-seared king scallops, cauliflower purée, pancetta · Truffle oil · €18
- French Onion Soup — Rich beef broth, caramelized onions, cognac · Gruyère crouton · €12
- Wagyu Sliders — Three mini wagyu burgers, aged cheddar, pickled mustard · Truffle aioli · €17

**Main Courses — Beef (5 cuts)**
Each item: cut name · weight · description · price
Subtitle: "Served with seasonal vegetables and sauce of choice"

- Ribeye — 400g — Dry-aged 28 days, Black Angus, intense marbling · €48
- Tomahawk — 1.1kg — Long-bone ribeye, reverse-seared over charcoal, for two · €89
- Porterhouse — 600g — Dry-aged 35 days, T-bone with tenderloin and strip · €58
- Filet Mignon — 220g — Centre-cut tenderloin, wrapped in aged pancetta · €44
- New York Strip — 350g — Bold flavor, firm bite, herb butter finish · €42

**Sauce Choices** (listed below mains):
Peppercorn · Chimichurri · Red wine jus · Béarnaise

**Sides (4 items)**
- Truffle Fries — Truffle oil, Parmesan, thyme · €9
- Creamed Spinach — Nutmeg, garlic, aged Gruyère · €8
- Roasted Mushrooms — Wild mushroom mix, garlic confit, brown butter · €9
- Twice-Baked Potato — Sour cream, chives, cheddar, smoked bacon · €10

**Desserts (4 items)**
- Chocolate Fondant — Dark Valrhona, vanilla ice cream · €11
- Crème Brûlée — Madagascan vanilla, caramelized sugar crust · €10
- Cheesecake — NY-style, seasonal berry compote · €10
- Cheese Board — Selection of aged Dutch and French cheeses, honeycomb, crackers · €16

### Allergy Note
Bottom bar: "Menu is subject to change. Please inform us of any dietary requirements or allergies when booking."

### Translations
Full EN/NL for all section headers, item names, descriptions, prices, notes, nav, footer.

---

## PAGE 2 — about.html

### Hero
- Title: "Our Story" (Playfair Display)
- Eyebrow: "Ramsey's Steakhouse · Est. 2026"

### Story Section
Reuse the three about paragraphs from `index.html`:
1. The founding paragraph (small room, tight team, standards)
2. The craft paragraph (fire, dry-aging)
3. The location paragraph (Groningen, heart of the city)

### Image Grid
3 placeholder boxes in a grid (3-col desktop, stacked mobile):
- Dark `#1e1e1e` background, `1px solid var(--iron)` border
- Centered text: label (e.g. "The Kitchen") + "[ Photo coming soon ]"
- Minimum height: 280px

Labels: "The Kitchen" · "The Grill" · "The Team"

### Stats Row
Three stats, same style as `index.html` about stats:
- **28** — Days Dry Aged
- **800°** — Sear Temperature
- **Premium** — Cuts Only

### Google Reviews Button
Gold button, full-width on mobile, centered:
- Text: "Leave us a review on Google"
- Link: `https://search.google.com/local/writereview?placeid=PLACEHOLDER`
- `target="_blank" rel="noopener"`

### Translations
Full EN/NL for all headings, body copy, stat labels, button text, nav, footer.

---

## PAGE 3 — contact.html

### Hero
- Title: "Find Us" (Playfair Display)
- Eyebrow: "Schuitendiep 56 · Groningen"

### Two-Column Layout (desktop: 50/50, mobile: stacked)

**Left Column — Contact Info**
- Address: Schuitendiep 56, 9711 RE Groningen
- Phone: +31 50 000 0000 (tel: link)
- Email: info@ramseyssteakhouse.nl (mailto: link)
- Instagram: @ramseyssteakhouse (link placeholder)
- Opening Hours table:
  - Maandag – Dinsdag: Gesloten
  - Woensdag – Donderdag: 17:30 – 22:00
  - Vrijdag – Zaterdag: 17:00 – 23:00
  - Zondag: 17:30 – 21:30

**Right Column — Map**
Google Maps iframe embed for "Schuitendiep 56, 9711 RE Groningen":
- `width="100%" height="400"` (or full column height)
- `style="border:0"`, `allowfullscreen`, `loading="lazy"`
- Dark-tinted border to match site aesthetic

### Google Reviews Section
Centered section below the two-column layout:
- Heading: "What our guests say"
- Two gold buttons side by side (stacked mobile):
  - "Read our Google Reviews" → `https://www.google.com/maps/place/PLACEHOLDER`
  - "Leave a Review" → `https://search.google.com/local/writereview?placeid=PLACEHOLDER`
- Both `target="_blank" rel="noopener"`

### Contact Form
Below reviews section:
- Heading: "Get in Touch"
- Fields: Full Name, Email Address, Message (textarea)
- Submit button: "Send Message" (gold)
- No backend — form submits to `#` with a JS success message shown inline
- Same field styling as `index.html` booking form

### Translations
Full EN/NL for all labels, headings, hours table, button text, form labels, nav, footer.

---

## Mobile Responsiveness

All pages:
- Nav collapses to hamburger at ≤767px (same breakpoint as `index.html`)
- Two-column layouts stack to single column at ≤767px
- Image grid: 3-col → 1-col on mobile
- Stats row: 3-col → wrap on mobile
- Font sizes scale down using existing breakpoints from `index.html`

---

## File Checklist

New files:
- `menu.html`
- `about.html`
- `contact.html`

Modified files:
- `index.html` — nav links updated (desktop + mobile drawer + footer nav)
- `booking.html` — full nav added
