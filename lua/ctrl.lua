local sBox = require '/lua/sBox'

local function rendSuccess(req, data)
    return req:render { json = { status = 'success', data = data } }
end

local function rendError(req, message, code)
    return req:render { json = { status = 'error', message = message, code = code } }
end


local function test(req)
    local host = req.peer.host
    local response = {
        host = host;
    }
    return req:render { json = response }
end

return {
    test = test
}