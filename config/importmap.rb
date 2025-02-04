pin "application"
pin "popper", to: "popper.js"
pin "bootstrap", to: "bootstrap.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers", preload: "false"
pin "elm", to: "elm.min.js", preload: false
pin "pretty-print-json", preload: false # @3.0.4
pin "@hotwired/turbo-rails", to: "turbo.min.js"
