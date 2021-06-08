//
//  MainVC.swift
//  Medi
//
//  Created by 이윤진 on 2021/05/25.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var imageSearchButton: UIButton!
    @IBOutlet weak var textSearchButton: UIButton!
    @IBOutlet weak var introLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    func setLayout() {
//        navigationController?.isNavigationBarHidden = true
        introLabel.text = "당신의 의약품을\n검색하세요."
    }
}
