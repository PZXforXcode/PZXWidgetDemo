//
//  SceneDelegate.swift
//  PZXWidgetDemo
//
//  Created by KpengS on 2026/2/5.
//

import UIKit
import Intents

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        // 1. Widget 通过 App Group 把 Action 写入 UserDefaults
        // 2. App 被唤起后在这里读取 Action 并分发业务
        let defaults = UserDefaults(suiteName: WidgetConstants.appGroupIdentifier)
        guard let action = defaults?.string(forKey: WidgetConstants.Keys.launchAction) else { return }
        // 读取后立即移除，避免 App 再次激活时重复触发
        defaults?.removeObject(forKey: WidgetConstants.Keys.launchAction)
        defaults?.synchronize()
        handleLaunchAction(action)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        NotificationCenter.default
            .removeObserver(
                self,
                name: .openAppNotification,
                object: nil
            )
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(handleOpenAppNotification(_:)),
                name: .openAppNotification,
                object: nil
            )
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    @objc private func handleOpenAppNotification(_ notification: Notification) {
        // 这个示例用于演示 App Intent 通过通知触发 App 内部逻辑
        if let userInfo = notification.userInfo, let specialParameter = userInfo["parameter"] as? String {
            // 根据 specialParameter 处理页面跳转逻辑
            print("specialParameter = \(specialParameter)")
            
            
        }
    }


    private func handleLaunchAction(_ action: String) {
        // 根据 Widget 传入的 Action 做业务分发
        switch action {
        case WidgetConstants.Actions.flash:
            print("执行闪灯")
            // 通过通知触发 UI，让业务逻辑与界面解耦
            NotificationCenter.default.post(name: .triggerFlashUI, object: nil)
            
        case WidgetConstants.Actions.unlock:
            LockManager.shared.unlock()
        case WidgetConstants.Actions.lock:
            LockManager.shared.lock()
        default:
            break
        }
    }
    

}

final class LockManager {
    static let shared = LockManager()
    
    func unlock() {
        print("执行开锁逻辑：网络请求 / 蓝牙操作")
    }
    
    func lock() {
        print("执行上锁逻辑")
    }
}
