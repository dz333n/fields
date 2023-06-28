import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="delete"
export default class extends Controller {
  static targets = ["container"];

  connect() {
    this.confirmationStep = false;
  }

  nextStep() {
    if (!this.confirmationStep) {
      this.containerTarget.innerHTML = "Sure?";
      this.confirmationStep = true;
    } else {
      this.deleteField();
    }
  }

  deleteField() {
    const fieldId = this.data.get("id");
    fetch(`/fields/${fieldId}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
      },
    }).then((response) => {
      if (response.ok) {
        window.location.href = "/fields";
      } else {
        alert("There was an error while deleting field.");
      }
    });
  }

  disconnect() {}
}
