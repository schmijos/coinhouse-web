$('.carousel').carousel({
  interval: 10000
})

$('.carousel').bind('slide.bs.carousel', (e) ->
  console.log('slide event!');
);