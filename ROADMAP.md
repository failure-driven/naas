# Roadmap

- [X] fix build
- [ ] User managment
- [ ] sites per user model
- [ ] security of reads
- [ ] status
- [ ] styling
  - site bar should not be a nav but it's own thing
  - use jumbotron for homepage ads
  - how big is the widget, how to inline styles, is bootstrap being used?
- [ ] useability
  - limit the number of keys
  - allow to add a user
  - add a footer
- annoyances
  - [ ] capybara cannot run without internet?
    ```
      1.1) Failure/Error: driver.browser.send(:bridge).singleton_class.prepend(SlomoBridge)

      Webdrivers::ConnectionError:
        Can not reach https://chromedriver.storage.googleapis.com/LATEST_RELEASE_88.0.4324
      # ./spec/support/capybara.rb:30:in `block (2 levels) in <main>'
      # ./spec/support/capybara.rb:28:in `tap'
      # ./spec/support/capybara.rb:28:in `block in <main>'
    ```
  - [ ] use `@monaco-editor/react` or similar to display the code snippet

---

- [ ] fixes
  - [ ] replace SCHEME, HOST and PORT with API_HOST
  - [ ] review size of Javascript
- [ ] security of writes
- [ ] security of who to write to
- [ ] token refresh
- [ ] callbacks vs dropping it in
- [ ] poll vs web socket
- [ ] review notifications database

---

## Done

- ...

