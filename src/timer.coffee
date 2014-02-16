

exports = class Timer
    constructor: () ->
        @stime = 0
        @paused = false
        @started = false

    start: ->
        @started = true
        @stime = Date.now()

    pause: ->
        @paused = not @paused
        @stime = Date.now() - @stime

    resume: -> pause()

    stop: ->
        t = @time()
        @started = false
        @paused = false
        @stime = 0

        return t

    delay: (dt) ->
        @stime = @stime - dt

    time: ->
        if @started
            return if @paused then @stime else Date.now() - @stime
        return 0
