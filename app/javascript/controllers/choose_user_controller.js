import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  go() {
    Turbo.visit("/users/" + this.element.value + "/scores");
  }
}
