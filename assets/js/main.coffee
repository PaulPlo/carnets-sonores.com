$ 			= require 'jquery-browserify'
mousewheel	= require('jquery-mousewheel')($)
gsap 		= require 'gsap'
modernizr 	= require('./lib/modernizr')

#  VARS
slidesInnerWidth = 0
audio = document.getElementById("sound-0")
nextAudio = false
switchSoundsPositions = [2,16,24,35,45,53,65,71,76,83] 
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
		
		if $('.switch-sound.next').length
			if(parseInt($('.switch-sound.next').position().left) < $("body").scrollLeft())
				nextAudio = document.getElementById($('.switch-sound.next').attr('data-sound'))
				console.log(nextAudio)
				switchSounds(audio, nextAudio)
				audio = nextAudio
				# Add next/prev class on switch imgs
				currentSwitch = $('.switch-sound.next')
				nextSwitch = $('.switch-sound.next').nextAll('.switch-sound').first()
				prevSwitch = $('.switch-sound.next').prevAll('.switch-sound').first()
				$('.switch-sound').removeClass("next").removeClass("current").removeClass("prev")
				nextSwitch.addClass("next")
				prevSwitch.addClass("prev")
				currentSwitch.addClass("current")

		if(parseInt($('.switch-sound.current').position().left) > $("body").scrollLeft())
			prevAudio = document.getElementById($('.switch-sound.prev').attr('data-sound'))
			switchSounds(audio, prevAudio)
			audio = prevAudio
			# Add next/prev class on switch imgs
			currentSwitch = $('.switch-sound.prev')
			nextSwitch = $('.switch-sound.current')
			prevSwitch = $('.switch-sound.prev').prevAll('.switch-sound').first()
			$('.switch-sound').removeClass("next")
			$('.switch-sound').removeClass("current")
			$('.switch-sound').removeClass("prev")
			nextSwitch.addClass("next")
			prevSwitch.addClass("prev")
			currentSwitch.addClass("current")


	$('.volume').on "click", (ev) ->
		if $(this).hasClass('icon-volume-up')
			$(this).removeClass().addClass('icon-volume-off')
			fadeOutSound()
		else
			$(this).removeClass().addClass('icon-volume-up')
			fadeInSound()


preload = (imageArray, index, selectedSound) ->
	index = index || 0
	selectedSound = selectedSound || 1
	if imageArray && imageArray.length > index
		img = new Image
		if index == 0
			$(img).addClass("switch-sound current")
			$(img).attr("data-sound", "sound-1")		
		if($.inArray(index, switchSoundsPositions) > -1)
			$(img).addClass("switch-sound")
			$(img).attr("data-sound", "sound-"+selectedSound)
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
	next = next || false
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
		if (vol < 1)
			vol += 0.05 
			vol = Math.round(vol*100)/100
			audio.volume = vol
		else
			clearInterval(fadeinInterval)
	), 40

switchSounds = (prev, next) ->
	volPrev = prev.volume
	fadeoutInterval = setInterval ( ->
		if (volPrev > 0)
			volPrev -= 0.05 
			volPrev = Math.round(volPrev*100)/100
			prev.volume = volPrev
		else
			prev.pause()
			clearInterval(fadeoutInterval) 
			next.volume = 0
			next.play()
			volNext = 0 
			fadeinInterval = setInterval ( ->
				if (volNext < 1)
					volNext += 0.05 
					volNext = Math.round(volNext*100)/100
					next.volume = volNext
				else
					clearInterval(fadeinInterval)
			), 40
	), 40
