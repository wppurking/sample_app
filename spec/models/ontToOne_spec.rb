require "rspec"

describe "One2One behave" do
  let(:user) { FactoryGirl.create(:user) }

  # Assigning an object to a has_one association automatically saves that object and
  # the object being replaced (if there is one), in order to update their
  # foreign keys - except if the parent object is unsaved (new_record? == true).
  it "should auto save the ont2one has_one object" do
    card = Card.new(title: "id card", body: "430103198806163038")
    card.new_record?.should == true
    # 当将 card 设置给 user.card[has_one], 会自动保存
    user.card = card
    card.new_record?.should == false
  end

  describe "should not auto save the one2one belongs_to object" do
    before do
      @card = Card.create(title: "id card", body: "this is card body!")
      @card.user = User.new(name: "wyatt", email: "wy@ea.com", password: "foo", password_confirmation: "foo")
    end

    it { @card.user.new_record?.should == true }
    # Assigning an object to a belongs_to association does not save the object,
    # since the foreign key field belongs on the parent. It does not save the parent either.
    it do
      @card.save
      @card.user.new_record?.should == true
    end

  end
end