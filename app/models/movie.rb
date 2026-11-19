class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end
  
  def self.find_in_tmdb(search_terms)
    query = { api_key: api_key, query: search_params[:title] }
    query[:year] = search_params[:release_year] if search_params[:release_year].present?
    query[:language] = 'en' if search_params[:language] == 'en'

    response = Faraday.get('https//api.themoviedb.org/3/search/movie', query)
    return [] unless response.status == 200

    results = JSON.parse(response.body)['results'] || []
    results.map do |movie|
      Movie.new(
        title: movie['title'],
        rating: 'R',
        release_date: movie['release_date'],
        description: movie['overview']
      )
  end
end
