# Code based on http://developer.yahoo.com/boss/search/boss_api_guide/codeexamples.html#oauth_ruby

require_relative './oauth_util.rb'
require 'net/http'
require 'uri'
require 'json'

class Search
  def initialize
    @format = "json"
    @count = "20"
    @search_bucket = "limitedweb"
    @search_url = "http://yboss.yahooapis.com/ysearch/#{@search_bucket}?"
  end

  def query(search_phrase)
    site_names = Site.all.map { |s| s.name }
    sites_to_search = URI.encode(site_names.join(","))

    search_params = { "format" => @format, "count" => @count,
      "sites" => sites_to_search, "q" => URI.encode(search_phrase) }
    
    JSON.parse(search_against_boss(search_params), symbolize_names: true)[:bossresponse][:limitedweb][:results]
  end

  def search_against_boss(args)
    url = @search_url

    arg_count = 0
    args.each do|key,value|
        url = url + key + "=" + value+"&"
        ++arg_count
    end

    if(arg_count > 0)
        url.slice!(url.length-1)
    end

    parsed_url = URI.parse( url )

    o = OauthUtil.new
    o.consumer_key = ENV['BOSS_CONSUMER_KEY']
    o.consumer_secret = ENV['BOSS_CONSUMER_SECRET']

    Net::HTTP.start( parsed_url.host ) { | http |
      req = Net::HTTP::Get.new "#{ parsed_url.path }?#{ o.sign(parsed_url).query_string }"
      response = http.request(req)
      return response.read_body
    }
  end
end
