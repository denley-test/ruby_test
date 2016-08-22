#! /usr/bin/env ruby

require 'open-uri'
require 'rss'

RAILS_CASTS_URI = 'http://railscasts.com/episodes.rss?ext=mp4'
open(RAILS_CASTS_URI) do |f|
  result = RSS::Parser.parse(f.read, false)
  result.items.reverse!.each do |item|
    puts item.enclosure.url
  end
end