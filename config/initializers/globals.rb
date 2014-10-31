settings = YAML.load(File.read(File.expand_path('../../application.yml', __FILE__)))

HTTP_AUTH_NAME = settings[:http_auth_name]
HTTP_AUTH_PASS = settings[:http_auth_pass]
