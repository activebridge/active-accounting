User.create(email: SETTINGS['email'],
            password: SETTINGS['pass'],
            password_confirmation: SETTINGS['pass'])

Counterparty.create(email: 'test@te.st', password: '12345678', type: 'Vendor', name: 'test name') if Rails.env.test?
