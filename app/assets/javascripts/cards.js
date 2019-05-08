if (!localStorage.getItem('scrollCache') || Object.entries(localStorage.getItem('scrollCache')).length === 0) {
  localStorage.setItem('scrollCache', '{}');
}

document.addEventListener("turbolinks:render", () => {
  checkScrollCache();
});

document.addEventListener("turbolinks:load", () => {

  // const set_menu = document.querySelector('#select-set-menu')
  // if (set_menu.querySelector('li.active')) {
  //   let x = set_menu.querySelector('li.active').offsetLeft;
  //   set_menu.scrollLeft = x + 120;
  // }
  
  // set_menu.addEventListener('mouseenter', function(e) {
  //   if(e.currentTarget.dataset.triggered) return;
  //   e.currentTarget.dataset.triggered = true;
  //   const gal = set_menu,
  //         galW = gal.offsetWidth,
  //         galSW = gal.scrollWidth,
  //         wDiff = (galSW / galW) - 1,
  //         mPadd = 100,
  //         damp = 20,
  //         mmAA = galW - (mPadd * 2),
  //         mmAAr = galW / mmAA;
  //   let mX = 0,
  //       mX2 = 0,
  //       posX = 0;

  //   set_menu.addEventListener('mousemove', function(e) {
  //     mX = e.pageX - set_menu.parentNode.getBoundingClientRect().left - set_menu.offsetLeft;
  //     mX2 = Math.min(Math.max(0, mX - mPadd), mmAA) * mmAAr;
  //   }, false)

  //   return setInterval((function() {
  //     posX += (mX2 - posX) / damp;
  //     return gal.scrollLeft = posX * wDiff;
  //   }), 10);
  // })

  checkScrollCache();
  
  const sleeves = document.querySelectorAll('ul.binder li.sleeve')
  if (sleeves.length > 0) {
    const sticky = document.querySelector('.sticky-wrapper')
    const menu = sticky.querySelector('.select')


    window.addEventListener('scroll', () => {
      if (sticky.getBoundingClientRect().top <= 0) {
        menu.classList.add('fixed');
      } else {
        menu.classList.remove('fixed');
      }
    }, false)

    menu.querySelectorAll('.card-menu-toggle').forEach((toggle) => {
      toggle.addEventListener('click', (e) => {
        e.preventDefault();
        menu.classList.toggle('flipped');
      }, false)
    })

    menu.querySelectorAll('a.select-card').forEach((selector) => {
      selector.addEventListener('click', (e) => {
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

    sleeves.forEach((sleeve) => { addSleeveFlipper(sleeve) })
  }
});

const addSleeveFlipper = (sleeve) => {
  sleeve.querySelector('.flipper').addEventListener('click', () => {
    sleeve.classList.toggle('flipped');
  }, false);
};

const checkScrollCache = () => {
  const elements = document.querySelectorAll("[data-turbolinks-scroll]");
  elements.forEach((element) => {
    let container = document.querySelector(element.dataset.turbolinksScroll)
    let scrollCache = JSON.parse(localStorage.getItem('scrollCache'));
    element.addEventListener('click', () => {
      scrollCache[element.dataset.turbolinksScroll] = { top: container.scrollTop, left: container.scrollLeft }
      localStorage.setItem('scrollCache', JSON.stringify(scrollCache));
    });

    if (scrollCache[element.dataset.turbolinksScroll]) {
      let left = scrollCache[element.dataset.turbolinksScroll]['left']
      let top = scrollCache[element.dataset.turbolinksScroll]['top']
      if (top || left) {
        container.scrollTo(Number(left), Number(top));
      };
    }
  });
}