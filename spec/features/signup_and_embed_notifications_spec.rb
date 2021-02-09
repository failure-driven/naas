require "rails_helper"

feature "Signup and embed notification widget", js: true do
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
    When "Melanie is looking for a notification service on naas" do
      visit root_path
    end

    Then "she sees the option to Log in or Sign up" do
      wait_for do
        page.find_all("nav.navbar .nav-item").map(&:text)
      end.to eq(
        ["Log in", "Sign up"],
      )
    end

    When "Melanie signs up" do
      page.find("nav.navbar .nav-item a", text: "Sign up").click
      page.find("form.new_user").fill_in("Email", with: "melanie@canvo.com")
      page.find("form.new_user").fill_in("Password", with: "password")
      page.find("form.new_user").fill_in("Password confirmation", with: "password")
      page.find("form.new_user").find('input[type="submit"]').click
    end

    Then "she is greated with a success message" do
      wait_for do
        page.find('.alert [data-testid="message"]').text
      end.to eq "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
    end

    And "is still on the home page" do
      wait_for { page.current_path }.to eq "/"
    end

    And "she sees a verify your account email" do
      open_email "melanie@canvo.com"
      wait_for { current_email.subject }.to eq "Confirmation instructions"
      wait_for { current_email.to }.to eq(["melanie@canvo.com"])
      wait_for { current_email.from }.to eq(["from+test@example.com"])
      email_body = Capybara.string(current_email.body)
      wait_for do
        email_body.find_all("a").map(&:text)
      end.to eq(
        ["Confirm my account", "Unsubscribe", "Failure Driven"],
      )
    end

    When "Melanie verifies her email by clicking on the link" do
      current_email.click_link "Confirm my account"
    end

    Then "she is shown a success message" do
      wait_for do
        page.find('.alert [data-testid="message"]').text
      end.to eq "Your email address has been successfully confirmed."
    end

    When "she logs in" do
      page.find("form.new_user").fill_in("Email", with: "melanie@canvo.com")
      page.find("form.new_user").fill_in("Password", with: "password")
      page.find("form.new_user").find('input[type="submit"]').click
    end

    Then "she sees a success message" do
      wait_for do
        page.find('.alert [data-testid="message"]').text
      end.to eq "Signed in successfully."
    end

    And "she sees an option to register a new site" do
      pending "a register new site link"
      wait_for do
        page.find("a", text: "Register new site")
      end.to be_truthy
    end

    When "Melanie registers her site Canvo"
    Then "she is shown a success message"
    And "a site key as well as a code snippet to embed into her site"

    When "Melanie embeds the code in Canvo and views Canvo"
    Then "she sees she has no notifications"

    When "Melanie creates a site wide notification for Canvo via NaaS interface and/or API"
    Then "she sees she has 1 notification"
    And "she can view the notification"

    When "she deletes the notification"
    Then "she sees she has no notifications"
  end

  scenario "Widgets are scoped to site and users within a site" do
    Given "there is Canvo and Odofruit site with a NaaS widget"
    And "Limor is on the Odofruit site"
    And "an anonymous user is on the Odofruit site"
    And "Melanie is on the Canvo site"
    And "Cliff is on the Canvo site"

    When "a site wide notification is sent to Odofruitj"
    Then "only Limor and anonymous see the notification"

    When "a notification is sent to Cliff at Canvo"
    Then "only Cliff sees the notification"
  end

  # TODO: set as read/important/archived
end
