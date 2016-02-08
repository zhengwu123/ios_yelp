//
//  SwitchCell.swift
//  Yelp
//
//  Created by New on 2/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
@objc protocol SwitchCellDelegate{
   optional func switchCell(switchcell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet var switchButton: UISwitch!
    @IBOutlet var switchlabel: UILabel!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func valueChanged(sender: AnyObject) {
        print("chao!")
        delegate?.switchCell?(self, didChangeValue: switchButton.on)
    }
}
