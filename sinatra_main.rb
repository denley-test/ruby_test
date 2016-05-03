#! /usr/bin/env ruby

$LOAD_PATH.unshift './thirdpart/sinatra/lib'

require 'sinatra'

get '/' do
  'Hello, Denley Hsiao'
end
