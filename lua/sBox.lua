local fiber = require 'fiber'

box.cfg {
    work_dir = "/data",
    listen = 3301,
    slab_alloc_arena = 0.256,
    snapshot_period = 3600
}

local sBox = {
    col = {
        token = 1,
        userId = 2,
        ip = 3,
        create = 4,
        activity = 5,
        extra = 6
    },
    index = {
        token = 'token',
        userId = 'user_id',
        ip = 'ip',
        activity = 'activity'
    },
    space = box.schema.create_space('sessions', { if_not_exists = true })
}

box.once('sessions_index', function()
    sBox.space:create_index(sBox.index.token, { type = 'HASH', parts = { sBox.col.token, 'STR' } })
    sBox.space:create_index(sBox.index.userId, { unique = false, parts = { sBox.col.userId, 'NUM' } })
    sBox.space:create_index(sBox.index.ip, { unique = false, parts = { sBox.col.ip, 'STR' } })
    sBox.space:create_index(sBox.index.activity, { unique = false, parts = { sBox.col.activity, 'NUM' } })
end)
box.schema.user.grant('guest', 'read,write,execute', 'universe', nil, { if_not_exists = true })

fiber.create(function()
    local exTime = 15552000 -- 180 days
    while 0 == 0 do
        local time = math.floor(fiber.time())
        local tuples = sBox.space.index[sBox.index.activity]:select({ time - exTime }, { iterator = 'LT' })
        for i = 1, #tuples, 1 do sBox.space:delete(tuples[i][sBox.col.token]) end
        fiber.sleep(100)
    end
end)

return sBox