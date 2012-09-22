require 'spec_helper'

describe RelationshipsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { sign_in user }

  describe "creating a relationship with Ajax" do

    it "should increment the Relationship count" do
      expect do
        # xhr 是 ActionControll::TestCase 中的
        # xhr 中的第二个参数为 action, 用来指定 Controller 中调用的方法,
        # 而实现中使用的是 __send__ 来发送, 也就是说是 xhr 是在 RelationshipsController 类中的方法,
        # 但是是利用 ruby 特性 Mixin 进来的
        xhr :post, :create, relationship: {followed_id: other_user.id}
      end.to change(Relationship, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, relationship: {followed_id: other_user.id}
      response.should be_success
    end
  end

  describe "destroying a relationship with Ajax" do
    before { user.follow!(other_user) }
    let(:relationship) { user.relationships.find_by_followed_id(other_user) }

    it "should decrement the Relationship count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: relationship.id
      response.should be_success
    end
  end

end
