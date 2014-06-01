require 'spec_helper'

describe MoviesController do
  let(:inception) { Movie.create!(title: 'Inception', rating: 'PG-13') }
  let(:amelie)    { Movie.create!(title: 'Amelie', rating: 'R') }

  def valid_attributes_on_create
    { movie: { title: 'Memento', director: 'Christopher Nolan' } }
  end

  def invalid_attributes_on_create
    { movie: { title: nil } }
  end

  def valid_attributes_on_update
    { id: inception.to_param, movie: { 'title' => 'Memento' } }
  end

  def invalid_attributes_on_update
    { id: inception.to_param, movie: { 'title' => nil } }
  end

  describe "GET 'index'" do
    it "assigns all movie ratings" do
      get :index
      expect(assigns(:all_ratings)).to eq(Movie.all_ratings)
    end
    context "when ratings are filtered" do
      it "checking some options" do
        get :index, { ratings: { 'PG-13' => 1, 'R' => 1 } }
        expect(assigns(:ratings)).to eq(['PG-13', 'R'])
      end
      it "unchecking all options" do
        get :index, { 'utf8' => '✓' }
        expect(assigns(:ratings)).to be_empty
      end
      it "displays all options by default" do
        get :index
        expect(assigns(:ratings)).to eq(Movie.all_ratings)
      end
    end
    context "when ratings are not filtered but session is set" do
      it "redirects to movies list with options set on session" do
        get :index, {}, { sort_by: 'title', ratings: { 'R' => 1 } }
        expect(response).to redirect_to movies_path(sort_by: 'title', ratings: { 'R' => 1 })
      end
    end
    context "assigns movies" do
      it "when ratings are not filtered" do
        get :index
        expect(assigns(:movies)).to eq([inception, amelie])
      end
      it "when ratings are filtered" do
        get :index, { ratings: { 'R' => 1 } }
        expect(assigns(:movies)).to eq([amelie])
      end
    end
  end

  describe "GET 'show'" do
    it "assigns a movie" do
      get :show, id: inception.to_param
      expect(assigns(:movie)).to eq(inception)
    end
  end

  describe "GET 'new'" do
    it "assigns a new movie" do
      get :new
      expect(assigns(:movie)).to be_a_new(Movie)
    end
  end

  describe "GET 'edit'" do
    it "assigns a movie" do
      get :edit, id: inception.to_param
      expect(assigns(:movie)).to eq(inception)
    end
  end

  describe "POST 'create'" do
    context "with valid attributes" do
      it "creates a movie" do
        expect {
          post :create, valid_attributes_on_create
        }.to change(Movie, :count).from(0).to(1)
      end
      it "redirects to movies list" do
        post :create, valid_attributes_on_create
        expect(response).to redirect_to movies_path
      end
      it "displays a flash message" do
        post :create, valid_attributes_on_update
        expect(flash[:notice]).to include 'was successfully created'
      end
    end
    context "with invalid attributes" do
      it "does not create a movie" do
        expect {
          post :create, invalid_attributes_on_create
        }.not_to change(Movie, :count)
      end
      it "renders form to add movie" do
        post :create, invalid_attributes_on_create
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT 'update'" do
    context "with valid attributes" do
      it "updates movie" do
        expect_any_instance_of(Movie).to receive(:update_attributes).with valid_attributes_on_update[:movie]
        put :update, valid_attributes_on_update
      end
      it "redirects to movie's info page" do
        put :update, valid_attributes_on_update
        expect(response).to redirect_to movie_path(inception)
      end
      it "displays a flash message" do
        put :update, valid_attributes_on_update
        expect(flash[:notice]).to include 'was successfully updated'
      end
    end
    context "with invalid attributes" do
      it "does not update movie" do
        expect_any_instance_of(Movie).to receive(:update_attributes).with invalid_attributes_on_update[:movie]
        put :update, invalid_attributes_on_update
      end
      it "renders form to edit movie" do
        put :update, invalid_attributes_on_update
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes movie" do
      inception

      expect {
        delete :destroy, id: inception.to_param
      }.to change(Movie, :count).by(-1)
    end
    it "redirects to movies list" do
      delete :destroy, id: inception.to_param
      expect(response).to redirect_to movies_path
    end
    it "displays a flash message" do
      delete :destroy, id: inception.to_param
      expect(flash[:notice]).to include 'deleted'
    end
  end

  describe "GET 'from_same_director'" do
    context "when movie has director info" do
      before(:each) { inception.update_column :director, 'Christopher Nolan' }

      it "assigns a movie" do
        get :from_same_director, id: inception.to_param
        expect(assigns(:movie)).to eq(inception)
      end
      it "assigns all movies from same director" do
        get :from_same_director, id: inception.to_param
        expect(assigns(:movies_from_same_director)).to be_empty
      end
    end
    context "when movie hasn't director info" do
      it "redirects to movies list" do
        get :from_same_director, id: inception.to_param
        expect(response).to redirect_to movies_path
      end
      it "displays a flash message" do
        get :from_same_director, id: inception.to_param
        expect(flash[:notice]).to include 'has no director info'
      end
    end
  end
end
