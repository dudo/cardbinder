if (!localStorage.getItem('scrollCache') || Object.entries(localStorage.getItem('scrollCache')).length === 0) {
  localStorage.setItem('scrollCache', '{}');
}

if (!localStorage.getItem('filterCache')) {
  localStorage.setItem('filterCache', '[]');
}

document.addEventListener("turbolinks:render", () => {
  checkScrollCache();
  const menu = document.querySelector('.select')
  const filterCache = JSON.parse(localStorage.getItem('filterCache'));
  
  menu.querySelectorAll('a.select-card').forEach((selector) => {
    if (filterCache.includes(selector.getAttribute('data-pick'))) {
      selector.classList.add('selected');
      selector.parentNode.classList.add('active');
    } else {
      selector.classList.remove('selected');
      selector.parentNode.classList.remove('active');
    }
  });
});

document.addEventListener("turbolinks:load", () => {
  checkScrollCache();
  checkFilters();
});

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
};

const checkFilters = () => {
  let filterCache = JSON.parse(localStorage.getItem('filterCache'));
  
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
      if (filterCache.includes(selector.getAttribute('data-pick'))) {
        selector.classList.add('selected');
        selector.parentNode.classList.add('active');
      }
      sleeves.forEach((sleeve) => {
        const card = sleeve.querySelector('.card');
        
        if (filterCache.every((s) => { return card.getAttribute('data-options').split(' ').includes(s) })) {
          sleeve.style.display = 'inline-block';
        } else {
          sleeve.style.display = 'none';
        }
      });
      selector.addEventListener('click', (e) => {
        e.preventDefault();
        selector.classList.toggle('selected');
        selector.parentNode.classList.toggle('active');
        selected = [...menu.querySelectorAll('a.select-card.selected')].map((s) => {
          return s.getAttribute('data-pick')
        })
        localStorage.setItem('filterCache', JSON.stringify(selected));
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
}

const addSleeveFlipper = (sleeve) => {
  sleeve.querySelector('.flipper').addEventListener('click', () => {
    sleeve.classList.toggle('flipped');
  }, false);
};