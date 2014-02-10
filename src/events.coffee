exports = class Events
    constructor: (@obj) ->
        @handlersByType = {}

    on: (name, object, handler) ->
        handlers = @handlersByType[name] ?= []
        handlers.push {handler: handler, object: object}
        return @

    remove: (name) ->
        delete @handlersByType[name]

    removeSpecific: (name, object) ->
        nh = []
        for handler in @handlersByType[name] ? []
            if not (handler.object == object)
                nh.push handler
        delete @handlersByType[name]
        if nh.length > 0
            @handlersByType[name] = nh

    removeAll: ->
        @handlersByType = {}

    trigger: (name, arg1, arg2, arg3, arg4, arg5, arg6) ->
        handlers = @handlersByType[name]
        if handlers
            for handler in handlers
                handler.handler.call(@obj, arg1, arg2, arg3, arg4, arg5, arg6)
        return
