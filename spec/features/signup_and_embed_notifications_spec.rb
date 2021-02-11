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
      wait_for { page.find("form.new_user") }
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

    And "she sees no sites have been added and an option to add one" do
      wait_for do
        page.find('[data-testid="sites"]').text
      end.to eq "add a site to get started ..."
      wait_for do
        page.find_all('[data-testid="sites-nav"] .nav-item a').map(&:text)
      end.to eq ["New site"]
    end

    When "Melanie registers her site Canvo" do
      page
        .find('[data-testid="sites-nav"] .nav-item a', text: "New site")
        .click
      page
        .find("form[action=\"/sites\"]")
        .fill_in("Url", with: "http://canvo.com")
      page
        .find('form[action="/sites"]')
        .find('input[type="submit"]')
        .click
    end

    Then "she is shown a success message" do
      wait_for do
        page.find('.alert [data-testid="message"]').text
      end.to eq "Site was successfully created."
    end

    And "is told to generate a key and there is no code snippet" do
      wait_for do
        page.find('[data-testid="getting-started"]').text
      end.to include("add a key under settings to get started")
      wait_for do
        page
          .find('[data-testid="getting-started"]')
          .find_all('[data-testid="code-snippet"]')
      end.to be_empty
    end

    When "she goes to the settings tab and creates a key" do
      page
        .find("[data-testid=\"site-nav\"] .nav-item", text: "Settings")
        .click
      page.click_on("Create Key")
    end

    Then "she is show a success message and a key" do
      wait_for do
        page.find('.alert [data-testid="message"]').text
      end.to eq "Key was successfully generated."
    end

    When "she goest to the overview tab" do
      page
        .find("[data-testid=\"site-nav\"] .nav-item", text: "Overview")
        .click
    end

    Then "she sees a code snippet to embed into her site" do
      wait_for do
        page
          .find('[data-testid="getting-started"]')
          .find('[data-testid="code-snippet"]')
          .text
      end.to eq('<div data-widget-type="naas-version1" ' \
        'data-token="jwt goes in here"> </div> <script ' \
        'type="text/javascript" src="http://localhost:3001/naas"> ' \
        "</script>")
    end

    When "Melanie copies and embeds the code in Canvo and views Canvo" do
      pending "a code snippet copy button"
      page
        .find('[data-testid="getting-started"]')
        .find('[data-testid="code-snippet-copy"]')
        .click
    end

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
