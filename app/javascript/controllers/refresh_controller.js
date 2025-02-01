import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.wait();
  }

  tik() {
    Turbo.visit("/games/waiting", { frame: "refresh" })
    this.wait();
  }

  wait() {
    setTimeout(() => this.tik(), 3000)
  }
}
