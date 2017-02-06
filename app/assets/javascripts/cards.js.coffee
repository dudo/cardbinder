$(document).on 'ready page:load', ->
  createWaypoints = ->
    $('li .card .front img:not(.waypoint-loaded)').waypoint (->
      img = $(this)
      img.attr('src', img.data('src'))
         .addClass('waypoint-loaded')
    ), offset: '150%', triggerOnce: true
  createWaypoints()

  $('#select-card-menu').waypoint('sticky');

  $('.card-menu-toggle').on 'click', (e) ->
    e.preventDefault()
    $('div#select-card-menu').toggleClass 'flipped'

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

  $('.flipper').on 'click', ->
    $sleeve = $(this).parents('.sleeve')
    $sleeve.toggleClass('flipped')

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
