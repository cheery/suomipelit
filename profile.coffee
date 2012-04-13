class exports.MemoryStore
    constructor: () ->
        @users = {}
        @by_email = {}
        @count = 0

    upsert_email: (email, callback) ->
        user = @by_email[email]
        if user?
            callback(user)
        else
            user_id = (++@count).toString(16)
            user = {_id: user_id, email}
            @users[user_id] = @by_email[email] = user
            callback(user)

    get: (user_id, callback) ->
        callback(@users[user_id] ? null)

    update: (user_id, data, callback) ->
        user = @users[user_id]
        if user?
            for key, value of data
                user[key] = value
            callback user
        else
            callback null
