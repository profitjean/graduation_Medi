//
//  CameraSearchVC.swift
//  Medi
//
//  Created by 이윤진 on 2021/06/08.
//

import UIKit

class CameraSearchVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationLayout()
        
    }
}

extension CameraSearchVC {
    
    func setNavigationLayout(){
        navigationController?.navigationItem.backBarButtonItem?.title = " "
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}
