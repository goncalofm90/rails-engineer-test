import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  
  connect() {
    this.timeout = null
  }

  submit(event) {
    if (event.type === "input") {
      event.preventDefault()
      
      clearTimeout(this.timeout)
      
      this.timeout = setTimeout(() => {
        this.performSearch()
      }, 300)
    }
  }

  performSearch() {
    const query = this.inputTarget.value
    const url = new URL(this.element.action)
    url.searchParams.set("query", query)

    fetch(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
      .then(response => response.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
  }
}