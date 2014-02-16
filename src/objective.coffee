

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
                    <button type="button" class="btn btn-default btn-xs btn-mute"><span class="glyphicon glyphicon-volume-up"></span></button>
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

GREEN = 0
YELLOW = 1
RED = 2

exports = class Objective
    constructor: (@game, @tinitial, @trefresh, @tcooldown, muted, @first_update, @colors, @element) ->
        @initial = true
        #@scheduled = @game.schedule @tinitial, @, @callback
        @_schedule @tinitial

        @state = GREEN

        @setup()
        @setColor @colors[0]

        @sound = true
        if muted then @toggle_mute()

    setup: ->
        html = OBJECTIVE_HTML
        html = html.replace('OBJECTIVE_ID', @element.data 'id')
                   .replace('OBJECTIVE_TITLE', @element.data 'name')

        @element.html html

        @element.find('.btn-dt'     ).on 'click', (evt) => @delay parseInt $(evt.currentTarget).data('dt')
        @element.find('.btn-refresh').on 'click', (evt) => @refresh()
        @element.find('.btn-mute'   ).on 'click', (evt) => @toggle_mute()

    _schedule: (t) ->
        @scheduled = @game.schedule t, @, @callback

    callback: =>
        @initial = false
        if @tcooldown >= 0
            @_schedule @tcooldown + @trefresh

    delay: (t) ->
        left = @game.rmscheduled @scheduled, @
        @_schedule if left + t < 0 then 0 else left + t

    refresh: () ->
        @game.rmscheduled @scheduled, @
        @_schedule @trefresh

    toggle_mute: ->
        btn = @element.find('.btn-mute')
        btn.button 'toggle'

        states = {
            true: '<span class="glyphicon glyphicon-volume-off"></span>'
            false:'<span class="glyphicon glyphicon-volume-up"></span>'
        }

        btn.html states[@sound]
        @sound = not @sound

    update: (dt) ->
        state = switch
            when dt < 30000 then RED
            when dt < 90000 then YELLOW
            else GREEN

        changed = not (state == @state)
        @state = state

        if changed then @first_update = not @initial

        if not @initial and @first_update and changed
            @setColor @colors[@state]
            @playSound()


    setColor: (color) ->
        if @color? and @color.fg == color.fg and @color.bg == color.bg then return

        @element.find('.inner-box').css('background-color', color.bg)
        @element.find('.name').css('color', color.fg)

    playSound: ->
        snd = $('#alert-sound')[0]
        if (snd.ended or snd.paused) and @sound and @state != GREEN
            snd.load()
            snd.play()