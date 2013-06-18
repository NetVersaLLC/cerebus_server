#!/usr/bin/env ruby

require 'sinatra'
require './cerebus'

api_key = 'ccfa6c5fa8bd2a028031fcd2e8476bd8'

post '/:value' do
  got = params[:value]
  if got == api_key+'.json'
    data = params['secret']
    # File.open("prepack.dat", "w").write data
    # File.open("crypted.dat", "w").write [data].pack("H*")
    ret = Cerebus.decrypt data, 'keys/private.pem', 'b91d99bacdab8a2746718d0604b798b8'
    ret
  else
    ''
  end
end

get /.*/ do
  ''
end
put /.*/ do
  ''
end
delete /.*/ do
  ''
end
