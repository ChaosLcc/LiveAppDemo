//
//  ChatContentView.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/4/20.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

private let kChatContentViewCell = "kChatContentViewCell"

class ChatContentView: UIView, NibLoadable {
    
    private lazy var messages: [String] = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: "ChatContentCell", bundle: nil), forCellReuseIdentifier: kChatContentViewCell)
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
    }

    func insertMsg(_ message: String) {
        messages.append(message)
        tableView.reloadData()
        
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
    }
}

extension ChatContentView:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kChatContentViewCell, for: indexPath) as! ChatContentCell
        cell.msgLabel.text = messages[indexPath.row]
        return cell
    }
    
    
}
