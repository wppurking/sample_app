require 'spec_helper'

describe "StaticPages" do

  # title 前缀
  title_prefix = "Ruby on Rails Tutorial Sample App |"

  describe 'Home page' do
    before { visit root_path }

    it "should have the content 'Sample App'" do
      #page.should have_content('Sample App')
      page.should have_selector('h1', text: 'Sample App')
    end

    it "should have the base title" do
      page.should have_selector('title', text: title_prefix[0..-2].strip)
    end

    it "should not have a custom page title" do
      page.should_not have_selector('title', text: '| Home')
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem")
        FactoryGirl.create(:micropost, user: user, content: "Ipsum")
        sign_in user
        visit root_path
      end

      it "should render the user`s feed" do
        #puts page.body
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
          puts page.body
        end

        # TODO 这里没有通过测试, 为什么? 哪里错了?
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end

  end

  describe 'Help page' do
    # run before each [it ... do end]
    before { visit help_path }

    it "should have the content 'Help'" do
      #page.should have_content('Help')
      page.should have_selector('h1', text: 'Help')
    end

    it "should have the title 'Help'" do
      page.should have_selector('title', text: "#{title_prefix} Help")
    end
  end

  describe 'About page' do
    before do # before 接受的是一个代码块(函数)
      visit about_path
    end


    it "should have the content 'About Us'" do
      #page.should have_content('About Us')
      page.should have_selector('h1', text: 'About Us')
    end

    it "should have the title 'About Us'" do
      page.should have_selector('title', text: "#{title_prefix} About Us")
    end
  end

  describe 'Contact page' do
    before { visit contact_path }

    it "should have the content 'Contact'" do
      page.should have_selector('title', text: 'Contact')
    end
    it "should have right title" do
      page.should have_selector('title', text: "#{title_prefix} Contact")
    end
  end

end
