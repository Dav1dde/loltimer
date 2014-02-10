

exports = class Timer
    constructor: () ->
        @stime = 0
        @paused = false
        @started = false

    start: ->
        @started = true
        @stime = performance.now()

    pause: ->
        @paused = not @paused
        @stime = performance.now() - @stime

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
            return if @paused then @stime else performance.now() - @stime
        return 0
