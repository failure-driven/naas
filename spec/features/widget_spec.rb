require "rails_helper"

feature "Widget", js: true do
  around do |example|
    ENV["SCHEME"] = "http"
    ENV["HOST"] = "localhost"
    ENV["PORT"] = "3001"

    example.run

    ENV["SCHEME"] = nil
    ENV["HOST"] = nil
    ENV["PORT"] = nil
  end

  scenario "A widget is displayed on another site" do
    Given "an admin is logged in" do
      user = User.new(
        email: "deb.morrison@petcloud.com",
        user_actions: { admin: { can_administer: true } },
        password: "1password",
        password_confirmation: "1password",
      )
      user.skip_confirmation!
      user.save!
      visit admin_root_path
      page.find("form.new_user").fill_in("Email", with: "deb.morrison@petcloud.com")
      page.find("form.new_user").fill_in("Password", with: "1password")
      page.find("form.new_user").find('input[type="submit"]').click
    end

    When "someone creates a new notifications" do
      # need to do this to start the rails server as well
      # as we could look before there are any notifications
      visit admin_notifications_path
      page.click_on("New notification")
      page.click_on("Switch editor mode")
      page.find(".jsoneditor-type-modes div.jsoneditor-text", text: "Text").click
      4.times do
        page.find("textarea.jsoneditor-text").send_keys(:backspace)
      end
      page.find("textarea.jsoneditor-text").send_keys('{"msg":"hello","color":"cyan"}')
      page.find('.form-actions input[value="Create Notification"]').click
    end

    And "a user visits a demo app on the server" do
      visit "/test_demo.html"
    end

    Then "user sees the result of the rendered widget" do
      wait_for do
        page.find('[data-widget-type|="naas"] [data-testid="data"]').text
      end.to eq("hello")
      # end.to eq('{"msg":"hello","color":"cyan"}')
    end

    When "a user visits a demo app NOT on the server" do
      # TODO: could try to just hit a file but that does NOT work on CI
      # demo_uri = URI("file://#{File.join(__dir__, '..', '..', 'public', 'test_demo.html')}")
      # visit demo_uri

      entry_point = File.join(__dir__, "..", "..", "public", "test_demo.html")
      file_contents = File.read(entry_point)

      unless defined? MyRackWrapperApp
        MyRackWrapperApp = Rack::Builder.new do
          run lambda { |_env|
            [200, {}, [file_contents]]
          }
        end
      end

      Capybara.app = MyRackWrapperApp
      Capybara.server_port = 3002
      visit "/"
    end

    Then "user sees the result of the rendered widget" do
      wait_for do
        page.find('[data-widget-type|="naas"] [data-testid="data"]').text
      end.to eq("hello")
      # end.to eq('{"msg":"hello","color":"cyan"}')
    end
  end
end
