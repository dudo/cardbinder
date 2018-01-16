document.addEventListener("turbolinks:load", function() {

  const set_menu = document.querySelector('#select-set-menu')
  const sticky = document.querySelector('.sticky-wrapper')
  const menu = sticky.querySelector('.select')
  const sleeves = document.querySelectorAll('ul.binder li.sleeve')

  window.addEventListener('scroll', function() {
    if (sticky.getBoundingClientRect().top <= 0) {
      menu.classList.add('fixed');
    } else {
      menu.classList.remove('fixed');
    }
  }, false)

  menu.querySelectorAll('.card-menu-toggle').forEach((toggle) => {
    toggle.addEventListener('click', function(e) {
      e.preventDefault();
      menu.classList.toggle('flipped');
    }, false)
  })

  menu.querySelectorAll('a.select-card').forEach((selector) => {
    selector.addEventListener('click', function(e) {
      e.preventDefault();
      selector.classList.toggle('selected');
      selector.parentNode.classList.toggle('active');
      let selected = [];
      menu.querySelectorAll('a.select-card.selected').forEach((s) => {
        selected.push(s.getAttribute('data-pick'));
      })
      sleeves.forEach((sleeve) => {
        const card = sleeve.querySelector('.card');
        if (selected.every((s) => { return card.getAttribute('data-options').split(' ').includes(s) })) {
          sleeve.style.display = 'inline-block';
        } else {
          sleeve.style.display = 'none';
        }
      });
    }, false)

  })

  sleeves.forEach((sleeve) => {
    flipper = sleeve.querySelector('.flipper');
    flipper.addEventListener('click', function() {
      sleeve.classList.toggle('flipped');
    }, false)
  })

  set_menu.addEventListener('mouseenter', function(e) {
    if(e.currentTarget.dataset.triggered) return;
    e.currentTarget.dataset.triggered = true;
    const gal = set_menu,
          galW = gal.offsetWidth,
          galSW = gal.scrollWidth,
          wDiff = (galSW / galW) - 1,
          mPadd = 100,
          damp = 20,
          mmAA = galW - (mPadd * 2),
          mmAAr = galW / mmAA;
    let mX = 0,
        mX2 = 0,
        posX = 0;

    set_menu.addEventListener('mousemove', function(e) {
      mX = e.pageX - set_menu.parentNode.getBoundingClientRect().left - set_menu.offsetLeft;
      mX2 = Math.min(Math.max(0, mX - mPadd), mmAA) * mmAAr;
    }, false)

    return setInterval((function() {
      posX += (mX2 - posX) / damp;
      return gal.scrollLeft = posX * wDiff;
    }), 10);
  })

})
