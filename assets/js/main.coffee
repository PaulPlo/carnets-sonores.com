$ 			= require 'jquery-browserify'
mousewheel	= require('jquery-mousewheel')($)
gsap 		= require 'gsap'
modernizr 	= require('./lib/modernizr')

#  VARS
slidesInnerWidth = 0
imgsWidth = 0
audio = document.getElementById("sound-0")
nextAudio = false
switchSoundsPositions = [2,16,27,38,48,56,68,74,78,85] 
first = true

$ ->

	$.getJSON("http://46.101.190.114/carnets-sonores/data.json", (data) ->
		preload(data.imagesSources)
	)

	$(".cta-start-on").on "click", (ev) ->
		audio.play()
		$('.slides-container').css('overflow', 'visible')
		tlStart = new TimelineLite
		tlStart.to($('.intro-overlay'), 0.3, {autoAlpha : 0, ease:Quad.easeOut})
		tlStart.addLabel("showSlider")
		tlStart.fromTo($('.slides-container'), 0.3, {autoAlpha : 0}, {autoAlpha:1, ease:Quad.easeOut}, "showSlider")
		tlStart.fromTo($('.slides-container'), 0.7, {x :50}, {x:0, ease:Quad.easeOut}, "showSlider") 

	$("html, body").mousewheel (event) ->
		event.preventDefault();
		this.scrollLeft -= (event.deltaY*1.5)
		
		scrollLeftVal = $("body").scrollLeft()
		if scrollLeftVal == 0 # fix for firefox
			scrollLeftVal = $("html, body").scrollLeft()

		if $('.switch-sound.next').length
			if(parseInt($('.switch-sound.next').position().left) < scrollLeftVal)
				nextAudio = document.getElementById($('.switch-sound.next').attr('data-sound'))
				switchSounds(audio)
				audio = nextAudio
				# Add next/prev class on switch imgs
				currentSwitch = $('.switch-sound.next')
				nextSwitch = $('.switch-sound.next').nextAll('.switch-sound').first()
				prevSwitch = $('.switch-sound.next').prevAll('.switch-sound').first()
				$('.switch-sound').removeClass("next").removeClass("current").removeClass("prev")
				nextSwitch.addClass("next")
				prevSwitch.addClass("prev")
				currentSwitch.addClass("current")
				# preload next sound to play
				nextAudio = document.getElementById($('.switch-sound.next').attr('data-sound'))
				$(nextAudio).attr('preload', 'auto')

		if(parseInt($('.switch-sound.current').position().left) > scrollLeftVal)
			prevAudio = document.getElementById($('.switch-sound.prev').attr('data-sound'))
			switchSounds(audio)
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

	$("html, body").on "touchend", (event) ->

		scrollLeftVal = window.pageXOffset
		console.log "scrollpos : "+scrollLeftVal
		console.log "next position : "+$('.switch-sound.next').attr("data-offset")

		if $('.switch-sound.next').length
			if(parseInt($('.switch-sound.next').attr("data-offset")) < scrollLeftVal)
				console.log("ok")
				nextAudio = document.getElementById($('.switch-sound.next').attr('data-sound'))
				switchSoundsTouch(audio, nextAudio)
				audio = nextAudio
				# Add next/prev class on switch imgs
				currentSwitch = $('.switch-sound.next')
				nextSwitch = $('.switch-sound.next').nextAll('.switch-sound').first()
				prevSwitch = $('.switch-sound.next').prevAll('.switch-sound').first()
				$('.switch-sound').removeClass("next").removeClass("current").removeClass("prev")
				nextSwitch.addClass("next")
				prevSwitch.addClass("prev")
				currentSwitch.addClass("current")
				# preload next sound to play
				nextAudio = document.getElementById($('.switch-sound.next').attr('data-sound'))
				$(nextAudio).attr('preload', 'auto')

		if(parseInt($('.switch-sound.current').position().left) > scrollLeftVal)
			prevAudio = document.getElementById($('.switch-sound.prev').attr('data-sound'))
			switchSoundsTouch(audio, prevAudio)
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
			$(img).attr("data-sound", "sound-0")		
		if($.inArray(index, switchSoundsPositions) > -1)
			$(img).addClass("switch-sound")
			$(img).attr("data-sound", "sound-"+selectedSound)
			$(img).attr("data-offset", imgsWidth)
			if first
				$(img).addClass("next")
				first = false
			selectedSound++
		img.src = "img/"+imageArray[index]
		img.onload = ->	
			$('.slides-inner').append(img)
			slidesInnerWidth += img.width + 20 # adding img margin value
			imgsWidth += $(img).width() + 20
			$('.slides-inner').width(slidesInnerWidth)
			preload(imageArray, index + 1, selectedSound)

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

switchSounds =  (prev) ->
	volPrev = prev.volume
	fadeoutInterval = setInterval ( ->
		if (volPrev > 0)
			volPrev -= 0.05 
			volPrev = Math.round(volPrev*100)/100
			prev.volume = volPrev
		else
			clearInterval(fadeoutInterval) 
			next = document.getElementById($('.switch-sound.current').attr('data-sound'))
			next.volume = 0
			prev.pause() ; 
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

switchSoundsTouch = (prev, next) ->
	$("html, body").on "touchstart", (event) ->
		prev.pause()
		next.play()
		$(this).unbind("touchstart")			
