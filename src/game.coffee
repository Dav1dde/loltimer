Events = require 'events'
Timer = require 'timer'
{ms2minsec, ms2minsecpos} = require 'util'


exports = class Game
    constructor: (@element) ->
        @events = new Events @

        @timer = new Timer()
        @_poll = 333

        @element.find('.btn-start').on('click', (evt) =>
            text = if @toggle() then 'Pause' else 'Resume'
            $(evt.currentTarget).text(text)
        )

        @element.find('.btn-dt').on('click', (evt) =>
            @delay parseInt $(evt.currentTarget).data('dt')
        )

    start: ->
        @id = setInterval @callback, @_poll
        @timer.start()

    pause: ->
        clearInterval @id
        @id = undefined
        @timer.pause()

    resume: ->
        @id = setInterval @callback, @_poll
        @timer.resume()

    toggle: ->
        if @timer.started
            if @id then @pause() else @resume()
        else
            @start()
        return @id?

    stop: ->
        @stop()
        @time = 0

    delay: (dt) ->
        # time is 0:05 dt is -10s make dt -5s
        if (@timer.time() + dt) < 0 then dt = -@timer.time()
        @timer.delay dt

    callback: () =>
        time = @timer.time()
        ts = Math.floor time / 1000

        @events.trigger ts

        {minutes, seconds} = ms2minsec(time)
        $('.game-time').text "#{minutes}:#{seconds}"

        for htime, objectives of @events.handlersByType
            if htime < ts
                @events.trigger htime
                @events.remove htime

            htime = htime*1000
            {minutes, seconds} = ms2minsec(htime)
            {minutes:lminutes, seconds:lseconds} = ms2minsecpos(htime - time)

            for objective in objectives
                obj = objective.object
                obj.updateColor(htime - time)
                obj.element.find('.time').html("#{minutes}:#{seconds} | #{lminutes}:#{lseconds}")

        @events.remove ts


    schedule: (inms, object, handler) ->
        @events.on Math.floor((@timer.time() + inms) / 1000), object, handler
        return @timer.time() + inms

    rmscheduled: (t, object) ->
        @events.removeSpecific Math.floor(t / 1000), object
        return t - @timer.time()

