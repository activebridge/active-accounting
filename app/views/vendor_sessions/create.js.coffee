if '<%= flash[:error] %>'
  $('span.errors').show().text('<%= flash[:error] %>').fadeOut(5000)
else
  window.location = '<%= vendor_profile_path %>' + '#/estimates'
