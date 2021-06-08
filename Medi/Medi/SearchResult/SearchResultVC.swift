//
//  SearchResultVC.swift
//  Medi
//
//  Created by 이윤진 on 2021/05/25.
//

import UIKit

class SearchResultVC: UIViewController {

    @IBOutlet weak var mediNameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var cautionLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    var name: String?
    var companyName: String?
    var purpose: String?
    var catuion: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediNameLabel.text = name
        companyNameLabel.text = companyName
        purposeLabel.text = purpose
        cautionLabel.text = catuion
        // Do any additional setup after loading the view.
    }
    

}

extension SearchResultVC {
  
    
}
