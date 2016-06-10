box.cfg {
    work_dir = "/data",
    listen = 3301,
    slab_alloc_arena = 0.256
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
        userId = 'user_id'
    },
    space = box.schema.create_space('sessions', { if_not_exists = true })
}

box.once('sessions_index', function()
    sBox.space:create_index(sBox.index.token, { type = 'HASH', parts = { sBox.col.token, 'STR' } })
    sBox.space:create_index(sBox.index.userId, { unique = false, parts = { sBox.col.userId, 'NUM' } })
end)
box.schema.user.grant('guest', 'read,write,execute', 'universe', nil, { if_not_exists = true })

return sBox