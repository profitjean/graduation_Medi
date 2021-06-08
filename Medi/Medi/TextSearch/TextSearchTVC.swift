//
//  TextSearchTVC.swift
//  Medi
//
//  Created by 이윤진 on 2021/05/25.
//

import UIKit

class TextSearchTVC: UITableViewCell {

    @IBOutlet weak var manuNameLabel: UILabel!
    @IBOutlet weak var medicineNameLabel: UILabel!
    var caution: String?
    var purpose: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
