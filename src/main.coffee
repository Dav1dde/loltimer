Timer = require 'timer'
Game = require 'game'
Objective = require 'objective'


class Main
    constructor: () ->
        @game = new Game $('.game-controls')

        oc = [{bg: '#8aea01', fg: 'black'}, {bg: 'orange', fg: 'black'}, {bg: 'red', fg: 'black'}]
        bc = [{bg: '#8aea01', fg: 'blue'},  {bg: 'orange', fg: 'blue'},  {bg: 'red', fg: 'blue'}]
        rc = [{bg: '#8aea01', fg: 'red'},   {bg: 'orange', fg: 'red'},   {bg: 'red', fg: 'white'}]

        @objectives = {
            #                            Spawn   Respawn Cooldown Muted  FU
            baron:  new Objective @game, 900000, 420000, -1,      false, false, oc, $('#nashor')
            dragon: new Objective @game, 150000, 360000, -1,      false, false, oc, $('#dragon')
            oblue:  new Objective @game, 115000, 300000, -1,      false, true,  bc, $('#oblue')
            tblue:  new Objective @game, 115000, 300000, 30000,   true,  true,  bc, $('#tblue')
            ored:   new Objective @game, 115000, 300000, -1,      false, true,  rc, $('#ored')
            tred:   new Objective @game, 115000, 300000, 30000,   true,  true,  rc, $('#tred')
        }

        # Show spawn-times
        @game.callback()



# main entry
$ ->
    $('.btn').button()

    new Main()