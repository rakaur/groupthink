import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static classes = [ "active" ]

  toggleActive(event) {
    this.element.classList.toggle(this.activeClass)
  }
}
