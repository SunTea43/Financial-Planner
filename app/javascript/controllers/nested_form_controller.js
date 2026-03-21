import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]

  add(event) {
    event.preventDefault()

    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML("beforeend", content)

    // Optional: if we want to update positions for sortable after adding
    if (this.hasContainerTarget && this.containerTarget.dataset.controller === "sortable") {
      this.dispatch("added", { detail: { container: this.containerTarget } })
    }
  }

  remove(event) {
    event.preventDefault()

    const wrapper = event.target.closest(".nested-fields") || event.target.closest(".card")

    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove()
    } else {
      wrapper.querySelector("input[name*='_destroy']").value = "1"
      wrapper.style.display = "none"
    }
  }
}
