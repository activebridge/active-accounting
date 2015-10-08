if '<%= flash[:error] %>'
  $('span.errors').show().text('<%= flash[:error] %>').fadeOut(5000)
else
  href = if <%= current_counterparty.vendor? %>
           '<%= vendor_profile_path %>' + '#/hours'
         else if <%= current_counterparty.hr? %>
           '<%= vendor_profile_path %>' + '#/hr_manager'
  window.location = href
