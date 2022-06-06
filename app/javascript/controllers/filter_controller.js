import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = [ "panelActive", "clear" ]

  clear(event) {
    event.preventDefault()
    this.clearTarget.value = null
  }

  clearAll(event) {
    event.preventDefault()

    this.clearTargets.forEach(target => {
      target.value = null
    })
  }

  inputChanged(event) {
    const fieldName = this.clearTarget.id.split("_")[1]
    const button = this.element.querySelector(`#${fieldName}_button`)

    if (this.clearTarget.value == null || this.clearTarget.value == "") {
      button.classList.remove("is-active")
    } else {
      button.classList.add("is-active")
    }
  }

  inputChangedAll() {
    console.log("inputChangedAll()")

    this.clearTargets.forEach(target => {
      let fieldName = target.id.split("_")[1]
      let button = this.element.querySelector(`#${fieldName}_button`)

      if (target.value == null || target.value == "") {
        button.classList.remove("is-active")
      } else {
        button.classList.add("is-active")
      }
    })
  }
}
