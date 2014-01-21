restify-dev-logger
==================

Like connect's logger('dev'), but for restify. You know, that thing everyone uses in expressjs.

Usage: first npm install restify-dev-logger, then do something like

    var logger = require('restify-dev-logger');
    restifyServer.use(logger.dev);

It will print a line with pretty colors for every request that hits the restify server. This is extremely handy for development. 
