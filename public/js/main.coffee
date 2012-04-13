$ ->
    logged_in = (info) ->
        if info == null
            $('#profile-login').show()
            $('#profile-logout').hide()
            $('#profile-info').fadeOut()
        else
            $('#profile-login').hide()
            $('#profile-logout').show()
            $('#profile-info').html('<a href="/profile">'+info.email+'</a>').show('slide')

    login_logout = (assertion) ->
        if assertion == null
            logged_in null
        else
            $.ajax
                type: 'POST'
                url: '/api/login'
                data: { assertion: assertion }
                success: (res, status, xhr) -> logged_in(res)
                error: (res, status, xhr) ->
                  alert "Login failure" + res # this is wrong, but trained in browserid quick setup

    $('#profile-info').hide()
    $('#profile-login').click -> navigator.id.get login_logout
    $('#profile-logout').hide().click -> logged_in null
