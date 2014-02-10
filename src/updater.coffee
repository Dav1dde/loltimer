

exports = class Updater
    constructor: (@timer) ->
        console.log @timer


    start: () ->
        @id = setInterval @callback, 500


    stop: () ->
        clearInterval @id


    callback: =>
        for t in @timer
            te = t.element.find '.time'
            allseconds = (t.remaining - (performance.now() - t.start)) / 1000
            minutes = Math.floor(allseconds / 60)
            seconds =  Math.floor(allseconds - minutes*60)

            te.text "#{minutes}:#{seconds}"

