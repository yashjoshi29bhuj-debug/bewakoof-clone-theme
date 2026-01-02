# Bewakoof-style Shopify 2.0 theme — Starter package

This package is a Shopify Online Store 2.0 theme scaffold (inspired by Bewakoof features) with:
- Home sections: hero slider, promo banners, featured collections, trending products
- Collection template with product grid, client-side filters and sort
- Product template: gallery, variants, size guide modal, related products
- Cart drawer + full cart page
- Header with mega-menu placeholder + search, footer
- Multi-currency and multi-language-ready (uses Shopify’s locales; see notes)
- Placeholder logo and images
- 10 sample products CSV (sample_products.csv)

How to install
1. Create a folder `bewakoof-clone-theme` and subfolders `config`, `layout`, `templates`, `sections`, `snippets`, `assets`, `locales`.
2. Create files exactly as given in this package in the respective folders.
3. Zip the `bewakoof-clone-theme` folder into `bewakoof-clone-theme.zip`.
4. In Shopify Admin -> Online Store -> Themes -> Upload theme, upload the zip.
5. Activate and customize via Customize (Theme Editor). Replace logo and images.

Importing products
1. In Shopify Admin -> Products -> Import, select `sample_products.csv` (provided) and import.

Multi-currency
- Shopify multi-currency requires Shopify Payments or a compatible payment provider. After uploading the theme:
  - Go to Settings -> Payments and configure Shopify Payments (ensure it’s available in your country).
  - Enable additional currencies via Shopify Markets (Settings -> Markets) or Shopify Payments currencies.
- The theme includes currency selector UI; make sure Shopify Payments exposes currency switch (theme will use `cart.currency` and locale format).

Multi-language
- Shopify supports translations via JSON locale files and Shopify Markets.
- Change language strings in `locales/en.default.json` and add more language JSONs (e.g. `locales/es.default.json`) and enable languages in Shopify Admin -> Online Store -> Languages or use a translation app (recommended for storefront translations of product content).

Recommended apps (optional)
- Product reviews: Shopify Reviews or Loox
- Translations: Langify or Weglot (or Shopify native translations + Markets)
- Currency switcher: Shopify Markets (native) or a lightweight currency app if needed
- Analytics & SEO: Shopify Analytics + Google Analytics & Facebook Pixel

Notes & limitations
- This scaffold is a functional starting theme. For a polished production-ready theme you may want deeper styling, accessibility audit, performance optimization, and full testing on mobile and multiple currencies.
- Replace placeholder images, logos, content, and product descriptions with your brand assets before going live.

If you want: I can (choose one)
- Create and return a zip file of this scaffold ready to upload.
- Expand more sections (lookbook, mega-menu editor, size-chart per-product).
- Add server-side faceted filters (requires apps / Shopify Search & Discovery).

Next step: I can generate the full zip now. Proceed? 
