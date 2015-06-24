require 'spec_helper'

describe GamesController do
  let(:valid_attributes) { {  } }
  let(:valid_session) { {} }

  let(:user) { FactoryGirl.create :user }

  before { sign_in user }

  describe "PUT update" do
    let(:game) { FactoryGirl.create :game }

    context 'move' do
      let(:character) {FactoryGirl.create :character}

      context 'when character can move' do
        let(:target) {FactoryGirl.create :character}

        before do
          Game.any_instance.should_receive(:move!)
          Actions::Run.create!(character: character)
        end

        it "assigns the game" do
          put :update, {:id => game.to_param, 'game_action' => 'run', 'character_id' => character.id}, format: :json

          assigns(:game).should be_a(Game)
        end

        it "sets the target character" do
          valid_params = {
            :id => game.to_param,
            'game_action' => 'run',
            'target_character_id' => target.id,
            'character_id' => character.id
          }

          put :update, valid_params, format: :json

          expect(character.reload.target_character).to eq(target)
          assigns(:game).should be_a(Game)
        end
      end
    end
  end

  describe "GET next_event" do
    let(:game) {FactoryGirl.create :game}

    it "updates the game world" do
      prior_time = game.time

      get :next_event, {:id => game.to_param}, format: :json

      expect(game.reload.time).to be > prior_time
    end

    it "returns the game json" do
      get :next_event, {:id => game.to_param}, format: :json

      assigns(:game).should be_a(Game)
    end
  end

  describe "GET show" do
    it "returns the game json" do
      game = FactoryGirl.create :game

      get :show, {:id => game.to_param}, format: :json

      assigns(:game).should be_a(Game)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Game" do
        expect {
          post :create, {:game => valid_attributes}, valid_session
        }.to change(Game, :count).by(1)
      end

      it "assigns a newly created game as @game" do
        post :create, {:game => valid_attributes}, valid_session
        assigns(:game).should be_a(Game)
        assigns(:game).should be_persisted
      end

      it "redirects to the created game" do
        post :create, {:game => valid_attributes}, valid_session
        response.should redirect_to(Game.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved game as @game" do
        # Trigger the behavior that occurs when invalid params are submitted
        Game.any_instance.stub(:save).and_return(false)
        post :create, {:game => {  }}, valid_session
        assigns(:game).should be_a_new(Game)
      end
    end
  end
end

