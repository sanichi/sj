pin "application"
pin "jquery", to: "jquery3.min.js"
pin "popper", to: "popper.js"
pin "bootstrap", to: "bootstrap.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers", preload: "false"
pin "elm", to: "elm.min.js", preload: false
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3
pin "pretty-print-json", preload: false # @3.0.4
pin "@hotwired/turbo-rails", to: "turbo.min.js"
