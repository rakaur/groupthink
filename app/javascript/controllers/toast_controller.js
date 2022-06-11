import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

// Connects to data-controller="toast"
export default class extends Controller {
  static values = { icon: String, title: String }

  initialize() {
    this.toast = Swal.mixin({
      toast: true,
      position: "top-end",
      timer: 5000,
      timerProgressBar: true,
      showCloseButton: true,
      showConfirmButton: false,
      iconColor: "white",
      customClass: { popup: "colored-toast" },

      didOpen: (toast) => {
        toast.addEventListener("mouseenter", Swal.stopTimer)
        toast.addEventListener("mouseleave", Swal.resumeTimer)
      }
    })
  }

  // If we connect, assume it's time to fire a toast
  connect() {
    if (this.hasTitleValue) {
      this.toast.fire({
        icon: this.iconValue,
        title: this.titleValue
      })
    }
  }
}
