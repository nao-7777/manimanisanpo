import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="walking-mode"
export default class extends Controller {
  static targets = [ "timer", "distance", "pauseButtonText" ]

  connect() {
    // 💡 画面が開いた時の処理（タイマー開始、Geolocation開始など）
    console.log("お散歩モード開始！")
  }

  disconnect() {
    // 💡 画面が閉じた時の処理（タイマー停止、Geolocation停止など）
    console.log("お散歩モード終了！")
  }

  // ⏸️ 一時停止ボタンが押された時
  togglePause(event) {
    event.preventDefault()
    // 💡 タイマーの一時停止・再開を切り替える処理
    console.log("一時停止/再開")
    this.pauseButtonTextTarget.textContent = (this.pauseButtonTextTarget.textContent === "一時停止") ? "再開" : "一時停止"
  }

  // ⏹️ 終了ボタンが押された時（保存処理はbutton_toで行う）
  stop(event) {
    // 💡 Geolocation停止などの後処理
    console.log("終了ボタン")
  }
}