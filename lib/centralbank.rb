# encoding: utf-8

# stdlibs
require 'json'
require 'digest'
require 'net/http'
require 'set'
require 'pp'

## require 'blockchain-lite'
## Block = BlockchainLite::Basic::Block


### 3rd party gems
require 'sinatra/base'    # note: use "modular" sinatra app / service



### our own code
require 'centralbank/version'    ## let version always go first
require 'centralbank/block'
require 'centralbank/cache'
require 'centralbank/transaction'
require 'centralbank/blockchain'
require 'centralbank/bank'
require 'centralbank/ledger'
require 'centralbank/wallet'

require 'centralbank/node'




module Centralbank

class Service < Sinatra::Base

  def self.banner
    "centralbank/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] on Sinatra/#{Sinatra::VERSION} (#{ENV['RACK_ENV']})"
  end


## - for now hard-code address e.g. Sepp
NODE = Node.new( address: 'Sepp' )


PUBLIC_FOLDER = "#{Centralbank.root}/lib/centralbank/public"
VIEWS_FOLDER  = "#{Centralbank.root}/lib/centralbank/views"

puts "[centralbank] boot - setting public folder to: #{PUBLIC_FOLDER}"
puts "[centralbank] boot - setting views folder to: #{VIEWS_FOLDER}"

set :public_folder, PUBLIC_FOLDER # set up the static dir (with images/js/css inside)
set :views, VIEWS_FOLDER # set up the views dir

set :static, true # set up static file routing  -- check - still needed?


set connections: []



get '/' do
  @node = NODE
  erb :index
end

post '/send' do
  NODE.on_send( params[:to], params[:amount].to_i )
  settings.connections.each { |out| out << "data: added transaction\n\n" }
  redirect '/'
end


post '/transactions' do
  if NODE.on_add_transaction(
    params[:from],
    params[:to],
    params[:amount].to_i,
    params[:id]
  )
    settings.connections.each { |out| out << "data: added transaction\n\n" }
  end
  redirect '/'
end

post '/mine' do
  NODE.on_mine!
  redirect '/'
end

post '/peers' do
  NODE.on_add_peer( params[:host], params[:port].to_i )
  redirect '/'
end

post '/peers/:index/delete' do
  NODE.on_delete_peer( params[:index].to_i )
  redirect '/'
end



post '/resolve' do
  data = JSON.parse(request.body.read)
  if data['chain'] && NODE.on_resolve( data['chain'] )
    status 202     ### 202 Accepted; see httpstatuses.com/202
    settings.connections.each { |out| out << "data: resolved\n\n" }
  else
    status 200    ### 200 OK
  end
end


get '/events', provides: 'text/event-stream' do
  stream :keep_open do |out|
    settings.connections << out
    out.callback { settings.connections.delete(out) }
  end
end


end # class Service
end # module Centralbank


# say hello
puts Centralbank::Service.banner
