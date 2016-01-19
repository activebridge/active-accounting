exports.config = {
    // The address of a running selenium server.
    seleniumAddress: 'http://localhost:4444/wd/hub',
    seleniumPort: null,
    seleniumArgs: [],

    // Capabilities to be passed to the webdriver instance.
    capabilities: {
        'browserName': 'chrome'
    },

    // If you would like to test against multiple browsers, use the multiCapabilities
    // configuration option instead.

    // multiCapabilities: [{
    //     'browserName': 'firefox'
    // }, {
    //     'browserName': 'chrome'
    // }],

    // Spec patterns are relative to the current working directly when
    // protractor is called.
    specs: ['views/**/*.js', 'views/**/*.coffee', 'views/**/*.js.coffee', 'views/**/*.js.erb'],

    baseUrl: 'http://0.0.0.0:4000',
    // Options to be passed to Jasmine-node.
    jasmineNodeOpts: {
        showColors: true,
        defaultTimeoutInterval: 30000
    }
};
