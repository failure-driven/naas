require "rails_helper"

feature "bootstrap and onboard process", js: true do
  scenario "The founder bootstraps the site and onboards a user from the internet" do
    Given "Limor from Adafruit fame decides to start a new venture called NaaS" do
      visit root_path
    end

    When "Limor signs up" do
      page.find("nav").click_on("Sign up")
      page.find(".new_user").fill_in("Email", with: "limor.fried@adafruit.com")
      page.find(".new_user").fill_in("Password", with: "1password")
      page.find(".new_user").fill_in("Password confirmation", with: "1password")
      page.find("form.new_user").find('input[type="submit"]').click
      wait_for do
        page.find(".alert [data-testid=\"message\"]").text
      end.to eq "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
      open_email "limor.fried@adafruit.com"
      Capybara.string(current_email.body)
      current_email.click_link "Confirm my account"
      wait_for do
        page.find('.alert [data-testid="message"]').text
      end.to eq "Your email address has been successfully confirmed."
    end

    And "logs in" do
      page.find("form.new_user").fill_in("Email", with: "limor.fried@adafruit.com")
      page.find("form.new_user").fill_in("Password", with: "1password")
      page.find("form.new_user").find('input[type="submit"]').click
      wait_for do
        page.find('.alert [data-testid="message"]').text
      end.to eq "Signed in successfully."
    end

    And "connects to the server to give herself admin priveledges" do
      require "rake"
      Rake::Task.define_task(:environment)
      Rake.application.rake_require "tasks/user"
      Rake::Task["user:make_admin"].reenable
      Rake.application.invoke_task "user:make_admin[limor.fried@adafruit.com]"
    end

    Then "she can navigate to the admin part of the site after a refresh" do
      wait_for do
        page.find_all("nav .navbar-nav .nav-link").map(&:text)
      end.to contain_exactly("Sites", "limor.fried@adafruit.com")
      page.refresh
      wait_for do
        page.find_all("nav .navbar-nav .nav-link").map(&:text)
      end.to contain_exactly("Admin", "Sites", "limor.fried@adafruit.com")
      page.find("nav .navbar-nav .nav-link", text: "Admin").click
    end

    When "she signs up her co-founder Meredith from uBeam" do
      page.find("nav .navigation__link", text: "Users", match: :prefer_exact).click
      page.find("header a", text: "New user").click
      page.find("form#new_user").fill_in("Email", with: "meredith.perry@ubeam.com")
      page.find("form#new_user").find('input[type="submit"]').click
      pending "this can be done successfully without setting a password"
      wait_for do
        page.find(".flash-error").text
      end.to eq "successfully created user and signup email sent with reset password instructions"
    end

    And "promotes her to admin via the admin ui"
    Then "Meredith is notified she can adminster NaaS"
    When "Leah from Task Rabbit signs up to Naas"
    And "Tracy from Plangtid signs up to Naas"
    And "the new resitered signups job runs"
    Then "Meredith is notified there are 2 new sign ups"
    When "Meredith sends out an EDM"
    Then "leah and Tracy both recieve more information about NaaS"
    When "Meredith decides to promote Leah to Beta tester"
    Then "Leah is notified and prompted to accept"
    When "Leah accepts"
    Then "she can now setup a NaaS Beta account for Task Rabbit"
    When "Leah embeds the NaaS widget on Task Rabbit"
    And "she sends a notification to all users"
    Then "users on Task Rabbit see the notification"
  end
end
