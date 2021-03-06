require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:state) { FactoryGirl.create(:state) }
  let(:ticket) { FactoryGirl.create(:ticket, project: project) }

  context "a user without permission to set state" do
    before :each do
      assign_role!(user, :editor, project)
      sign_in user
    end

    it "cannot transition a state by passing through state_id" do
      post :create, { comment: { text: "Did I hack it??",
                                 state_id: state.id },
                      ticket_id: ticket.id }
      ticket.reload
      expect(ticket.state).to be_nil
    end
  end

  context "a user without permission to tag a ticket" do
    before do
      assign_role!(user, :editor, project)
      sign_in user
    end

    it "cannot tag a ticket when creating a comment" do
      post :create, { comment: { text: "Tag!",
                                 tag_names: "one two" },
                      ticket_id: ticket.id }
      ticket.reload
      expect(ticket.tags).to be_empty
    end
  end
end
