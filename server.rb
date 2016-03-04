require 'haveapi'
require './api.rb'
require './pins.rb'

configfile = File.read './config.json'

$config = JSON.parse(configfile, symbolize_names: true)

pins_init

$api = HaveAPI::Server.new(PinAPI)

$api.use_version(:all)
$api.auth_chain << BasicAuth
$api.mount('/')
