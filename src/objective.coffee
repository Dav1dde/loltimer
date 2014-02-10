

exports = class Objective
    constructor: (@game, @tinitial, @trefresh, @tcooldown, @colors, @element) ->
        @initial = true
        @scheduled = @game.schedule @tinitial, @, @callback

        @element.find('.btn-dt').on('click', (evt) =>
            @delay parseInt $(evt.currentTarget).data('dt')
        )

        @element.find('.btn-refresh').on('click', (evt) =>
            @refresh()
        )

        @setColor @colors[0]

    _schedule: (t) ->
        @initial = false
        @scheduled = @game.schedule t, @, @callback

    callback: =>
        if @tcooldown >= 0
            @_schedule @tcooldown + @trefresh

    delay: (t) ->
        left = @game.rmscheduled @scheduled, @
        @_schedule if left + t < 0 then 0 else left + t

    refresh: () ->
        @game.rmscheduled @scheduled, @
        @_schedule @trefresh

    updateColor: (dt) ->
        color = switch
            when dt < 30000 then @colors[2]
            when dt < 90000 then @colors[1]
            else @colors[0]
        if not @initial then @setColor color


    setColor: (color) ->
        if @color? and @color.fg == color.fg and @color.bg == color.bg then return

        @element.find('.inner-box').css('background-color', color.bg)
        @element.find('.name').css('color', color.fg)
