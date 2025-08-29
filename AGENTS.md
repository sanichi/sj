# Agent Guidelines for Rails Gaming Application

## Build/Test Commands
- **Development server**: `./bin/dev` or `bundle exec rails server`
- **Run all tests**: `bundle exec rspec` or `rake spec`
- **Run single test**: `bundle exec rspec spec/features/user_spec.rb` or `bundle exec rspec spec/features/user_spec.rb:12` (line number)
- **Run test suites**: `rake spec:models`, `rake spec:features`
- **Database setup**: `rake db:create db:migrate db:seed`

## Code Style Guidelines
- **Models**: Use ActiveRecord conventions, include concerns (e.g., `include Pageable`), define constants in ALL_CAPS, use `has_secure_password` for auth
- **Controllers**: Inherit from ApplicationController, use `load_and_authorize_resource` (CanCanCan), define private `resource_params` methods
- **Views**: Use HAML format (.html.haml), Bootstrap classes, turbo frames for dynamic content, i18n with `t()` helper
- **Naming**: Use snake_case for files/methods, CamelCase for classes, handle/first_name/last_name pattern for user attributes
- **Validations**: Use built-in Rails validators with custom regex patterns (e.g., `/\A[A-Z]\w+\z/i` for handles)
- **Helpers**: Create utility methods for common UI patterns (center/col grid helpers, pagination_links, time_ago)
- **Tests**: Use RSpec with FactoryBot, feature tests with Capybara/Selenium, use `let!` for test data, descriptive context blocks
- **I18n**: All user-facing text in locale files (config/locales/), use `t("key.subkey")` format
- **Authentication**: Use bcrypt with `has_secure_password`, CanCanCan for authorization, session-based auth
- **Database**: Use PostgreSQL, ActiveRecord migrations, proper foreign keys and associations