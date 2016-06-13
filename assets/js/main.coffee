$ 			= require 'jquery-browserify'
mousewheel	= require('jquery-mousewheel')($)
gsap 		= require 'gsap'
modernizr 	= require('./lib/modernizr')

#  VARS
slidesInnerWidth = false
audio = document.getElementById("main-sound")

$ ->

	slidesInnerWidth = 0

	$.getJSON("http://46.101.190.114/carnets-sonores/data.json", (data) ->
		preload(data.imagesSources)
	)

	$("body").mousewheel (event, delta) ->
		event.preventDefault()
		this.scrollLeft -= (delta)

	$('.volume').on "click", (ev) ->
		if $(this).hasClass('icon-volume-up')
			$(this).removeClass().addClass('icon-volume-off')
			fadeOutSound()
		else
			$(this).removeClass().addClass('icon-volume-up')
			fadeInSound()


preload = (imageArray, index) ->
	index = index || 0
	if imageArray && imageArray.length > index
		img = new Image
		img.onload = ->
			$('.slides-inner').append(img)
			slidesInnerWidth += img.width 
			$('.slides-inner').width(slidesInnerWidth)
			preload(imageArray, index + 1)
		img.src = "img/"+imageArray[index]

fadeOutSound = ->
	vol = audio.volume
	fadeoutInterval = setInterval ( ->
		if (vol > 0)
			vol -= 0.05 
			vol = Math.round(vol*100)/100
			audio.volume = vol
		else
			clearInterval(fadeoutInterval)
	), 40

fadeInSound = ->
	vol = 0
	fadeinInterval = setInterval ( ->
		if (vol < 100)
			vol += 0.05 
			vol = Math.round(vol*100)/100
			audio.volume = vol
		else
			clearInterval(fadeinInterval)
	), 40