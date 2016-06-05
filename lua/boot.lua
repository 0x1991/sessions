#!/usr/bin/env tarantool

local function handler(self)
    local host = self.peer.host
    local response = {
        host = host;
    }
    return self:render{ json = response }
end

local httpd = require('http.server')
local server = httpd.new('0.0.0.0', 80)
server:route({ path = '/' }, handler)
server:start()