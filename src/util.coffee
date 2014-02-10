

ms2minsec = (ms) ->
    allseconds = ms / 1000
    minutes = Math.floor allseconds / 60
    seconds = Math.floor allseconds - minutes*60
    seconds = if seconds >= 10 then seconds else '0' + seconds

    return {minutes: minutes, seconds: seconds}

ms2minsecpos = (ms) ->
    {minutes, seconds} = ms2minsec(ms)
    if minutes < 0 or seconds < 0
        return {minutes: '0', seconds: '00'}
    return {minutes: minutes, seconds: seconds}


exports = {
    ms2minsec: ms2minsec,
    ms2minsecpos: ms2minsecpos
}
