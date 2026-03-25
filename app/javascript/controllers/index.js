
// app/javascript/controllers/index.js

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

// 💡 ファイル名 walking_mode_controller.js と完全に一致させる
import WalkingModeController from "./walking_mode_controller"
application.register("walking-mode", WalkingModeController)