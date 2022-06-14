import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = [ "hide", "show" ]

  toggleMenu() {
    this.showTarget.classList.toggle("!hidden")
    this.hideTarget.classList.toggle("!hidden")
  }
}
