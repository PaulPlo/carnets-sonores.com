$ 			= require 'jquery-browserify'
mousewheel	= require('jquery-mousewheel')($)
gsap 		= require 'gsap'
classie 	= require('./lib/classie')
svgLoader 	= require('./lib/svgLoader')
modernizr 	= require('./lib/modernizr')

#  VARS
slidesInnerWidth = false
audio = document.getElementById("main-sound")
console.log(audio)

$ ->
	setTimeout ( ->
		for slide in $('.slide') 
			slidesInnerWidth += $(slide).width() + 10 ## TODO : FIX THIS SHIT 
		$('.slides-inner').width(slidesInnerWidth)
	), 1000 
	
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