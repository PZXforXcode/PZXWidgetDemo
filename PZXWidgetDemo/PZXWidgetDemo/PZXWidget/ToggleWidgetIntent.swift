//
//  ToggleWidgetIntent.swift
//  PZXWidgetExtension
//
//  Created by KpengS on 2026/2/6.
//

import AppIntents
import SwiftUI

struct ToggleWidgetIntent: AppIntent {

    static var title: LocalizedStringResource = "Toggle Widget"

    @AppStorage("isOn", store: UserDefaults(suiteName:"group.dd.work.exclusive4loncin"))
    var isOn: Bool = false

    func perform() async throws -> some IntentResult {
        isOn.toggle()
        print("Widget Button Clicked isOn = \(isOn)")

        // NotificationCenter 在 Extension 内部发通知无法传达到主 App，已移除
        return .result()
    }
}
