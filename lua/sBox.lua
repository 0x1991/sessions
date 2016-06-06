box.cfg {
    work_dir = "/data",
    listen = 3301,
    slab_alloc_arena = 0.256
}

local spaceName = 'sessions'

local sBox = {
    col = {
        token = 1,
        userId = 2,
        ip = 3,
        create = 4,
        activity = 5,
        info = 6
    },
    index = {
        token = 'token',
        userId_activity = 'user_id_activity'
    },
    space = box.space[spaceName]
}

if not sBox.space then sBox.space = box.schema.create_space(spaceName) end

box.once('sessions_tokenIndex', function()
    sBox.space:create_index(sBox.index.token, {
        type = 'HASH',
        parts = { sBox.col.token, 'STR' }
    })
end)

box.schema.user.grant('guest', 'read,write,execute', 'universe', nil, { if_not_exists = true })

return sBox