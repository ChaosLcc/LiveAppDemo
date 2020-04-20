//
//  ChatContentCell.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/4/20.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class ChatContentCell: UITableViewCell {
    @IBOutlet weak var msgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = UIColor.clear
    }
}
