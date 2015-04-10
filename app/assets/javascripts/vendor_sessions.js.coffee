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
