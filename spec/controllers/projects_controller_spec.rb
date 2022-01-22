require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do
    context "as an authenticated user" do
      before do
        @user = create(:user)
      end

      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to be_success
      end

      it "returns a 200 response" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        get :index
        expect(response).to have_http_status "302"
      end

      it "responds successfully" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    context "as an authorized user" do
      before do
        @user = create(:user)
        @project = create(:project, owner: @user)
      end

      it "responds successfully" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to be_success
      end
    end

    context "as an unauthorized user" do
      before do
        @user = create(:user)
        other_user = create(:user)
        @project = create(:project, owner: other_user)
      end

      it "redirects to the dashboard" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#update" do
    context "as an authorized user" do
      before do
        @user = create(:user)
        @project = create(:project, owner: @user)
      end

      it "updates a project" do
        project_params = attributes_for(:project,
          name: "New Project Name")
        sign_in @user
        p project_params.class
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "New Project Name"
      end
    end
  end
end
