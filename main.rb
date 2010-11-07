require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'pp'

configure do
  include Rack::Utils
  alias :h :escape_html

  result = open('http://dog.indivision.jp/api/breed').read
  doc = Nokogiri::XML(result)
  @@options = []
  doc.search('breed').each do |breed|
    opt = { :label => breed.search('name').text, :value => breed.search('cd').text }
    @@options << opt
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
  erb :index
end
