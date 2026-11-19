require 'rails_helper'

describe Movie do
    describe 'searching TMDB by keyword' do
        it 'calls Faraday gem' do
            expect(Faraday).to receive(:get).and_call_original
            Movie.find_in_tmdb({title: 'hacker', language: 'en'})
        end
        it 'calls TMDb with valid API key' do
            Movie.find_in_tmdb({title: 'hacker', language: 'en'})
        end
        it 'returns unsaved Movie objects built from the TMDb results' do 
            movies = Movie.find_in_tmdb(title: 'Olympics', release_year: '2000', language: 'all')
            expect(movies.length).to eq(2)
            expect(movies.first.title).to eq('Sydney 2000 Olympics Opening Ceremony')
            expect(movies.first).not_to be_persisted
        end
    end
end