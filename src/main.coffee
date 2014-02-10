Updater = require 'updater'
Timer = require 'timer'
Game = require 'game'
Objective = require 'objective'


class Main
    constructor: () ->
        #@timer = []
        #@timer.push new Timer 900000, 420000, $('#nashor')
        #@timer.push new Timer 150000, 360000, $('#dragon')
        #@timer.push new Timer 115000, 300000, $('#oblue')
        #@timer.push new Timer 115000, 300000, $('#tblue')
        #@timer.push new Timer 115000, 300000, $('#ored')
        #@timer.push new Timer 115000, 300000, $('#tred')

        #for t in @timer
        #    t.resume()

        #@updater = new Updater @timer
        #@updater.start()

        oc = [{bg: '#8aea01', fg: 'black'}, {bg: 'orange', fg: 'black'}, {bg: 'red', fg: 'black'}]
        bc = [{bg: '#8aea01', fg: 'blue'},  {bg: 'orange', fg: 'blue'},  {bg: 'red', fg: 'blue'}]
        rc = [{bg: '#8aea01', fg: 'red'},   {bg: 'orange', fg: 'red'},   {bg: 'red', fg: 'white'}]


        @game = new Game $('.game-controls')

        @objectives = {
            #                            Spawn   Respawn Cooldown
            baron:  new Objective @game, 900000, 420000, -1,    oc, $('#nashor'),
            dragon: new Objective @game, 150000, 360000, -1,    oc, $('#dragon'),
            oblue:  new Objective @game, 115000, 300000, -1,    bc,  $('#oblue'),
            tblue:  new Objective @game, 115000, 300000, 10000, bc,  $('#tblue'),
            ored:   new Objective @game, 115000, 300000, -1,    rc,  $('#ored'),
            tred:   new Objective @game, 115000, 300000, 10000, rc,  $('#tred'),
        }

        # Show spawn-times
        @game.callback()



# main entry
$ ->
    #console.log 'Hello World'

    new Main()