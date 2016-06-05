#! /usr/bin/env tarantool
ctrl = require '/lua/ctrl'

local server = require('http.server').new('0.0.0.0', 80)
server:route({ path = '/' }, ctrl.test)
server:start()