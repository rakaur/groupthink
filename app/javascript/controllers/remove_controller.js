import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remove"
export default class extends Controller {
  static targets = ["remove"]

  remove() {
    this.removeTarget.remove()
  }
}
