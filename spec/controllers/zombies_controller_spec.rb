require 'rails_helper'

RSpec.describe ZombiesController, type: :controller do
	describe 'CREATE zombies create' do 
		context 'when attributes are valid' do 
			let(:zombie_attributes) { { name: 'brainless' } }
			before { post :create, params: zombie_attributes }

			it "creates a JSON @zombie" do
				expect(response.content_type).to eq('application/json')
			end

			it "returns a HTTP status created" do
				expect(response).to have_http_status(:created)
			end	
		end

		context 'when attributes are invalid' do 
			let(:invalid_attributes) { {} }
			before { post :create, params: invalid_attributes }

			it "returns a HTTP status 422 invalid request" do
				expect(response).to have_http_status(422)
			end

			it "returns failure message" do
				expect(response.body).to match(/Name can't be blank/)
			end
		end
	end

	describe 'UPDATE assign an armor for the zombie' do
		let(:zombie) { Zombie.create(name: 'brainless') } 
		let(:armor) { { name: 'Partisan'} } 

		before do 
			@zombie = zombie
			put :update, params: { id: @zombie.id, armors_attributes: [armor] }
		end

		it 'has an armor' do
			expect(@zombie.armors.count).to eq 1
		end

		it 'returns status updated' do 
			expect(response).to have_http_status(:ok)
		end
	end

	describe 'UPDATE provide a zombie with a weapon' do
		let(:zombie) { Zombie.create(name: 'brainless') } 
		let(:weapon) { { name: 'Partisan' } }

		before do 
			@zombie = zombie 
			put :update, params: { id: @zombie.id, weapons_attributes: [weapon] }
		end

		it 'zombie has a weapon' do
			updated = JSON.parse(response.body)
			expect(updated['weapons'].length).to eq 1
			expect(updated['weapons'].map { |weapon| weapon['name'] }).to include 'Partisan'
		end

		it 'returns status ok' do
			expect(response).to have_http_status(:ok)
		end

		it 'returns JSON object' do 
			expect(response.content_type).to eq 'application/json'
		end
	end

	describe 'search for a zombie' do 
		let(:freddy) do
			Zombie.create(
				name: 'freddy', 
				armors_attributes: [
					{ name: 'Hauberk' },
					{ name: 'Kabuto' }
				],
				weapons_attributes: [
					{ name: 'Partisan' },
					{ name: 'WarHammer' }
				])
		end		

		let(:hannah) do
			Zombie.create(
				name: 'hannah', 
				armors_attributes: [
					{ name: 'Mengu' },
					{ name: 'Bevor' }
				], 
				weapons_attributes: [
					{ name: 'Bow' },
					{ name: 'Hammer' }
				])
		end

		before do 
			@zombies = [hannah, freddy]
		end

		context 'searching by zombie name' do
			before { get :search, params: { term: 'hannah'} }
			
			it "finds hannah the zombie" do 
				results = JSON.parse(response.body)
				expect(results.length).to eq 1
				expect(results.first['name']).to eq 'hannah'
			end
		end
		
		context 'searching by zombie armor' do
			before do 
				get :search, params: { term: 'Bevor'} 
				@results = JSON.parse(response.body)
			end
			
			it "finds hannah by armor" do 
				expect(@results.length).to eq 1
				expect(@results.first['name']).to eq 'hannah'
			end

			it "retrieves zombie that has the armor Bevor" do 
				expect(@results.first['armors'].map { |armor| armor['name'] }).to include 'Bevor'
			end
		end

		context 'searching by zombie weapon' do
			context "only one weapon with that name" do
				before do 
					get :search, params: { term: 'Partisan' }
					@results = JSON.parse(response.body)
				end
				
				it "finds freddy by weapon" do 
					expect(@results.length).to eq 1
					expect(@results.first['name']).to eq 'freddy'
				end

				it "retrieves zombie that has the weapon Partisan" do 
					expect(@results.first['weapons'].map { |weapon| weapon['name'] }).to include 'Partisan'
				end
			end

			context 'more than one weapon with similar name' do
				before do 
					get :search, params: { term: 'hammer'} 
					@results = JSON.parse(response.body)
				end

				it "finds two @results freddy and hannah" do
					expect(@results.length).to eq 2
				end
			end
		end
	end

	describe 'delete a zombie' do
		let(:zombie) { Zombie.create(name: 'brainless') } 
		before { zombie }

		it "deletes zombie" do 
			expect { delete :destroy, params: { id: zombie.id } }.to change(Zombie, :count).by(-1)
		end
	end
end

