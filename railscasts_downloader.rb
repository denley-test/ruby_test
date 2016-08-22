#! /usr/bin/env ruby

require 'open-uri'
require 'rss'

URI = 'http://railscasts.com/episodes.rss?ext=mp4'

open(URI) do |f|
  result = RSS::Parser.parse(f.read, false)
  result.items.reverse!.each do |item|
    puts item.enclosure.url
  end
end