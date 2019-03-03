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
end

