require 'spec_helper'

describe "StaticPages" do

  # title 前缀
  title_prefix = "Ruby on Rails Tutorial Sample App |"

  describe 'Home page' do

    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      #page.should have_content('Sample App')
      page.should have_selector('h1', text: 'Sample App')
    end

    it "should have the base title" do
      visit '/static_pages/home'
      page.should have_selector('title', text: title_prefix[0..-2].strip)
    end

    it "should not have a custom page title" do
      visit '/static_pages/home'
      page.should_not have_selector('title', text: '| Home')
    end

  end

  describe 'Help page' do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      #page.should have_content('Help')
      page.should have_selector('h1', text: 'Help')
    end

    it "should have the title 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('title', text: "#{title_prefix} Help")
    end
  end

  describe 'About page' do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      #page.should have_content('About Us')
      page.should have_selector('h1', text: 'About Us')
    end

    it "should have the title 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('title', text: "#{title_prefix} About Us")
    end
  end

  describe 'Contact page' do
    it "should have the content 'Contact'" do
      visit '/static_pages/contact'
      page.should have_selector('title', text: 'Contact')
    end

    it "should have right title" do
      visit '/static_pages/contact'
      page.should have_selector('title', text: "#{title_prefix} Contact")
    end
  end

end
