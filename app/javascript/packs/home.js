function updateUI(callback) {
  // setValues()
  // updateUILabels()

  getProfile(function (data) {
    updateProfile(data.email, data.license_key)
    $('#sign-in').hide()
    $('#sign-out').show()
    if (callback) {
      callback()
    }
  }, function () {
    updateProfile('Visitor')
    $('#sign-in').show()
    $('#sign-out').hide()
    if (callback) {
      callback()
    }
  })
}

function updateProfile(email, licenseKey) {
  $('#profile-email').val(email)
  $('#license-key').val(licenseKey)
}

function getProfile(done, fail) {
  const url = '/api/user' // api_user_path
  $.get(url).done(function (data) {
    done(data)
  }).fail(function () {
    fail()
  })
}


$(function () {
  updateUI(function () {
    $('#main-content').show()
  })

})
