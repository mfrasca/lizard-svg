getObjectClass = (obj) ->
    if (obj && obj.constructor && obj.constructor.toString)
       arr = obj.constructor.toString().match(
            /function\s*(\w+)/);

        if (arr && arr.length == 2)
            return arr[1]

    return undefined;


class Slider
  constructor: (@itemId, @managed=[]) ->
    @slider = $('#' + @itemId).slider
      value: 0
      orientation: "horizontal"
      min: 0
      max: 255
      length: 255
      animate: true
      # create: $.proxy(@onCreate, this)
      slide: $.proxy(@onSlide, this)
      change: $.proxy(@onChange, this)

  initialize: ->
    console.log "initializing"
    console.log @slider
    @slider.triggerHandler('slide', null, value: 0)
    @slider.triggerHandler('change', null, value: 0)

  onChange: (event, ui) ->
    that = this
    rioolgemalen = [{key: i.key} for i in @managed when i.key.indexOf("pomprg") == 0]
    #$.get "/api/update/?keys=#{rioolgemalen}",
    #    (data) -> that.updateLabels data
    $.post "/api/update/",
        timestamp: ui.value
        keys: rioolgemalen,
        (data) -> that.updateLabels data

  onSlide: (event, ui) ->
    for item in @managed
        key = item.key
        for candidate in item.value
          if candidate.timestamp > ui.value
            break
        setStyleSub(key, 'stroke', candidate.color)
    null

  updateLabels: (data) ->
    for key, value of data
        key = key.substr(4)
        $("#" + key)[0].childNodes[0].nodeValue = value

  manageObject: (item) ->
    that = this
    $.get "/api/bootstrap/?item=#{item}",
      (data) ->
        that.managed.push
          key: item
          value: data


dec2hex = (i) ->
   ((i >> 0) + 0x10000).toString(16).substr(-2)


setStyleSub = (itemId, sub, value) ->
  re = new RegExp(sub + ":[^;]+;","g");
  item = $("#" + itemId)
  styleOrig = item.attr('style')
  item.attr('style', styleOrig.replace re, "#{sub}:#{value};")


$('document').ready ->
  window.slider = new Slider('mySliderDiv')
  for element in $("path")
    if element.id.indexOf("leiding") == 0
      window.slider.manageObject(element.id)
  for element in $("circle")
    if element.id.indexOf("pomprg") == 0
      window.slider.manageObject(element.id)
