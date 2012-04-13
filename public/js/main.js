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
        return $('#profile-info').html('<a href="/profile">' + info.email + (" (" + info._id + ")</a>")).show('slide');
      }
    };
    login_logout = function(assertion) {
      var url;
      if (assertion === null) {
        url = '/api/logout';
      } else {
        url = '/api/login';
      }
      return $.ajax({
        type: 'POST',
        url: url,
        data: {
          assertion: assertion
        },
        success: function(res, status, xhr) {
          return logged_in(res);
        },
        error: function(res, status, xhr) {
          return alert("Login/Logout failure" + res);
        }
      });
    };
    $('#profile-info').hide();
    $('#profile-login').click(function() {
      return navigator.id.get(login_logout);
    });
    $('#profile-logout').hide().click(function() {
      return login_logout(null);
    });
    return $.getJSON('/api/profile', function(data) {
      return logged_in(data);
    });
  });

}).call(this);
