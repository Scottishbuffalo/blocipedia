require 'rails_helper'
require 'devise'

RSpec.describe WikisController, type: :controller do
  let(:user) { create(:user) }
  let(:wiki) { Wiki.create!(title: 'wiki title', body: 'wiki body', private: false, user_id: user.id) }

  context 'guest user' do
    describe 'GET show' do
      it 'renders the #show view' do
        get :show, params: { id: wiki.id } , session: nil
        expect(response).to render_template :show
      end
    end

    describe 'GET new' do
      it 'returns http redirect' do
        get :new , session: nil
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST create' do
      it 'returns http redirect' do
        post :create,  params: { wiki: {title: 'new title', body: 'new body', private: false} }, session: nil
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET edit' do
      it 'returns http redirect' do
        get :edit, params: { id: wiki.id }, session: nil
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PUT update' do
      it 'returns http redirect' do
        new_title = 'different title'
        new_body = 'different body'

        put :update, params: { id: wiki.id } , wiki: {title: new_title, body: new_body, private: false}, session: nil
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE destroy' do
      it 'returns http redirect' do
        delete :destroy, params: { id: wiki.id }, session: nil
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  context 'logged-in user' do
    before do
      sign_in user
    end

    it 'should have a current_user' do
      expect(subject.current_user).to_not eq(nil)
    end

    describe 'GET show' do
      it 'renders the #show view' do
        get :show, params: { id: wiki.id } , session: { user_id: user.id}
        expect(response).to render_template :show
      end
    end

    describe 'GET new' do
      it 'renders the #new view' do
        get :new, session: { user_id: user.id}
        expect(response).to render_template :new
      end
    end

    describe 'POST create' do
      it 'redirects to the new wiki' do
        post :create, params: { wiki: {title: 'jkashdf', body: 'hkjfha hfsahk', private: false, user_id: user.id}}
        expect(response).to redirect_to Wiki.last
      end

      it 'should increase the number of Wiki by 1' do
        expect{post :create, params:{ wiki: {title: 'jkashdf', body: 'hkjfha hfsahk', private: false, user_id: user.id}}}.to change(Wiki, :count).by(1)
      end
    end

    describe 'GET edit' do
      it 'renders the #edit view' do
        get :edit, params: { id: wiki.id } , session: { user_id: user.id}
        expect(response).to render_template :edit
      end
    end

    describe 'PUT update' do
      let(:new_body) { 'blah blah blah' }
      it 'should update post with expected attributes' do
        put :update, id: wiki.id , wiki: { title: wiki.title, body: new_body, private: false, user_id: user.id }
        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq wiki.id
        expect(updated_wiki.title).to eq wiki.title
        expect(updated_wiki.body).to eq new_body
      end

      it 'redirects to the updated wiki' do
        put :update, id: wiki.id , wiki: { title: wiki.title, body: new_body, private: false, user_id: user.id }
        expect(response).to redirect_to wiki
      end
    end

    describe 'DELETE destroy' do
      it 'should delete the wiki' do
        delete :destroy, id: wiki.id
        count = Wiki.where({id: wiki.id}).size
        expect(count).to eq 0
      end

      it 'should redirect to wiki show' do
        delete :destroy, id: wiki.id
        expect(response).to redirect_to wikis_path
      end
    end
  end
end
