import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "timer", "steps" ]
  static values = { walkId: Number, initialSteps: Number, initialDuration: Number }

  connect() {
    this.steps = this.initialStepsValue
    this.seconds = this.initialDurationValue
    this.updateDisplay()
    this.startTimer()
    this.autoSaveTimer = setInterval(() => this.saveProgress(), 10000)

    window.updateStepDisplay = (count) => {
      this.steps = count
      this.updateDisplay()
    }
  }

  disconnect() {
    clearInterval(this.timerInterval)
    clearInterval(this.autoSaveTimer)
  }

  startTimer() {
    this.timerInterval = setInterval(() => {
      this.seconds++
      this.updateDisplay()
    }, 1000)
  }

  updateDisplay() {
    if (this.hasTimerTarget) {
      const mins = Math.floor(this.seconds / 60).toString().padStart(2, '0')
      const secs = (this.seconds % 60).toString().padStart(2, '0')
      this.timerTarget.textContent = `${mins}:${secs}`
    }
    if (this.hasStepsTarget) {
      this.stepsTarget.textContent = this.steps.toLocaleString()
    }
  }

  async saveProgress() {
    fetch(`/walkings/${this.walkIdValue}/save_progress`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
      body: JSON.stringify({ walking: { steps: this.steps, duration: this.seconds } })
    })
  }

  async stop(event) {
    event.preventDefault()
    if (!confirm('お散歩を終了して記録を保存しますか？')) return

    const res = await fetch(`/walkings/${this.walkIdValue}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
      body: JSON.stringify({ steps: this.steps, duration: this.seconds })
    })

    if (res.ok) {
      const data = await res.json()
      window.location.href = data.redirect_url
    } else {
      alert("保存に失敗しました。もう一度お試しください。")
    }
  }
}