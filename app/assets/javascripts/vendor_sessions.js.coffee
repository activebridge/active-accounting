$(document).ready ->
  $('#new_session_form').validate
    errorElement: 'div'
    errorPlacement: (error, element) ->
      error.insertBefore element
      return
    rules:
      'email': required: true
      'password': required: true
    messages:
      'email': 'Email is not valid'
      'password': 'Cant be blank'

  $('#password_resets').validate
    errorElement: 'div'
    errorPlacement: (error, element) ->
      error.insertBefore element
      return
    rules: email:
      required: true
      email: true
      pattern: /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/
    messages: email:
      required: "Can't be blank"
      email: 'Email is not valid'

  $('.edit_vendor').validate
    errorElement: 'div'
    errorPlacement: (error, element) ->
      error.insertBefore element
      return
    rules:
      'vendor[password]':
        required: true
        minlength: 8
        maxlength: 32
      'vendor[password_confirmation]':
        required: true
        equalTo: '#vendor_password'
    messages:
      'vendor[password]':
        required: 'Cant be blank'
        minlength: 'Password should have more then 8 characters'
      'vendor[confirm_password]':
        required:'Cant be blank'
        equalTo: 'Passwords not identical'
