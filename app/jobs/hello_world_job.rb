class HelloWorldJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Show.destroy_all
    url = 'http://api.tvmaze.com/search/shows'
    conn = Faraday.new(url: url) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end

    response = conn.get '/shows', page: args[0]
    if response.success?
      response.body.each do |show|
        show['image'] ||= {}
        show['externals'] ||= {}
        show['network'] ||= {}

        Show.create!(
          name: show['name'],
          url: show['url'],
          show_type: show['type'],
          status: show['status'],
          runtime: show['runtime'],
          premiered: show['premiered'],
          original: show['image']['original'],
          medium: show['image']['medium'],
          tvmaze_id: show['id'],
          imdb_id: show['externals']['imdb'],
          tvrage_id: show['externals']['tvrage'],
          thetvdb_id: show['externals']['thetvdb'],
          summary: show['summary'],
          network_id: show['network']['id'],
          language: show['language'],
        )
      end
    else
      puts "FAILURE!"
    end
  end
end
