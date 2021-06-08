//
//  RecordTVC.swift
//  Medi
//
//  Created by 이윤진 on 2021/05/26.
//

import UIKit

class RecordTVC: UITableViewCell {

    @IBOutlet weak var mediDurationLabel: UILabel!
    @IBOutlet weak var mediNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
