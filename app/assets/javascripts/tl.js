document.addEventListener('turbolinks:request-start', () => {
  t = setInterval(changeProgressColor, 10);
  function changeProgressColor() {
    if (element = document.querySelector('.turbolinks-progress-bar')) {
      const colors = ['#f8f5d8', '#c1d6e9', '#b9b1ab', '#e49977', '#a3c095'];
      let random_color = colors[Math.floor(Math.random() * colors.length)];
      
      element.style.backgroundColor = random_color;
      clearInterval(t);
    }
  }
})

