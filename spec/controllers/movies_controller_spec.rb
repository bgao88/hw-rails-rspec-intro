require 'rails_helper'

describe MoviesController, type: :controller do
    describe 'searching TMDb' do
        before :each do
            @fake_results = [double('movie1'), double('movie2')]
        end
        it 'calls the model method that performs TMDb search' do
            expect(Movie).to receive(:find_in_tmdb).with(hash_including(title: 'hardware')).and_return(@fake_results)
            get :search_tmdb, params: { title: 'hardware' }
        end
        describe 'after valid search' do
            before :each do
                allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
                get :search_tmdb, params: { title: 'hardware' }
            end
            it 'selects the Search Results template for rendering' do
                expect(response).to render_template('search_tmdb')
            end
            it 'makes the TMDb search results available to that template' do
                expect(assigns(:movies)).to eq(@fake_results)
            end
        end
        describe 'first visit with no search' do
            it 'does not search and shows no message' do
                expect(Movie).not_to receive(:find_in_tmdb)
                get :search_tmdb
                expect(flash[:danger]).to be_nil
            end
        end
        describe 'with a blank title' do
            it 'does not search and shows the required fields message' do
                expect(Movie).not_to receive(:find_in_tmdb)
                get :search_tmdb, params: { title: '', release_year: '1986' }
                expect(flash[:danger]).to eq('Please fill in all required fields!')
            end
        end
        describe 'when no movies match' do
            it 'shows the no movies found message' do
                allow(Movie).to receive(:find_in_tmdb).and_return([])
                get :search_tmdb, params: { title: 'zzzzqqqq' }
                expect(flash[:danger]).to eq('No movies found with given parameters!')
            end
        end
    end
    describe 'adding a movie' do
        before :each do
            post :add_movie, params: { title: 'Limitless', rating: 'R', release_date: '2011-03-08', description: 'A writer takes a pill.' }
        end
        it 'saves the movie to the database' do
            expect(Movie.find_by(title: 'Limitless')).not_to be_nil
        end
        it 'redirects to the search page' do
            expect(response).to redirect_to(search_tmdb_path)
        end
        it 'shows a success message' do
            expect(flash[:success]).to eq('Limitless was successfully added to RottenPotatoes.')
        end
    end
end
