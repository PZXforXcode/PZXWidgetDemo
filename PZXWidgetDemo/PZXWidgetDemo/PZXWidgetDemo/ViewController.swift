//
//  ViewController.swift
//  PZXWidgetDemo
//
//  Created by KpengS on 2026/2/5.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {

            let testLabel = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
            //testlabel下面加个按钮
            let testButton = UIButton(frame: CGRect(x: 100, y: 150, width: 200, height: 50))

    let sharedDefaults = UserDefaults(suiteName: "group.dd.work.exclusive4loncin")

    let loadingLabel = UILabel(frame: CGRect(x: 100, y: 200, width: 200, height: 50))
    let flashingLabel = UILabel(frame: CGRect(x: 100, y: 250, width: 200, height: 50))



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //创建一个label
        testLabel.text = "hello world"
        testLabel.textColor = UIColor.red
        testLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(testLabel)
        
        //创建一个按钮
        testButton.setTitle("点击我", for: .normal)
        testButton.setTitleColor(UIColor.blue, for: .normal)
        testButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(testButton)
        
        //给按钮添加点击事件
        testButton.addTarget(self, action: #selector(testButtonClick), for: .touchUpInside)
        
        // 初始化 label 显示状态
        updateLabel()
        
        // 监听 App 回到前台，刷新数据
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFlashUI), name: Notification.Name("TriggerFlashUI"), object: nil)
        
        setupFlashUI()
    }
    
    func setupFlashUI() {
        loadingLabel.text = "正在开启闪灯"
        loadingLabel.textColor = .orange
        loadingLabel.font = UIFont.systemFont(ofSize: 18)
        loadingLabel.isHidden = true
        self.view.addSubview(loadingLabel)
        
        flashingLabel.text = "闪灯中"
        flashingLabel.textColor = .red
        flashingLabel.font = UIFont.systemFont(ofSize: 18)
        flashingLabel.isHidden = true
        self.view.addSubview(flashingLabel)
    }

    @objc func handleFlashUI() {
        // Reset state
        loadingLabel.isHidden = false
        flashingLabel.isHidden = true
        flashingLabel.layer.removeAllAnimations()
        flashingLabel.alpha = 1.0
        
        // 2s loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            self.loadingLabel.isHidden = true
            
            // Start flashing
            self.flashingLabel.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
                self.flashingLabel.alpha = 0.1
            }, completion: nil)
            
            // 2s flashing then stop
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self = self else { return }
                self.flashingLabel.layer.removeAllAnimations()
                self.flashingLabel.alpha = 1.0
                self.flashingLabel.isHidden = true
            }
        }
    }

    @objc func testButtonClick() {
        // 主 App 点击按钮也可以改变状态
        let current = sharedDefaults?.bool(forKey: "isOn") ?? false
        sharedDefaults?.set(!current, forKey: "isOn")
        sharedDefaults?.synchronize() // 保证立刻写入
        updateLabel()
    }
    
    @objc func updateLabel() {
        let isOn = sharedDefaults?.bool(forKey: "isOn") ?? false
        testLabel.text = isOn ? "已开锁" : "已锁定"
        
        //主 App 修改状态后想让 Widget 立即刷新：
        WidgetCenter.shared.reloadAllTimelines()

    }

}

