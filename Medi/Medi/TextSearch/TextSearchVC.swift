//
//  TextSearchVC.swift
//  Medi
//
//  Created by 이윤진 on 2021/05/25.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class TextSearchVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textSearchTV: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    let db = Firestore.firestore()
    var medicines: [Medicine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setSearchButton()
        setFirebase()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationLayout()
        
    }
    
    
}

extension TextSearchVC {
    
    func setFirebase() {
        db.collection("Medicine").addSnapshotListener { (QuerySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let snapshotDocuments = QuerySnapshot?.documents {
                    snapshotDocuments.forEach{ (doc) in
                        let data = doc.data()
                        if let name = data["name"] as? String, let caution = data["caution"] as? String, let manu = data["manu"] as? String, let purpose = data["purpose"] as? String {
                            self.medicines.append(Medicine(name: name, purpose: purpose, caution: caution, manu: manu ))
                            DispatchQueue.main.async {
                                self.textSearchTV.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    func setNavigationLayout() {
        
        //navigationController?.navigationItem.title = "약 검색"
        navigationController?.navigationItem.backBarButtonItem?.title = " "
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        
    }
    func setTableView() {
        textSearchTV.separatorStyle = .none
        textSearchTV.delegate = self
        textSearchTV.dataSource = self
        textSearchTV.separatorInset.left = 0
        
    }
    func setSearchButton() {
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
    }
    
    @objc func searchButtonClicked() {
        guard let nvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SearchResultVC") as? SearchResultVC else {
            return
        }
        self.navigationController?.pushViewController(nvc, animated: true)
    }
}

extension TextSearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension TextSearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mediInfo = medicines[indexPath.row]
        let cell = textSearchTV.dequeueReusableCell(withIdentifier: "TextSearchTVC",for: indexPath) as! TextSearchTVC
        cell.medicineNameLabel.text = mediInfo.name
        cell.manuNameLabel.text = mediInfo.manu
        cell.caution = mediInfo.caution
        cell.purpose = mediInfo.purpose
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SearchResultVC") as? SearchResultVC else {
            return
        }
        let mediInfo = medicines[indexPath.row]
        nvc.name = mediInfo.name
        nvc.purpose = mediInfo.purpose
        nvc.catuion = mediInfo.caution
        nvc.companyName = mediInfo.manu
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
}
