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