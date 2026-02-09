//
//  WidgetConstants.swift
//  PZXWidgetDemo
//
//  Created by PZXWidgetDemo Refactor.
//

import Foundation

/// Widget 相关常量管理类
/// 用于统一管理 App Group ID、UserDefaults Key、Action 标识符等
struct WidgetConstants {
    
    /// App Group Identifier - 用于 App 和 Widget 之间共享数据
    static let appGroupIdentifier = "group.dd.work.exclusive4loncin"
    
    /// UserDefaults Keys
    struct Keys {
        /// 用于存储 Widget 点击触发的 Action
        static let launchAction = "launch_action"
        /// 用于存储开关状态
        static let isOn = "isOn"
    }
    
    /// Action Identifiers - Widget 按钮对应的操作标识
    struct Actions {
        /// 闪灯操作
        static let flash = "loncin_flash"
        /// 开锁操作
        static let unlock = "loncin_unlock"
        /// 关锁操作
        static let lock = "loncin_lock"
    }
}

// MARK: - Notification Name Extension
extension Notification.Name {
    /// 触发闪灯 UI 交互的通知
    static let triggerFlashUI = Notification.Name("TriggerFlashUI")
    
    /// App 打开通知 (预留)
    static let openAppNotification = Notification.Name("OpenAppNotification")
}
