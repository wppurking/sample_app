# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }

  before do
    # 不能够这样编写, 这样的话,也会因为跳过 mass assign 而引发安全问题, 谁都可以修改 user_id
    #@micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
    @micropost = user.microposts.build(content: "Lorem ipsum")
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
