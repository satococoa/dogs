# coding: utf-8
require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'json'

configure do
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, 'views') }
  include Rack::Utils
  alias :h :escape_html

  result = open('http://dog.indivision.jp/api/breed').read
  doc = Nokogiri::XML(result)
  @@options = []
  @@kenshu = {}
  doc.search('breed').each do |breed|
    opt = { :label => breed.search('name').text, :value => breed.search('cd').text }
    @@options << opt
    @@kenshu[breed.search('cd').text.to_i] = breed.search('name').text
  end
end

get '/' do
  @options = @@options
  erb :index
end

post '/' do
  @options = @@options
  url = 'http://dog.indivision.jp/api/puppy'
  breed = params[:kenshu]
  result = open(url+'?breed='+escape(breed)).read
  doc = Nokogiri::XML(result)
  @puppies = []
  doc.search('puppy').each do |puppy|
    puppy = {
      :url => puppy.search('url').text,
      :puppy_name => puppy.search('puppy_name').text,
      :color => puppy.search('color').text,
      :place => puppy.search('place').text,
      :price => puppy.search('price').text,
      :birth => puppy.search('birth').text,
      :image => puppy.search('image/middle')[0].text,
      :comment => puppy.search('comment')[0].text
    }
    @puppies << puppy
  end
  
  # Youtubeの動画を取得
  youtube_base = 'http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=10&vq='+
    escape(@@kenshu[params[:kenshu].to_i])
  movies = JSON.parse(open(youtube_base).read)
  erb :index
end
