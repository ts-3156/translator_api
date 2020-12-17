import {Preferences} from './preferences'
import {I18n} from './i18n'

function updateUILabels() {
  const pref = new Preferences()
  const i18n = new I18n(pref.language())

  $('#language-title').text(i18n.t('language'))
  $('#web-store-description').text(i18n.t('web_store_description'))
  $('#web-store-link').text(i18n.t('web_store_link'))
  $('#options-page-description').text(i18n.t('options_page_description'))
  $('#options-page-link').text(i18n.t('options_page_link'))
  $('#account-title').text(i18n.t('account'))
  $('.sign-in-text').html(i18n.t('sign_in'))
  $('.sign-out-text').html(i18n.t('sign_out'))
  $('#license-key-title').text(i18n.t('license_key'))
  $('#enter-license-key-text').html(i18n.t('enter_license_key', {url: process.env.EXTENSION_OPTIONS_URL}))
  $('#support-account-title').text(i18n.t('support_account'))
  $('#privacy-policy-title').text(i18n.t('privacy_policy'))
  $('#terms-of-service-title').text(i18n.t('terms_of_service'))
  $('#plan-title').text(i18n.t('plan'))
  $('#free-plan-description').html(i18n.t('free_plan_description', {url: process.env.EXTENSION_OPTIONS_URL}))
  $('#pro-plan-description').text(i18n.t('pro_plan_description'))
  $('#visitor-plan-description').html(i18n.t('visitor_plan_description'))
  $('#free-plan-name').text(i18n.t('free_plan_name'))
  $('#free-plan-audience').text(i18n.t('free_plan_audience'))
  $('#free-plan-price-amount').text(i18n.t('free_plan_price_amount'))
  $('#free-plan-price-description').text(i18n.t('free_plan_price_description'))
  $('#free-plan-features').text(i18n.t('free_plan_features'))
  $('#free-plan-characters-per-translation').text(i18n.t('free_plan_characters_per_translation'))
  $('#free-plan-characters-per-month').text(i18n.t('free_plan_characters_per_month'))
  $('#free-plan-button').text(i18n.t('free_plan_button'))
  $('#free-plan-user-help').html(i18n.t('free_plan_user_help'))
  $('#free-plan-visitor-help').html(i18n.t('free_plan_visitor_help'))
  $('#pro-plan-name').text(i18n.t('pro_plan_name'))
  $('#pro-plan-audience').text(i18n.t('pro_plan_audience'))
  $('#pro-plan-price-amount').text(i18n.t('pro_plan_price_amount'))
  $('#pro-plan-price-description').text(i18n.t('pro_plan_price_description'))
  $('#pro-plan-features').text(i18n.t('pro_plan_features'))
  $('#pro-plan-characters-per-translation').text(i18n.t('pro_plan_characters_per_translation'))
  $('#pro-plan-characters-per-month').text(i18n.t('pro_plan_characters_per_month'))
  $('#pro-plan-user-button').text(i18n.t('pro_plan_user_button'))
  $('#pro-plan-licensee-button').text(i18n.t('pro_plan_licensee_button'))
  $('#pro-plan-visitor-button').text(i18n.t('pro_plan_visitor_button'))
  $('#pro-plan-cancel-button').text(i18n.t('pro_plan_cancel_button'))
  $('#pro-plan-user-help').html(i18n.t('pro_plan_user_help'))
  $('#pro-plan-licensee-help').html(i18n.t('pro_plan_licensee_help'))
  $('#pro-plan-visitor-help').html(i18n.t('pro_plan_visitor_help'))

  $('#language-select option').each(function () {
    const $opt = $(this)
    $opt.text(i18n.t($opt.attr('value')))
  })

  $('#sign-in-modal')
      .find('.modal-title').text(i18n.t('sign_in_modal.title')).end()
      .find('.modal-body').html(i18n.t('sign_in_modal.body')).end()
      .find('.modal-footer .btn-yes').text(i18n.t('sign_in_modal.yes')).end()
      .find('.modal-footer .btn-no').text(i18n.t('sign_in_modal.no'))

  $('#sign-out-modal')
      .find('.modal-title').text(i18n.t('sign_out_modal.title')).end()
      .find('.modal-body').html(i18n.t('sign_out_modal.body')).end()
      .find('.modal-footer .btn-yes').text(i18n.t('sign_out_modal.yes')).end()
      .find('.modal-footer .btn-no').text(i18n.t('sign_out_modal.no'))

  $('#cancel-subscription-modal')
      .find('.modal-title').text(i18n.t('cancel_subscription_modal.title')).end()
      .find('.modal-body').html(i18n.t('cancel_subscription_modal.body')).end()
      .find('.modal-footer .btn-yes').text(i18n.t('cancel_subscription_modal.yes')).end()
      .find('.modal-footer .btn-no').text(i18n.t('cancel_subscription_modal.no'))
}

function setValues() {
  const pref = new Preferences()
  setValue('language-select', pref.language())
}

function setValue(id, value) {
  const $elem = $('#' + id)
  $elem.find('option[value="' + value + '"]').prop('selected', true)
}

function getValue(id) {
  const $elem = $('#' + id)
  if ($elem.get(0).tagName === 'SELECT') {
    return $elem.val()
  }
}

function saveLanguage() {
  const pref = new Preferences()
  pref.language(getValue('language-select'))
}

function updateUI(callback) {
  setValues()
  updateUILabels()

  getProfile(function (data) {
    updateProfile(data.email)
    if (callback) {
      callback()
    }
  }, function () {
    updateProfile('Not signed in')
    if (callback) {
      callback()
    }
  })
}

function updateProfile(email) {
  $('#account-email').val(email)
}

function getProfile(done, fail) {
  const url = '/api/user' // api_user_path
  $.get(url).done(function (data) {
    done(data)
  }).fail(function () {
    fail()
  })
}

function signIn() {
  window.location.href = '/users/auth/google_oauth2' // user_google_oauth2_omniauth_authorize_path
  return false
}

function signOut() {
  const url = '/users/sign_out' // destroy_user_session_path
  $.ajax({
    url: url,
    type: 'DELETE'
  }).done(function () {
    window.location.href = '/?via=sign_out'
  }).fail(function (xhr) {
    console.error(xhr.responseText)
  })
  return false
}

function cancelSubscription(id) {
  const url = '/api/subscriptions/' + id // api_subscription_path
  $.ajax({
    url: url,
    type: 'DELETE'
  }).done(function () {
    window.location.href = '/?via=cancel_subscription'
  }).fail(function (xhr) {
    console.error(xhr.responseText)
  })
  return false
}

$(function () {
  updateUI(function () {
    $('#main-content').show()
  })

  $('#language-select').on('change', function () {
    saveLanguage()
    updateUI()
  })

  $(document).on('click', '.sign-in', function () {
    $('#sign-in-modal').modal()
    return false
  })

  $('#sign-in-modal .btn-primary').on('click', function () {
    return signIn()
  })

  $(document).on('click', '#sign-out', function () {
    $('#sign-out-modal').modal()
    return false
  })

  $('#sign-out-modal .btn-primary').on('click', function () {
    return signOut()
  })

  $(document).on('click', '.cancel-subscription', function () {
    const id = $(this).data('subscription-id')
    $('#cancel-subscription-modal').data('subscription-id', id).modal()
    return false
  })

  $('#cancel-subscription-modal .btn-primary').on('click', function () {
    const id = $('#cancel-subscription-modal').data('subscription-id')
    return cancelSubscription(id)
  })
})
