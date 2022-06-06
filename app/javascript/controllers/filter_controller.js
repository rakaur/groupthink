import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = [ "button", "dropdown", "input" ]

  clearInput(event) {
    event.preventDefault()

    this.inputTarget.value = null
    this.inputTarget.dispatchEvent(new Event("input"))
  }

  inputChanged() {
    if (this.inputTarget.value == null || this.inputTarget.value == "" || this.inputTarget.value == "0") {
      if (this.buttonTarget.classList.contains("is-active")) {
        this.buttonTarget.classList.remove("is-active")
      }
    } else {
      if (!this.buttonTarget.classList.contains("is-active")) {
        this.buttonTarget.classList.add("is-active")
      }
    }
  }

  toggleDropdown() {
    this.dropdownTarget.classList.toggle("is-active")
  }
}
