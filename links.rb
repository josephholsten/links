#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'haml'
require 'open-uri'

set :haml, {:format => :html5 }

get '/' do
  resource = open('http://pinboard.in/u:josephholsten/')
  doc = Nokogiri::HTML(resource)
  marks = doc.css('.bookmark')
  @bookmarks = marks.collect {|b| bookmark_to_hash(b) }
  haml :index
end

def bookmark_to_hash(b)
  {
    :title         => b.css('.bookmark_title').text,
    :uri           => b.css('.bookmark_title').attr('href').slice(/url=(.*)$/,1),
    :entry_content => b.css('.description').text,
    :tags          => b.css('.tag').collect{|e|e.text},
    :date          => b.css('.when').text
  }
end