editor = CodeMirror.fromTextArea document.getElementById("code"),
  mode: "text/html"
  theme: "default"
  tabSize: 2
  indentUnit: 2
  indentWithTabs: false
  tabMode: "spaces"
  enterMode: "keep"
  electricChars: false
  lineNumbers: true
  firstLineNumber: 1
  gutter: false
  fixedGutter:false
  matchBrackets: true

setLocalStorage = (json) ->
  local = JSON.parse(localStorage.CanvasCoder || null)
  if local
    Object.assign local, json
  else
    localStorage.CanvasCoder = JSON.stringify(json)

checkFrame = (iframe) ->
  canvas = iframe[0].contentWindow.document.getElementById("bkgCanvas")
  if iframe.hasClass("frame") && iframe.attr("width") is "128"
    unless canvas
      canvas = iframe[0].contentWindow.document.body.appendChild iframe[0].contentWindow.document.createElement("canvas")
      canvas.id = "bkgCanvas"
      canvas.setAttribute "width" , "128"
      canvas.setAttribute "height", "128"
      canvas.setAttribute "style", "position:absolute;top:0px;left:0px;"
      ctx = canvas.getContext('2d')
      ctx.lineWidth = 1
      ctx.strokeStyle = "#0000FF"
      ctx.beginPath()
      ctx.moveTo 15.5, 15.5
      ctx.lineTo 111.5, 15.5
      ctx.lineTo 111.5, 111.5
      ctx.lineTo 15.5, 111.5
      ctx.lineTo 15.5, 15.5
      #ctx.closePath()
      ctx.stroke()
      #ctx.strokeRect 16, 16, 96, 96
    $(canvas).show()
  else if canvas
    $(canvas).hide()

$("button.imgResize").on "click", (event) ->
  x = event.currentTarget.getAttribute("data-x")
  y = event.currentTarget.getAttribute("data-y")
  setLocalStorage(json = { "imageSizeX": x, "imageSizeY": y })
  iframe = $("#iframeCanvas")
  iframe.attr("width", json.imageSizeX)
  iframe.attr("height", json.imageSizeY)
  top = 140 - json.imageSizeY / 2
  iframe.attr("style", "top:#{top}px")
  # if img = iframe[0].contentWindow.document.querySelector("img")
  #   img.setAttribute("width", json.imageSizeX)
  #   img.setAttribute("height", json.imageSizeY)
  checkFrame iframe

$("button.updateCanvas").on "click", (event) ->
  iframe = document.getElementById("iframeCanvas")
  blob = new Blob([editor.doc.getValue()], { type : 'text/html' })
  r = new FileReader()
  r.onload = ->
    iframe.src = r.result
  r.readAsDataURL(blob)

$("button.frameguide").on "click", (event) ->
  iframe = $("#iframeCanvas").toggleClass("frame")
  checkFrame iframe
