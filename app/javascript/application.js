import "jquery"
import "popper"
import "bootstrap"
import "@hotwired/turbo-rails"
import "controllers"

import Rails from "@rails/ujs"
Rails.start();

Turbo.session.drive = false
