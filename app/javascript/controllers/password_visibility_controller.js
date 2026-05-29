import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "toggle" ]

  toggle() {
    const showing = this.inputTarget.type == "text"
    const nextType = showing ? "password" : "text"

    this.inputTarget.type = nextType
    this.toggleTarget.textContent = showing ? this.showText : this.hideText
  }

  get showText() {
    return this.toggleTarget.dataset.showText || "Show password"
  }

  get hideText() {
    return this.toggleTarget.dataset.hideText || "Hide password"
  }
}
