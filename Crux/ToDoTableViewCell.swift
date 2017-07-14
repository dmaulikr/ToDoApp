//
//  ToDoTableViewCell.swift
//  Crux
//
//  Created by Shanee Dinay on 7/8/17.
//  Copyright © 2017 CruxDeveloper. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
