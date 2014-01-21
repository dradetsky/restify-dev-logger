bytes = require 'bytes'

devLogLine = (req, res) ->
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

  # log_str = '\x1b[90m' + req.method
  #   + ' ' + (req.originalUrl || req.url) + ' '
  #   + '\x1b[' + color + 'm' + status
  #   + ' \x1b[90m'
  #   + (new Date - req._startTime)
  #   + 'ms' + len_s
  #   + '\x1b[0m'

  log_str = '\x1b[90m' + req.method + ' ' + (req.originalUrl || req.url) + ' '    + '\x1b[' + color + 'm' + status     + ' \x1b[90m'     + (new Date - req._startTime)     + 'ms' + len_s     + '\x1b[0m'

  return log_str

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

dev = makeLogger(devLogLine)

exports.dev = dev
