

OBJECTIVE_HTML = '''
        <div class="inner-box">
            <div class="row upper-row">
                <div class="col-md-12">
                    <span class="name OBJECTIVE_ID">OBJECTIVE_TITLE</span>
                    <span class="time OBJECTIVE_ID-time"></span>
                </div>
            </div>

            <div class="row spacer"></div>

            <div class="row lower-row">
                <div class="col-md-12 controls">
                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt=" 1000"><b>+</b>1s</button>
                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt="-1000"><b>-</b></span>1s</button>
                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt=" 10000"><b>+</b></span>10s</button>
                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt="-10000"><b>-</b></span>10s</button>
                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt=" 60000"><b>+</b></span>1m</button>
                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt="-60000"><b>-</b></span>1m</button>
                    <button type="button" class="btn btn-default btn-xs btn-info btn-refresh"><span class="glyphicon glyphicon-refresh"></span>&nbsp;Refresh</button>
                </div>
            </div>
        </div>
'''


exports = class Objective
    constructor: (@game, @tinitial, @trefresh, @tcooldown, @colors, @element, @title) ->
        @initial = true
        @scheduled = @game.schedule @tinitial, @, @callback

        @element.find('.btn-dt').on('click', (evt) =>
            @delay parseInt $(evt.currentTarget).data('dt')
        )

        @element.find('.btn-refresh').on('click', (evt) =>
            @refresh()
        )

        @setup()
        @setColor @colors[0]

    setup: ->
        html = OBJECTIVE_HTML
        html = html.replace('OBJECTIVE_ID', @element.data 'id')
                   .replace('OBJECTIVE_TITLE', @element.data 'name')

        @element.html html

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
