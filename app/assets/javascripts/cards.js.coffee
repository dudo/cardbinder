$(document).on 'ready page:load', ->
  createWaypoints = ->
    $('li .card .front img:not(.waypoint-loaded)').waypoint (->
      img = $(this)
      img.attr('src', img.data('src'))
         .addClass('waypoint-loaded')
         .parent().siblings('.card-actions').show()
    ), offset: '150%', triggerOnce: true
  createWaypoints()

  $('#select-card-menu').waypoint('sticky');

  $('.card-menu-toggle').on 'click', (e) ->
    e.preventDefault()
    $('div#select-card-menu').toggleClass 'flip'

  $('a.select-card').on 'click', (e) ->
    e.preventDefault()
    current_pick = $(this)
    current_pick.toggleClass 'selected'
    current_pick.parent('li').toggleClass 'active'
    $('li .card .front img').waypoint 'destroy'
    selected = []
    $('a.select-card.selected').each ->
      selected.push $(this).data('pick')
    $('li.sleeve').each ->
      $card = $(this).children('.card')
      if (selected.every (sel) -> sel in $card.data('options').split(' '))
        $(this).show()
      else
        $(this).hide()
    createWaypoints()

  $('li.sleeve span.zoom-in').on 'click', ->
    $(this).removeClass('zoom-in').addClass('zoom-out')
    $(this).parents('li').toggleClass('flip').css('z-index', 99)
    $card = $(this).parents('.card')
    offset = $card.offset()
    $card.animate {
      top: '-='+(offset.top-30)
      left: '-='+(offset.left-50)
    }, 100

  $(document).on 'click', 'li.sleeve span.zoom-out', ->
    alert 'hi!'
    $sleeve = $(this).parents('.sleeve')
    $(this).removeClass('zoom-out').addClass('zoom-in')
    $sleeve.toggleClass('flip')
    $card = $(this).parents('.card')
    $card.animate {
      top: 0
      left: 0
    }, 1000, ->
      $sleeve.css('z-index', 3)

  $('#select-set-menu').one 'mouseenter', ->
    $gal = $('#select-set-menu')
    galW = $gal.outerWidth(true)
    galSW = $gal[0].scrollWidth
    wDiff = (galSW / galW) - 1
    mPadd = 100
    damp = 20
    mX = 0
    mX2 = 0
    posX = 0
    mmAA = galW - (mPadd * 2)
    mmAAr = galW / mmAA
    $('#select-set-menu').on 'mousemove', (e) ->
      mX = e.pageX - $(this).parent().offset().left - @offsetLeft
      mX2 = Math.min(Math.max(0, mX - mPadd), mmAA) * mmAAr
    setInterval (->
      posX += (mX2 - posX) / damp
      $gal.scrollLeft posX * wDiff
    ), 10
