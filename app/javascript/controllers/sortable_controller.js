import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
    connect() {
        this.sortable = Sortable.create(this.element, {
            animation: 150,
            handle: ".drag-handle",
            onEnd: this.end.bind(this)
        })
    }

    end(event) {
        this.updatePositions()
    }

    updatePositions() {
        this.element.querySelectorAll(".nested-fields").forEach((item, index) => {
            const positionField = item.querySelector("input[name*='[position]']")
            if (positionField) {
                positionField.value = index + 1
            }
        })
    }
}
