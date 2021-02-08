require "rails_helper"

feature "Widget", js: true do
  scenario "A widget is displayed on another site" do
    When "user visits a demo app" do
      demo_uri = URI("file://#{File.join(__dir__, '..', '..', 'demo.html')}")
      visit demo_uri
    end

    Then "user sees the result of the rendered widget" do
      wait_for do
        page.find_all('[data-widget-type|="naas"]').map(&:text)
      end.to eq(["hellojwt goes in here"])
    end
  end
end
