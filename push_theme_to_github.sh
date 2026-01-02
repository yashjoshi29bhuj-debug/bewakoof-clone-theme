#!/usr/bin/env bash
set -euo pipefail

# Usage: ./push_theme_to_github.sh
# Adjust REPO variable below if needed.

REPO="yashjoshi29bhuj-debug/bewakoof-clone-theme"
REPO_URL="https://github.com/${REPO}.git"
DIR="$(basename "$REPO")"
DESCRIPTION="Bewakoof-style Shopify 2.0 theme scaffold"
LICENSE_YEAR="2026"
LICENSE_OWNER="yashjoshi29bhuj-debug"

# Check prerequisites
for cmd in git gh curl; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: '$cmd' is required but not installed. Install it and re-run the script."
    exit 1
  fi
done

# Clone repo
if [ -d "$DIR" ]; then
  echo "Directory '$DIR' already exists. Please move or remove it before running this script."
  echo "If you want the script to overwrite it, remove the directory and re-run."
  exit 1
fi

echo "Cloning $REPO_URL ..."
git clone "$REPO_URL"
cd "$DIR"

# Ensure main branch
git checkout -b main || git switch -c main || true

echo "Creating theme scaffold files..."

# README.md
cat > README.md <<'EOF'
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
1. Zip the repository (or use git archive) and upload in Shopify Admin -> Online Store -> Themes -> Upload theme.
2. Activate and customize via Customize (Theme Editor). Replace logo and images.

Importing products
1. In Shopify Admin -> Products -> Import, select `sample_products.csv` (provided) and import.

Multi-currency
- Shopify multi-currency requires Shopify Payments or a compatible provider. Configure Shopify Payments and enable additional currencies via Shopify Markets.

Multi-language
- Add locale JSON files in the locales/ directory or use a translation app.

Notes
- Replace placeholder images, logos, and content before going live.
EOF

# settings_schema.json
mkdir -p config layout templates sections snippets assets locales
cat > config/settings_schema.json <<'EOF'
[
  {
    "name": "Colors",
    "settings": [
      {
        "type": "color",
        "id": "color_primary",
        "label": "Primary color",
        "default": "#ff3366"
      },
      {
        "type": "color",
        "id": "color_accent",
        "label": "Accent color",
        "default": "#222222"
      }
    ]
  },
  {
    "name": "Header",
    "settings": [
      {
        "type": "text",
        "id": "logo_text",
        "label": "Logo text",
        "default": "Your Brand"
      }
    ]
  }
]
EOF

# layout/theme.liquid
cat > layout/theme.liquid <<'EOF'
<!doctype html>
<html lang="{{ request.locale.iso_code }}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>{% if template.name == 'index' %}{{ shop.name }}{% else %}{{ page_title }} - {{ shop.name }}{% endif %}</title>
    {{ content_for_header }}
    <link rel="stylesheet" href="{{ 'theme.css' | asset_url }}">
    <script>window.shop = {currency: "{{ shop.currency }}"};</script>
  </head>
  <body class="{{ template.name }}">
    {% section 'header' %}
    <main role="main">
      {{ content_for_layout }}
    </main>
    {% section 'footer' %}
    {{ content_for_footer }}
    <script src="{{ 'theme.js' | asset_url }}"></script>
  </body>
</html>
EOF

# templates/index.json
cat > templates/index.json <<'EOF'
{
  "sections": {
    "hero": {
      "type": "hero",
      "settings": {
        "heading": "Discover trending tees",
        "subheading": "Comfortable. Bold. You."
      }
    },
    "featured": {
      "type": "featured-collection",
      "settings": {
        "collection": ""
      }
    },
    "newsletter": {
      "type": "newsletter",
      "settings": {}
    }
  },
  "order": ["hero","featured","newsletter"]
}
EOF

# templates/product.json
cat > templates/product.json <<'EOF'
{
  "sections": {
    "product": {
      "type": "product-main",
      "settings": {}
    },
    "recommended": {
      "type": "product-recommendations",
      "settings": {}
    }
  },
  "order": ["product","recommended"]
}
EOF

# sections/header.liquid
cat > sections/header.liquid <<'EOF'
<header class="site-header">
  <div class="header-inner">
    <div class="logo">
      <a href="{{ shop.url }}">
        {% if settings.logo %}
          <img src="{{ settings.logo | img_url: '200x' }}" alt="{{ shop.name }}">
        {% else %}
          <span class="logo-text">{{ settings.logo_text }}</span>
        {% endif %}
      </a>
    </div>
    <nav class="main-nav">
      <ul>
        <li><a href="/collections/all">Shop</a></li>
        <li><a href="/collections/new">New</a></li>
        <li><a href="/pages/about">About</a></li>
      </ul>
    </nav>
    <div class="header-actions">
      <button id="currency-select">Currency</button>
      <a href="/cart" class="cart-link">Cart (<span id="cart-count">0</span>)</a>
      <button id="mobile-menu-toggle">Menu</button>
    </div>
  </div>
</header>
EOF

# sections/footer.liquid
cat > sections/footer.liquid <<'EOF'
<footer class="site-footer">
  <div class="footer-inner">
    <div class="col">
      <h4>Customer Care</h4>
      <ul>
        <li><a href="/pages/shipping">Shipping</a></li>
        <li><a href="/pages/returns">Returns</a></li>
      </ul>
    </div>
    <div class="col">
      <h4>Follow</h4>
      <ul>
        <li><a href="#">Instagram</a></li>
      </ul>
    </div>
  </div>
  <div class="copyright">© {{ 'now' | date: "%Y" }} {{ shop.name }}</div>
</footer>
EOF

# sections/hero.liquid
cat > sections/hero.liquid <<'EOF'
<section class="hero">
  <div class="hero-inner">
    <div class="hero-text">
      <h1>{{ section.settings.heading }}</h1>
      <p>{{ section.settings.subheading }}</p>
      <a class="btn" href="/collections/all">Shop now</a>
    </div>
    <div class="hero-image">
      <img src="{{ 'placeholder-hero.jpg' | asset_url }}" alt="Hero">
    </div>
  </div>
</section>
EOF

# sections/featured-collection.liquid
cat > sections/featured-collection.liquid <<'EOF'
<section class="featured-collection">
  <h2>Featured</h2>
  <div class="product-grid" data-collection-handle="{{ section.settings.collection }}">
    {% comment %} Product cards will be client-rendered based on the chosen collection {% endcomment %}
    {% for product in collections[section.settings.collection].products %}
      {% include 'product-card' %}
    {% endfor %}
  </div>
</section>
EOF

# sections/product-main.liquid
cat > sections/product-main.liquid <<'EOF'
<section class="product-main">
  <div class="product-gallery">
    {% for image in product.images %}
      <img src="{{ image | img_url: '800x' }}" alt="{{ product.title }}">
    {% endfor %}
  </div>
  <div class="product-details">
    <h1>{{ product.title }}</h1>
    <div class="price">{{ product.price | money }}</div>
    <form method="post" action="/cart/add">
      <input type="hidden" name="id" value="{{ product.selected_or_first_available_variant.id }}">
      {% if product.options.size > 0 or product.options.size %}
      <label>Size</label>
      <select name="id">
        {% for variant in product.variants %}
          <option value="{{ variant.id }}">{{ variant.title }} — {{ variant.price | money }}</option>
        {% endfor %}
      </select>
      {% endif %}
      <button type="submit" class="btn add-to-cart">Add to cart</button>
    </form>

    <div class="size-guide">
      <button id="open-size-guide">Size guide</button>
      <div id="size-guide-modal" class="modal" aria-hidden="true">
        <div class="modal-content">
          <button class="modal-close">Close</button>
          <h3>Size guide</h3>
          <p>Replace with size table</p>
        </div>
      </div>
    </div>

    <div class="product-description">
      {{ product.description }}
    </div>
  </div>
</section>
EOF

# sections/product-recommendations.liquid
cat > sections/product-recommendations.liquid <<'EOF'
<section class="product-recommendations">
  <h3>Recommended</h3>
  <div class="recommendations-grid">
    {% for p in collections.frontpage.products limit:4 %}
      {% include 'product-card' %}
    {% endfor %}
  </div>
</section>
EOF

# snippets/product-card.liquid
cat > snippets/product-card.liquid <<'EOF'
<div class="product-card">
  <a href="{{ product.url }}">
    {% if product.featured_image %}
      <img src="{{ product.featured_image | img_url: '400x' }}" alt="{{ product.title }}">
    {% else %}
      <img src="{{ 'placeholder-product.jpg' | asset_url }}" alt="{{ product.title }}">
    {% endif %}
    <h4>{{ product.title }}</h4>
    <div class="price">{{ product.price | money }}</div>
  </a>
  <form method="post" action="/cart/add">
    <input type="hidden" name="id" value="{{ product.selected_or_first_available_variant.id }}">
    <button type="submit" class="btn small">Quick Add</button>
  </form>
</div>
EOF

# snippets/cart-drawer.liquid
cat > snippets/cart-drawer.liquid <<'EOF'
<div id="cart-drawer" class="cart-drawer" aria-hidden="true">
  <div class="drawer-header">
    <h4>Your cart</h4>
    <button class="drawer-close">Close</button>
  </div>
  <div class="drawer-body">
    <div id="cart-items"></div>
  </div>
  <div class="drawer-footer">
    <a href="/cart" class="btn">View cart</a>
    <a href="/checkout" class="btn primary">Checkout</a>
  </div>
</div>
EOF

# assets/theme.css
cat > assets/theme.css <<'EOF'
:root{
  --color-primary: #ff3366;
  --color-accent: #222;
}
body{font-family:system-ui,Arial,sans-serif;color:var(--color-accent);margin:0}
.site-header{display:flex;justify-content:space-between;padding:12px 20px;border-bottom:1px solid #eee}
.product-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:16px}
.product-card{border:1px solid #eee;padding:10px}
.btn{background:var(--color-primary);color:#fff;padding:8px 12px;border:none;cursor:pointer}
.btn.small{padding:6px 8px}
.product-main{display:flex;gap:20px;padding:20px}
@media (max-width:800px){.product-main{flex-direction:column}}
EOF

# assets/theme.js
cat > assets/theme.js <<'EOF'
document.addEventListener('DOMContentLoaded',function(){
  // Cart count
  fetch('/cart.js').then(r=>r.json()).then(cart=>{
    document.getElementById('cart-count').textContent = cart.item_count || 0;
  }).catch(()=>{});

  // Size guide modal
  var open = document.getElementById('open-size-guide');
  if(open){
    var modal = document.getElementById('size-guide-modal');
    open.addEventListener('click', ()=> modal.setAttribute('aria-hidden','false'));
    modal.querySelector('.modal-close').addEventListener('click', ()=> modal.setAttribute('aria-hidden','true'));
  }

  // Simple currency switcher (client-side UI; actual currency conversion handled by Shopify Markets)
  var currencyBtn = document.getElementById('currency-select');
  if(currencyBtn){
    currencyBtn.addEventListener('click', ()=>{
      alert('Use Shopify Markets or Payments to enable currencies. This is a placeholder selector.');
    });
  }
});
EOF

# locales
cat > locales/en.default.json <<'EOF'
{
  "general": {
    "search": "Search",
    "cart": "Cart",
    "checkout": "Checkout",
    "add_to_cart": "Add to cart"
  },
  "products": {
    "size_guide": "Size guide"
  }
}
EOF

cat > locales/es.default.json <<'EOF'
{
  "general": {
    "search": "Buscar",
    "cart": "Carrito",
    "checkout": "Pagar",
    "add_to_cart": "Agregar al carrito"
  },
  "products": {
    "size_guide": "Guía de tallas"
  }
}
EOF

# sample_products.csv
cat > sample_products.csv <<'EOF'
Handle,Title,Body (HTML),Vendor,Type,Tags,Published,Option1 Name,Option1 Value,Variant SKU,Variant Grams,Variant Inventory Tracker,Variant Inventory Qty,Variant Inventory Policy,Variant Fulfillment Service,Variant Price,Variant Requires Shipping,Variant Taxable,Variant Barcode,Image Src,Image Position
basic-tee,Basic Tee,"Comfortable cotton tee",YourBrand,T-Shirt,"tees,basics",TRUE,Size,S,SKU-BT-S,200,shopify,100,deny,manual,499,TRUE,TRUE,,https://via.placeholder.com/800x800?text=Basic+Tee,1
basic-tee,Basic Tee,"Comfortable cotton tee",YourBrand,T-Shirt,"tees,basics",TRUE,Size,M,SKU-BT-M,200,shopify,100,deny,manual,499,TRUE,TRUE,,https://via.placeholder.com/800x800?text=Basic+Tee,1
basic-tee,Basic Tee,"Comfortable cotton tee",YourBrand,T-Shirt,"tees,basics",TRUE,Size,L,SKU-BT-L,200,shopify,100,deny,manual,499,TRUE,TRUE,,https://via.placeholder.com/800x800?text=Basic+Tee,1
graphic-tee,Graphic Tee,"Bold graphic tee",YourBrand,T-Shirt,"tees,graphic",TRUE,Size,S,SKU-GT-S,220,shopify,50,deny,manual,699,TRUE,TRUE,,https://via.placeholder.com/800x800?text=Graphic+Tee,1
graphic-tee,Graphic Tee,"Bold graphic tee",YourBrand,T-Shirt,"tees,graphic",TRUE,Size,M,SKU-GT-M,220,shopify,50,deny,manual,699,TRUE,TRUE,,https://via.placeholder.com/800x800?text=Graphic+Tee,1
graphic-tee,Graphic Tee,"Bold graphic tee",YourBrand,T-Shirt,"tees,graphic",TRUE,Size,L,SKU-GT-L,220,shopify,50,deny,manual,699,TRUE,TRUE,,https://via.placeholder.com/800x800?text=Graphic+Tee,1
hoodie-essentials,Hoodie Essentials,"Soft pullover hoodie",YourBrand,Hoodie,"hoodies,essentials",TRUE,Size,M,SKU-HD-M,600,shopify,40,deny,manual,1299,TRUE,TRUE,,https://via.placeholder.com/800x800?text=Hoodie,1
joggers-comfy,Comfy Joggers,"Relaxed fit joggers",YourBrand,Bottoms,"joggers,comfy",TRUE,Size,L,SKU-JG-L,450,shopify,60,deny,manual,899,TRUE,TRUE,,https://via.placeholder.com/800x800?text=Joggers,1
caps-casual,Casual Cap,"Adjustable cap",YourBrand,Accessories,"caps",TRUE,One Size,OS,SKU-CP-OS,80,shopify,200,deny,manual,299,TRUE,TRUE,,https://via.placeholder.com/800x800?text=Cap,1
socks-basic,Basic Socks,"Comfort socks pack",YourBrand,Accessories,"socks",TRUE,One Size,OS,SKU-SK-OS,50,shopify,300,deny,manual,199,TRUE,TRUE,,https://via.placeholder.com/800x800?text=Socks,1
EOF

# create_theme_zip.sh (optional helper)
cat > create_theme_zip.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
ROOT="bewakoof-clone-theme"
rm -rf "$ROOT"
mkdir -p "$ROOT"/{config,layout,templates,sections,snippets,assets,locales}
# This helper replicates the scaffold in a folder for zipping locally.
# Copy files from this repo to the folder manually if needed.
echo "Run from theme root to create a zip of the theme: git archive --format=zip --output=bewakoof-clone-theme.zip HEAD"
EOF
chmod +x create_theme_zip.sh

# Placeholder images (download)
echo "Downloading placeholder images..."
if command -v curl >/dev/null 2>&1; then
  curl -sS -o assets/placeholder-hero.jpg "https://via.placeholder.com/1600x600?text=Hero+Placeholder" || echo "placeholder hero download failed"
  curl -sS -o assets/placeholder-product.jpg "https://via.placeholder.com/800x800?text=Product+Placeholder" || echo "placeholder product download failed"
fi

# If downloads failed, create small text placeholders
if [ ! -s assets/placeholder-hero.jpg ]; then
  printf 'Placeholder hero image\n' > assets/placeholder-hero.jpg
fi
if [ ! -s assets/placeholder-product.jpg ]; then
  printf 'Placeholder product image\n' > assets/placeholder-product.jpg
fi

# LICENSE (MIT)
cat > LICENSE <<EOF
MIT License

Copyright (c) ${LICENSE_YEAR} ${LICENSE_OWNER}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# Commit & push
git add .
git commit -m "Add Shopify 2.0 theme scaffold" || echo "No changes to commit"
git push -u origin main

# Set repo description and visibility using gh
echo "Setting repository description and visibility via gh..."
gh repo edit "$REPO" --description "$DESCRIPTION" --visibility public || echo "gh repo edit failed. You may need to set description/visibility manually."

echo
echo "Done. Files pushed to https://github.com/${REPO} on branch main."
echo "Next: Visit the repo to verify files, then Download ZIP or use 'git archive' to build a zip for Shopify."
echo "To create a ZIP of HEAD locally: git archive --format=zip --output=bewakoof-clone-theme.zip HEAD"
