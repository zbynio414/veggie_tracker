require 'spec_helper'
require 'pry'

RSpec.describe UsersController, :type => :controller do
  
  describe "Signup Page" do
    
    it "loads the signup page" do
      get '/signup'
      
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Signup")
    end
    
    context "successful signup" do
      it "redirects a new user to the homepage" do
        params = {
          :username => "Rider",
          :email => "howdy@aol.com",
          :password => "cowboy"
        }
        
        post '/signup', params
        expect(last_response.redirect?).to be_truthy
        follow_redirect!
        expect(last_request.path).to eq('/users/rider')
        expect(last_response.body).to include("Welcome Rider!")
      end
    end
    
    context "unsuccessful signup" do
      it "does not let user signup without a username" do
        params = {
          :username => "",
          :email => "howdy@aol.com",
          :password => "cowboy"
        }
        
        post '/signup', params
        follow_redirect!
        expect(last_request.path).to eq('/signup')
        expect(last_response.body).to include("Try the form again.")
      end
        
      it "does not let user signup without an email" do
        params = {
          :username => "Rider",
          :email => "",
          :password => "cowboy"
        }
        
        post '/signup', params
        follow_redirect!
        expect(last_request.path).to eq('/signup')
        expect(last_response.body).to include("Try the form again.")
      end
      
      it "does not let user signup without a password" do
        params = {
          :username => "Rider",
          :email => "howdy@aol.com",
          :password => ""
        }
        
        post '/signup', params
        follow_redirect!
        expect(last_request.path).to eq('/signup')
        expect(last_response.body).to include("Try the form again.")
      end
      
      it "does not let allow duplicate email sign-ups" do
        params = {
          :username => "Rider",
          :email => "howdy@aol.com",
          :password => "cowboy"
        }
        
        post '/signup', params
        follow_redirect!
        expect(last_request.path).to eq('/users/rider')
        expect(last_response.body).to include("Welcome Rider!")
        
        get '/logout'
        
        params_2 = {
          :username => "Duplicate Rider",
          :email => "howdy@aol.com",
          :password => "double"
        }
        
        post '/signup', params_2
        follow_redirect!
        expect(last_request.path).to eq('/signup')
        expect(last_response.body).to include("This email is already taken.")
      end

    end
  end
  
  describe "Logging out" do
    
    it 'redirects user to the homepage' do
      get '/logout'
      
      follow_redirect!
      expect(last_request.path).to eq('/')
      expect(last_response.body).to include("Login")
    end
  end
  
  describe "Signing in" do
    before do
      @user = User.create(:username => "Ria", :email => "ria@aol.com", :password => "meow")
    end
    
    context "logged out" do
      it "loads the login page" do
        get '/login'
        
        expect(last_response.status).to eq(200)
        expect(last_request.path).to eq('/login')
      end
    end
    
    context "logged in" do
      it "redirects user to their dashboard" do
        params = {
          :username => "Ria",
          :password => "meow"
        }
        
        post '/login', params
        
        get '/login'
        
        follow_redirect!
        expect(last_request.path).to eq('/users/ria')
      end
    end
    
    context "successful sign in" do
      it 'redirects user to their dashboard' do
        params = {
          :username => "Ria",
          :password => "meow"
        }
        
        post '/login', params
        
        follow_redirect!
        expect(last_request.path).to eq('/users/ria')
        expect(last_response.body).to include("Welcome, Ria!")
      end
    end
    
    context "unsuccessful sign in" do
      it "does not user sign in with wrong username" do
        params = {
          :username => "Ria_xyz",
          :password => "meow"
        }
        
        post '/login', params
        
        expect(last_response.location).to include('/login')
      end
      
      it "does not user sign in with wrong password" do
        params = {
          :username => "Ria",
          :password => "meow_oops"
        }
        
        post '/login', params
        
        expect(last_response.location).to include('/login')
      end
    end
  end
  
  describe "User show page" do
    
    it "loads the user show page" do
      user = User.create(:username => "Ria", :email => "ria@aol.com", :password => "meow")
      
      get '/users/ria'
      
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Ria's Dashboard")
    end
    
  end
  
end