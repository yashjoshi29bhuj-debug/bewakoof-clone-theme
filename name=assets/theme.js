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
