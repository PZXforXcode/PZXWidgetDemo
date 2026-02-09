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
        // 将 Action 写入 App Group，主 App 被唤起后读取并执行
        let defaults = UserDefaults(suiteName: WidgetConstants.appGroupIdentifier)
        defaults?.set(action ?? "unknown", forKey: WidgetConstants.Keys.launchAction)
        defaults?.synchronize()
        return .result()
    }

}


struct OpenAppIntent: AppIntent {
    
    static var title: LocalizedStringResource { "Open App" }
    //如果要打开App记得在主工程的Target - Compile Sources  Add 这个文件
    static var openAppWhenRun:Bool = true
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(name: .openAppNotification, object: nil, userInfo: ["parameter": "specialParameter"])
        return .result()
    }
}
