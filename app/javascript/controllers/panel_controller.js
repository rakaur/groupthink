import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="panel"
export default class extends Controller {
  static targets = [ "input" ]

  resetFilters() {
    event.preventDefault()

    this.inputTargets.forEach(target => {
      target.value = null
      target.dispatchEvent(new Event("input"))
    })
  }
}
