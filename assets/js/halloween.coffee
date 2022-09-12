---
---
itemCount = 0
kiteSummoned = false
cursorPosition = 
  x: window.screen.width/2
  y: window.screen.height/2
window.onmousemove = (e) ->
  cursorPosition.x = e.clientX
  cursorPosition.y = e.clientY
window.onmessage = (e) ->
  if e.data.startsWith("MOUSE")
    godotCursorPosition = e.data.replace("MOUSE","").split(",")
    cursorPosition.x = Math.round(document.querySelector("iframe").getBoundingClientRect().left+parseInt(godotCursorPosition[0]))
    cursorPosition.y = Math.round(document.querySelector("iframe").getBoundingClientRect().top+parseInt(godotCursorPosition[1]))
  else
    console.log(e.data)
    itemCount++
    if itemCount == 2
        document.getElementById("box").style.animation="0.7s cubic-bezier(.19,1,.22,1) 0.2s 1 normal none running notice"
        document.getElementById("box").scrollIntoView({behavior: "smooth"})
    if itemCount > 2
      if !kiteSummoned
        kiteSummoned = true
        kite = new kiteEgg()
        peekSFX = new Audio("/assets/sfx/kitepeek.wav")
        peekSFX.play()
        kite.chase().then (result) ->
          kite.grab().then (result2) ->
            kite.throw()
    switch e.data
      when 'candyblinkie'
        addImageLink(document.getElementById("box"),"/assets/images/blinkies/candy.gif","/assets/images/blinkies/candy.gif")
        break
      when 'jackobertblinkie'
        addImageLink(document.getElementById("box"),"/assets/images/blinkies/jackobert.gif","/assets/images/blinkies/jackobert.gif")
        break
      when 'pudeon'
        addImageLink(document.getElementById("box"),"/halloween/pudeon/","/assets/images/creatures/pudeonegg.png")
        break
      when 'olimy'
        addImageLink(document.getElementById("box"),"/halloween/olimy/","/assets/images/creatures/olimyegg.png")
        break
      when 'bacat'
        addImageLink(document.getElementById("box"),"/halloween/bacat/","/assets/images/creatures/bacategg.png")
        break
      else
        break

addImageLink = (box,link,image) ->
  a = document.createElement("a")
  a.classList.add("item")
  a.href = link
  a.target = "_blank"
  img = document.createElement("img")
  img.src = image
  box.appendChild(a.appendChild(img).parentNode)
  
class kiteEgg
  constructor: () ->
    @position = 
      x: -56
      y: -56
    @direction = 0
    ### ###
    @kiteDiv = document.createElement("div")
    @kiteDiv.style.width = "56px";@kiteDiv.style.height = "56px"
    @kiteDiv.style.top = "#{@position.y-28}px";@kiteDiv.style.left = "#{@position.x-28}px"
    @kiteDiv.style.backgroundRepeat = 'no-repeat'
    @kiteDiv.style.backgroundImage = 'url(/assets/images/kite/tiny_spiderkite_chase.gif)'
    @kiteDiv.style.position = 'fixed'
    document.body.appendChild(@kiteDiv)
  chase: ->
    thisKite = this
    playing = true
    stepSFX = new Audio("/assets/sfx/kiterun.wav")
    stepSFX.loop = true
    stepSFX.play()
    return new Promise (resolve, reject) ->
      chaseLoop = () ->
        thisKite.direction = Math.atan2(cursorPosition.y-thisKite.position.y,cursorPosition.x-thisKite.position.x)
        thisKite.position.x += Math.cos(thisKite.direction)*6
        thisKite.position.y += Math.sin(thisKite.direction)*6
        thisKite.kiteDiv.style.top = "#{thisKite.position.y-28}px";thisKite.kiteDiv.style.left = "#{thisKite.position.x-28}px"
        thisKite.kiteDiv.onmouseover = (e) =>
          thisKite.kiteDiv.onmouseover = null
          stepSFX.pause()
          playing = false
          resolve "Gotcha!"
        if !playing then return
        window.requestAnimationFrame(chaseLoop)
      window.requestAnimationFrame(chaseLoop)
  grab: ->
    @kiteDiv.style.backgroundImage = 'url(/assets/images/kite/tiny_spiderkite_grab.png)'
    document.body.requestPointerLock()
    document.body.appendChild(document.createElement("style")).innerHTML="*{cursor:none !important;pointer-events:none !important;user-select: none !important;}html,body{overflow:hidden !important}"
    return new Promise (resolve, reject) ->
      setTimeout () =>
        resolve()
      ,500
  throw: ->
    thisKite = this
    playing = true
    @kiteDiv.style.backgroundImage = 'url(/assets/images/kite/tiny_spiderkite_throw.gif)'
    setTimeout () =>
      fakeCursor = document.createElement("img")
      fakeCursor.src="/assets/cursors/cursor.png"
      fakeCursor.style.position = "fixed"
      fakeCursor.style.top = "#{thisKite.position.y-22}px";fakeCursor.style.left = "#{thisKite.position.x-22}px"
      document.body.appendChild(fakeCursor)
      throwOffset = 0
      throwLoop = () ->
        throwOffset+=8
        fakeCursor.style.top = "#{thisKite.position.y-22-throwOffset}px";fakeCursor.style.left = "#{thisKite.position.x-22+throwOffset}px"
        if thisKite.position.y-22-throwOffset<-32
          playing = false
          window.location.href = "https://webring.yesterweb.org/noJS/index.php?d=rand"
        if !playing then return
        window.requestAnimationFrame(throwLoop)
      window.requestAnimationFrame(throwLoop)
    ,600
