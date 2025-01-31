import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  go() {
    window.location.href = "/users/" + this.element.value + "/scores";
  }
}
