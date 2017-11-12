#!/usr/bin/env ruby

require "net/http"
require "net/https"
require "json"
require "date"

input = ARGV[0];

# https://ofcncog2cu-dsn.algolia.net/1/indexes/*/queries (POST )
uri = URI('https://ofcncog2cu-dsn.algolia.net/1/indexes/*/queries?x-algolia-agent=Algolia%20for%20vanilla%20JavaScript%20(lite)%203.24.5%3Breact-instantsearch%204.1.3%3BJS%20Helper%202.23.0&x-algolia-application-id=OFCNCOG2CU&x-algolia-api-key=f54e21fa3a2a0160595bb058179bfb1e')

# Create client
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
dict = {
	"requests" => [
		{
			"params" => "query=#{input}&hitsPerPage=5&maxValuesPerFacet=10&page=0&attributesToRetrieve=%5B%22deprecated%22%2C%22description%22%2C%22downloadsLast30Days%22%2C%22githubRepo%22%2C%22homepage%22%2C%22humanDownloadsLast30Days%22%2C%22keywords%22%2C%22license%22%2C%22modified%22%2C%22name%22%2C%22owner%22%2C%22version%22%5D&attributesToHighlight=%5B%22name%22%2C%22description%22%2C%22keywords%22%5D&highlightPreTag=%3Cais-highlight-0000000000%3E&highlightPostTag=%3C%2Fais-highlight-0000000000%3E&facets=%5B%22keywords%22%2C%22keywords%22%2C%22owner.name%22%5D&tagFilters=",
			"indexName" => "npm-search"
		}
	]
}
body = JSON.dump(dict)

# Create Request
req =  Net::HTTP::Post.new(uri)
# Add headers
req.add_field "Accept", "application/json"
# Add headers
req.add_field "Accept-Encoding", "gzip, deflate, br"
# Add headers
req.add_field "Origin", "https://yarnpkg.com"
# Add headers
req.add_field "Pragma", "no-cache"
# Add headers
req.add_field "Content-Type", "application/x-www-form-urlencoded"
# Add headers
req.add_field "Cache-Control", "no-cache"
# Add headers
req.add_field "User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.89 Safari/537.36"
# Add headers
req.add_field "Referer", "https://yarnpkg.com/en/packages?q=r&p=1"
# Add headers
req.add_field "Accept-Language", "zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7,zh-TW;q=0.6,ja;q=0.5,ko;q=0.4,de;q=0.3,it;q=0.2"
# Add headers
req.add_field "Connection", "keep-alive"
# Add headers
req.add_field "Dnt", "1"
# Set body
req.body = body

# Fetch Request
res = http.request(req)
result = JSON.parse(res.body);
items = result["results"][0]["hits"].map do |pkg|
	link = "https://yarnpkg.com/en/package/#{pkg["name"]}"
	{
		title: pkg["name"],
		subtitle: pkg["description"],
		arg: link,
		mods: {
			cmd: {
				subtitle: "#{pkg["version"]} published at #{DateTime.strptime(pkg["modified"].to_s, '%s').strftime('%Y-%M-%d')} by #{pkg["owner"]["name"]}"
			}
		},
		quicklookurl: link
	}
end

puts JSON.generate({
	items: items
})
