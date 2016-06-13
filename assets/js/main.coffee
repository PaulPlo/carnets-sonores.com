$ 			= require 'jquery-browserify'
mousewheel	= require('jquery-mousewheel')($)
gsap 		= require 'gsap'
modernizr 	= require('./lib/modernizr')

#  VARS
slidesInnerWidth = 0
audio = document.getElementById("main-sound")
switchSounds = [15,23,34,44,52,64,74]
first = true

$ ->

	$.getJSON("http://46.101.190.114/carnets-sonores/data.json", (data) ->
		preload(data.imagesSources)
	)

	$(".cta-start").on "click", (ev) ->
		$('.slides-container').css('overflow', 'visible')
		tlStart = new TimelineLite
		tlStart.to($('.intro-overlay'), 0.3, {autoAlpha : 0, ease:Quad.easeOut}) ;
		tlStart.fromTo($('.slides-container'), 0.3, {autoAlpha : 0}, {autoAlpha:1, ease:Quad.easeOut}) ; 

	$("body").mousewheel (event, delta) ->
		event.preventDefault()
		this.scrollLeft -= (delta)
		
		if(parseInt($('.switch-sound.next').position().left) < $("body").scrollLeft())
			fadeOutSound() ; 

		

	$('.volume').on "click", (ev) ->
		if $(this).hasClass('icon-volume-up')
			$(this).removeClass().addClass('icon-volume-off')
			fadeOutSound()
		else
			$(this).removeClass().addClass('icon-volume-up')
			fadeInSound()


preload = (imageArray, index, selectedSound) ->
	index = index || 0
	selectedSound = selectedSound || 2
	if imageArray && imageArray.length > index
		img = new Image

		if($.inArray(index, switchSounds) > -1)
			console.log(index) ; 
			$(img).addClass("switch-sound")
			$(img).attr("data-sound", selectedSound+".mp3")
			if first
				$(img).addClass("next")
				first = false
			selectedSound++
		img.onload = ->	
			$('.slides-inner').append(img)
			slidesInnerWidth += img.width 
			$('.slides-inner').width(slidesInnerWidth)
			preload(imageArray, index + 1, selectedSound)
		img.src = "img/"+imageArray[index]

fadeOutSound = ->
	vol = audio.volume
	fadeoutInterval = setInterval ( ->
		if (vol > 0)
			vol -= 0.05 
			vol = Math.round(vol*100)/100
			audio.volume = vol
		else
			audio.src = "audio/"+$('.switch-sound.next').attr('data-sound')
			fadeInSound()
			clearInterval(fadeoutInterval)
	), 40

fadeInSound = ->
	vol = 0
	fadeinInterval = setInterval ( ->
		if (vol < 1)
			vol += 0.05 
			vol = Math.round(vol*100)/100
			audio.volume = vol
		else
			clearInterval(fadeinInterval)
	), 40