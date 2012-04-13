(function() {

  $(function() {
    var logged_in, login_logout;
    logged_in = function(info) {
      if (info === null) {
        $('#profile-login').show();
        $('#profile-logout').hide();
        return $('#profile-info').fadeOut();
      } else {
        $('#profile-login').hide();
        $('#profile-logout').show();
        return $('#profile-info').html('<a href="/profile">' + info.email + '</a>').show('slide');
      }
    };
    login_logout = function(assertion) {
      if (assertion === null) {
        return logged_in(null);
      } else {
        return $.ajax({
          type: 'POST',
          url: '/api/login',
          data: {
            assertion: assertion
          },
          success: function(res, status, xhr) {
            return logged_in(res);
          },
          error: function(res, status, xhr) {
            return alert("Login failure" + res);
          }
        });
      }
    };
    $('#profile-info').hide();
    $('#profile-login').click(function() {
      return navigator.id.get(login_logout);
    });
    return $('#profile-logout').hide().click(function() {
      return logged_in(null);
    });
  });

}).call(this);
