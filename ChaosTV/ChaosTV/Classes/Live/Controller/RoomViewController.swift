//
//  LiveViewController.swift
//  XMGTV
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit

private let kChatToolsViewHeight: CGFloat = 44
private let kGiftListViewHeight : CGFloat = kScreenH * 0.5
private let kChatContentViewHeight : CGFloat = 200

class RoomViewController: UIViewController, Emitterable {
    
    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    
    private lazy var chatToolsView: ChatToolsView = ChatToolsView.loadFromNib()
    private lazy var giftListView: GiftListView = GiftListView.loadFromNib()
    private lazy var chatContentView: ChatContentView = ChatContentView.loadFromNib()
    
    // MARK: 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        setupBottomView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}


// MARK:- 设置UI界面内容
extension RoomViewController {
    fileprivate func setupUI() {
        setupBlurView()
        setupBottomView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    fileprivate func setupBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    private func setupBottomView() {
        view.addSubview(chatContentView)
        chatContentView.frame = CGRect(x: 0, y: view.bounds.height - kChatToolsViewHeight - kChatContentViewHeight - kBottomSafeHeight, width: view.bounds.width, height: kChatContentViewHeight)
        chatContentView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        view.addSubview(chatToolsView)
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        // viewDidLoad()中设置frame(注意: 这里用的是view的height和width) view通过xib加载的尺寸在viewDidLoad中不准确, 导致frame错误
        // 可以通过下面代码设置autoresizingMask 或者 在viewWillLayoutSubviews()中设置frame
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolsView.delegate = self
        
        view.addSubview(giftListView)
        giftListView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftListViewHeight)
        giftListView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        giftListView.delegate = self
    }
}
extension RoomViewController: ChatToolsViewDelegate {
    func chatToolsView(toolView: ChatToolsView, message: String) {
        printLog(message)
        chatContentView.insertMsg(message)
    }
}
extension RoomViewController: GiftListViewDelegate {
    func giftListView(giftView: GiftListView, giftModel: GiftModel) {
        printLog(giftModel.img2)
        UIView.animate(withDuration: 0.3) {
            self.giftListView.frame.origin.y = self.view.bounds.height
        }
        chatContentView.insertMsg("赠送 \(giftModel.subject) \(giftModel.img2)")
    }
}

// MARK:- 事件监听
extension RoomViewController {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("点击了聊天")
            chatToolsView.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            print("点击了礼物")
            UIView.animate(withDuration: 0.3) {
                self.giftListView.frame.origin.y = self.view.bounds.height - kGiftListViewHeight
            }
        case 3:
            print("点击了更多")
        case 4:
            print("点击了粒子")
            let point = CGPoint(x: sender.center.x + 20, y: kScreenH - sender.frame.size.height * 0.5 - kBottomSafeHeight)
            sender.isSelected = !sender.isSelected
            sender.isSelected ? startEmittering(point) : stopEnittering()
        default:
            fatalError("未处理按钮")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolsView.inputTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.giftListView.frame.origin.y = self.view.bounds.height
        }
    }
    
    @objc private func keyboardWillChangeFrame(_ note : Notification) {
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            printLog(inputViewY)
            let endY = inputViewY == (self.view.bounds.height - kChatToolsViewHeight) ? self.view.bounds.height : inputViewY
            self.chatToolsView.frame.origin.y = endY
            
            let chatContentViewEndY = inputViewY == (self.view.bounds.height - kChatToolsViewHeight) ? (self.view.bounds.height - kBottomSafeHeight - kChatToolsViewHeight - kChatContentViewHeight) : (endY - kChatContentViewHeight)
            self.chatContentView.frame.origin.y = chatContentViewEndY
        }) { (_) in
            
        }
    }
}
