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
        let defaults = UserDefaults(suiteName: "group.dd.work.exclusive4loncin")
        guard let action = defaults?.string(forKey: "launch_action") else { return }
        defaults?.removeObject(forKey: "launch_action")
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
                name: Notification.Name("OpenAppNotification"),
                object: nil
            )
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(handleOpenAppNotification(_:)),
                name: Notification.Name("OpenAppNotification"),
                object: nil
            )
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    @objc private func handleOpenAppNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let specialParameter = userInfo["parameter"] as? String {
            // 根据 specialParameter 处理页面跳转逻辑
            print("specialParameter = \(specialParameter)")
            
            
        }
    }


    private func handleLaunchAction(_ action: String) {
        switch action {
        case "loncin_flash":
            print("执行闪灯")
            NotificationCenter.default.post(name: Notification.Name("TriggerFlashUI"), object: nil)
            
        case "loncin_unlock":
            LockManager.shared.unlock()
        case "loncin_lock":
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
