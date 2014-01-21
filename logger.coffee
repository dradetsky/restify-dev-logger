bytes = require 'bytes'

devLogLine = (useColor) ->
  return (req, res) ->
    status = res.statusCode
    len = parseInt res.getHeader('Content-Length'), 10

    if status >= 500
      color = 31
    else if status >= 400
      color = 33
    else if status >= 300
      color = 36
    else
      color = 32

    if isNaN len
      len_s = ''
    else
      len_s = ' - ' + bytes len

    # colors
    ansi_grey = '\x1b[90m'
    ansi_color_for_status = '\x1b[' + color + 'm'
    ansi_clear = '\x1b[0m'

    line = ""
    line += ansi_grey if useColor
    line += req.method + ' '
    line += (req.originalUrl || req.url) + ' '
    line += ansi_color_for_status if useColor
    line += status + ' '
    line += ansi_grey if useColor
    line += (new Date - req._startTime) + 'ms'
    line += len_s
    line += ansi_clear
    
    return line

makeLogger = (logfn) ->
  stream = process.stdout
  return (req, res, next) ->
    req._startTime = new Date

    logRequest = ->
      res.removeListener 'finish', logRequest
      res.removeListener 'close', logRequest
      line = logfn(req, res)
      stream.write line + '\n' unless line is null

    res.on 'finish', logRequest
    res.on 'close', logRequest
    next()

dev = makeLogger(devLogLine(true))

devbw = makeLogger(devLogLine(false))

exports.dev = dev
exports.devbw = devbw
