class HelloWorldJob < ApplicationJob
  queue_as :default

  def perform(*args)
    url = 'http://api.tvmaze.com/search/shows'
    conn = Faraday.new(url: url) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end

    response = conn.get '/shows', page: args[0]
    if response.success?
      ap response.body.first
    else
      puts "FAILURE!"
    end
  end
end
