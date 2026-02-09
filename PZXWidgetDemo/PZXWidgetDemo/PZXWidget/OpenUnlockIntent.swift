//
//  OpenUnlockIntent.swift
//  PZXWidgetExtension
//
//  Created by KpengS on 2026/2/6.
//

import Foundation
import AppIntents
import SwiftUI

struct OpenUnlockIntent: AppIntent {

    static var title: LocalizedStringResource = "打开 App 并开锁"

//    / 👇 关键：允许打开 App
    static var openAppWhenRun: Bool = true
//
//    /// 👇 传给 App 的参数
    @Parameter(title: "Action")
    var action: String?

    init() {}
    
    init(action: String) {
        self.action = action
    }

    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "group.dd.work.exclusive4loncin")
        defaults?.set(action ?? "unknown", forKey: "launch_action")
        defaults?.synchronize()
        return .result()
    }

}


struct OpenAppIntent: AppIntent {
    
    static var title: LocalizedStringResource { "Open App" }
    //如果要打开App记得在主工程的Target - Compile Sources  Add 这个文件
    static var openAppWhenRun:Bool = true
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(name: Notification.Name("OpenAppNotification"), object: nil, userInfo: ["parameter": "specialParameter"])
        return .result()
    }
}
