define('/main', function(exports, require) {
  var Game, Main, Objective, Timer;
  Timer = require('timer');
  Game = require('game');
  Objective = require('objective');
  Main = (function() {
    function Main() {
      var bc, oc, rc;
      this.game = new Game($('.game-controls'));
      oc = [
        {
          bg: '#8aea01',
          fg: 'black'
        }, {
          bg: 'orange',
          fg: 'black'
        }, {
          bg: 'red',
          fg: 'black'
        }
      ];
      bc = [
        {
          bg: '#8aea01',
          fg: 'blue'
        }, {
          bg: 'orange',
          fg: 'blue'
        }, {
          bg: 'red',
          fg: 'blue'
        }
      ];
      rc = [
        {
          bg: '#8aea01',
          fg: 'red'
        }, {
          bg: 'orange',
          fg: 'red'
        }, {
          bg: 'red',
          fg: 'white'
        }
      ];
      this.objectives = {
        baron: new Objective(this.game, 900000, 420000, -1, false, false, oc, $('#nashor')),
        dragon: new Objective(this.game, 150000, 360000, -1, false, false, oc, $('#dragon')),
        oblue: new Objective(this.game, 115000, 300000, -1, false, true, bc, $('#oblue')),
        tblue: new Objective(this.game, 115000, 300000, 30000, true, true, bc, $('#tblue')),
        ored: new Objective(this.game, 115000, 300000, -1, false, true, rc, $('#ored')),
        tred: new Objective(this.game, 115000, 300000, 30000, true, true, rc, $('#tred'))
      };
      this.game.callback();
    }

    return Main;

  })();
  $(function() {
    $('.btn').button();
    return new Main();
  });
  return exports;
});

define('/util', function(exports, require) {
  var ms2minsec, ms2minsecpos;
  ms2minsec = function(ms) {
    var allseconds, minutes, seconds;
    allseconds = ms / 1000;
    minutes = Math.floor(allseconds / 60);
    seconds = Math.floor(allseconds - minutes * 60);
    seconds = seconds >= 10 ? seconds : '0' + seconds;
    return {
      minutes: minutes,
      seconds: seconds
    };
  };
  ms2minsecpos = function(ms) {
    var minutes, seconds, _ref;
    _ref = ms2minsec(ms), minutes = _ref.minutes, seconds = _ref.seconds;
    if (minutes < 0 || seconds < 0) {
      return {
        minutes: '0',
        seconds: '00'
      };
    }
    return {
      minutes: minutes,
      seconds: seconds
    };
  };
  exports = {
    ms2minsec: ms2minsec,
    ms2minsecpos: ms2minsecpos
  };
  return exports;
});

var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

define('/objective', function(exports, require) {
  var GREEN, OBJECTIVE_HTML, Objective, RED, YELLOW;
  OBJECTIVE_HTML = '        <div class="inner-box">\n            <div class="row upper-row">\n                <div class="col-md-12">\n                    <span class="name OBJECTIVE_ID">OBJECTIVE_TITLE</span>\n                    <span class="time OBJECTIVE_ID-time"></span>\n                </div>\n            </div>\n\n            <div class="row spacer"></div>\n\n            <div class="row lower-row">\n                <div class="col-md-12 controls">\n                    <button type="button" class="btn btn-default btn-xs btn-mute"><span class="glyphicon glyphicon-volume-up"></span></button>\n                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt=" 1000"><b>+</b>1s</button>\n                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt="-1000"><b>-</b></span>1s</button>\n                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt=" 10000"><b>+</b></span>10s</button>\n                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt="-10000"><b>-</b></span>10s</button>\n                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt=" 60000"><b>+</b></span>1m</button>\n                    <button type="button" class="btn btn-default btn-xs btn-dt" data-dt="-60000"><b>-</b></span>1m</button>\n                    <button type="button" class="btn btn-default btn-xs btn-info btn-refresh"><span class="glyphicon glyphicon-refresh"></span>&nbsp;Refresh</button>\n                </div>\n            </div>\n        </div>';
  GREEN = 0;
  YELLOW = 1;
  RED = 2;
  exports = Objective = (function() {
    function Objective(game, tinitial, trefresh, tcooldown, muted, first_update, colors, element) {
      this.game = game;
      this.tinitial = tinitial;
      this.trefresh = trefresh;
      this.tcooldown = tcooldown;
      this.first_update = first_update;
      this.colors = colors;
      this.element = element;
      this.callback = __bind(this.callback, this);
      this.initial = true;
      this._schedule(this.tinitial);
      this.state = GREEN;
      this.setup();
      this.setColor(this.colors[0]);
      this.sound = true;
      if (muted) {
        this.toggle_mute();
      }
    }

    Objective.prototype.setup = function() {
      var html,
        _this = this;
      html = OBJECTIVE_HTML;
      html = html.replace(/OBJECTIVE_ID/g, this.element.attr('id')).replace(/OBJECTIVE_TITLE/g, this.element.data('name'));
      this.element.html(html);
      this.element.find('.btn-dt').on('click', function(evt) {
        return _this.delay(parseInt($(evt.currentTarget).data('dt')));
      });
      this.element.find('.btn-refresh').on('click', function(evt) {
        return _this.refresh();
      });
      return this.element.find('.btn-mute').on('click', function(evt) {
        return _this.toggle_mute();
      });
    };

    Objective.prototype._schedule = function(t) {
      return this.scheduled = this.game.schedule(t, this, this.callback);
    };

    Objective.prototype.callback = function() {
      this.initial = false;
      if (this.tcooldown >= 0) {
        return this._schedule(this.tcooldown + this.trefresh);
      }
    };

    Objective.prototype.delay = function(t) {
      var left;
      left = this.game.rmscheduled(this.scheduled, this);
      return this._schedule(left + t < 0 ? 0 : left + t);
    };

    Objective.prototype.refresh = function() {
      this.game.rmscheduled(this.scheduled, this);
      return this._schedule(this.trefresh);
    };

    Objective.prototype.toggle_mute = function() {
      var btn, states;
      btn = this.element.find('.btn-mute');
      btn.button('toggle');
      states = {
        "true": '<span class="glyphicon glyphicon-volume-off"></span>',
        "false": '<span class="glyphicon glyphicon-volume-up"></span>'
      };
      btn.html(states[this.sound]);
      return this.sound = !this.sound;
    };

    Objective.prototype.update = function(dt) {
      var changed, state;
      state = (function() {
        switch (false) {
          case !(dt < 30000):
            return RED;
          case !(dt < 90000):
            return YELLOW;
          default:
            return GREEN;
        }
      })();
      changed = !(state === this.state);
      this.state = state;
      if (changed) {
        this.first_update = !this.initial;
      }
      if (!this.initial && this.first_update && changed) {
        this.setColor(this.colors[this.state]);
        return this.playSound();
      }
    };

    Objective.prototype.setColor = function(color) {
      if ((this.color != null) && this.color.fg === color.fg && this.color.bg === color.bg) {
        return;
      }
      this.element.find('.inner-box').css('background-color', color.bg);
      return this.element.find('.name').css('color', color.fg);
    };

    Objective.prototype.playSound = function() {
      var snd;
      snd = $('#alert-sound')[0];
      if ((snd.ended || snd.paused) && this.sound && this.state !== GREEN) {
        snd.load();
        return snd.play();
      }
    };

    return Objective;

  })();
  return exports;
});

var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

define('/game', function(exports, require) {
  var Events, Game, Timer, ms2minsec, ms2minsecpos, _ref;
  Events = require('events');
  Timer = require('timer');
  _ref = require('util'), ms2minsec = _ref.ms2minsec, ms2minsecpos = _ref.ms2minsecpos;
  exports = Game = (function() {
    function Game(element) {
      var _this = this;
      this.element = element;
      this.callback = __bind(this.callback, this);
      this.events = new Events(this);
      this.timer = new Timer();
      this._poll = 333;
      this.element.find('.btn-mute').on('click', function(evt) {
        var btn, snd, states;
        btn = $(this);
        btn.button('toggle');
        states = {
          "false": '<span class="glyphicon glyphicon-volume-off"></span>',
          "true": '<span class="glyphicon glyphicon-volume-up"></span>'
        };
        snd = $('#alert-sound')[0];
        btn.html(states[snd.muted]);
        snd.muted = !snd.muted;
      });
      this.element.find('.btn-start').on('click', function(evt) {
        var text;
        text = _this.toggle() ? 'Pause' : 'Resume';
        return $(evt.currentTarget).text(text);
      });
      this.element.find('.btn-dt').on('click', function(evt) {
        return _this.delay(parseInt($(evt.currentTarget).data('dt')));
      });
    }

    Game.prototype.start = function() {
      this.id = setInterval(this.callback, this._poll);
      return this.timer.start();
    };

    Game.prototype.pause = function() {
      clearInterval(this.id);
      this.id = void 0;
      return this.timer.pause();
    };

    Game.prototype.resume = function() {
      this.id = setInterval(this.callback, this._poll);
      return this.timer.resume();
    };

    Game.prototype.toggle = function() {
      if (this.timer.started) {
        if (this.id) {
          this.pause();
        } else {
          this.resume();
        }
      } else {
        this.start();
      }
      return this.id != null;
    };

    Game.prototype.stop = function() {
      this.stop();
      return this.time = 0;
    };

    Game.prototype.delay = function(dt) {
      if ((this.timer.time() + dt) < 0) {
        dt = -this.timer.time();
      }
      return this.timer.delay(dt);
    };

    Game.prototype.callback = function() {
      var htime, lminutes, lseconds, minutes, obj, objective, objectives, seconds, time, ts, _i, _len, _ref1, _ref2, _ref3, _ref4;
      time = this.timer.time();
      ts = Math.floor(time / 1000);
      this.events.trigger(ts);
      _ref1 = ms2minsec(time), minutes = _ref1.minutes, seconds = _ref1.seconds;
      $('.game-time').text("" + minutes + ":" + seconds);
      _ref2 = this.events.handlersByType;
      for (htime in _ref2) {
        objectives = _ref2[htime];
        if (htime < ts) {
          this.events.trigger(htime);
          this.events.remove(htime);
        }
        htime = htime * 1000;
        _ref3 = ms2minsec(htime), minutes = _ref3.minutes, seconds = _ref3.seconds;
        _ref4 = ms2minsecpos(htime - time), lminutes = _ref4.minutes, lseconds = _ref4.seconds;
        for (_i = 0, _len = objectives.length; _i < _len; _i++) {
          objective = objectives[_i];
          obj = objective.object;
          obj.update(htime - time);
          obj.element.find('.time').html("" + minutes + ":" + seconds + " | " + lminutes + ":" + lseconds);
        }
      }
      return this.events.remove(ts);
    };

    Game.prototype.schedule = function(inms, object, handler) {
      this.events.on(Math.floor((this.timer.time() + inms) / 1000), object, handler);
      return this.timer.time() + inms;
    };

    Game.prototype.rmscheduled = function(t, object) {
      this.events.removeSpecific(Math.floor(t / 1000), object);
      return t - this.timer.time();
    };

    return Game;

  })();
  return exports;
});

define('/events', function(exports, require) {
  var Events;
  exports = Events = (function() {
    function Events(obj) {
      this.obj = obj;
      this.handlersByType = {};
    }

    Events.prototype.on = function(name, object, handler) {
      var handlers, _base;
      handlers = (_base = this.handlersByType)[name] != null ? (_base = this.handlersByType)[name] : _base[name] = [];
      handlers.push({
        handler: handler,
        object: object
      });
      return this;
    };

    Events.prototype.remove = function(name) {
      return delete this.handlersByType[name];
    };

    Events.prototype.removeSpecific = function(name, object) {
      var handler, nh, _i, _len, _ref, _ref1;
      nh = [];
      _ref1 = (_ref = this.handlersByType[name]) != null ? _ref : [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        handler = _ref1[_i];
        if (!(handler.object === object)) {
          nh.push(handler);
        }
      }
      delete this.handlersByType[name];
      if (nh.length > 0) {
        return this.handlersByType[name] = nh;
      }
    };

    Events.prototype.removeAll = function() {
      return this.handlersByType = {};
    };

    Events.prototype.trigger = function(name, arg1, arg2, arg3, arg4, arg5, arg6) {
      var handler, handlers, _i, _len;
      handlers = this.handlersByType[name];
      if (handlers) {
        for (_i = 0, _len = handlers.length; _i < _len; _i++) {
          handler = handlers[_i];
          handler.handler.call(this.obj, arg1, arg2, arg3, arg4, arg5, arg6);
        }
      }
    };

    return Events;

  })();
  return exports;
});

define('/timer', function(exports, require) {
  var Timer;
  exports = Timer = (function() {
    function Timer() {
      this.stime = 0;
      this.paused = false;
      this.started = false;
    }

    Timer.prototype.start = function() {
      this.started = true;
      return this.stime = Date.now();
    };

    Timer.prototype.pause = function() {
      this.paused = !this.paused;
      return this.stime = Date.now() - this.stime;
    };

    Timer.prototype.resume = function() {
      return this.pause();
    };

    Timer.prototype.stop = function() {
      var t;
      t = this.time();
      this.started = false;
      this.paused = false;
      this.stime = 0;
      return t;
    };

    Timer.prototype.delay = function(dt) {
      return this.stime = this.stime - dt;
    };

    Timer.prototype.time = function() {
      if (this.started) {
        if (this.paused) {
          return this.stime;
        } else {
          return Date.now() - this.stime;
        }
      }
      return 0;
    };

    return Timer;

  })();
  return exports;
});
