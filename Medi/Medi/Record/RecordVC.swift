//
//  RecordVC.swift
//  Medi
//
//  Created by 이윤진 on 2021/05/25.
//

import UIKit
import FirebaseFirestore

class RecordVC: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordTV: UITableView!
    @IBOutlet weak var introLabel: UILabel!
    let db = Firestore.firestore()
    var checkings: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setRecordButton()
        setLayout()
        setFirebase()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.navigationBar.isHidden = true
        navigationController?.navigationItem.backBarButtonItem?.title = " "
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
  
}

extension RecordVC {
    func setFirebase() {
        db.collection("Patient").addSnapshotListener {(QuerySnapshot, error) in
            self.checkings = []
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let snapshotDocuments = QuerySnapshot?.documents {
                    snapshotDocuments.forEach{ (doc) in
                        let data = doc.data()
                        if let name = data["name"] as? String, let caution = data["caution"] as? String, let date = data["date"] as? String {
                            self.checkings.append(User(caution: caution, date: date, name: name))
                            DispatchQueue.main.async {
                                self.recordTV.reloadData()
                            }
            
                        }
                    }
                }
            }
        }
    }
    
    func setLayout() {
        introLabel.text = "의약품을\n기록하세요."
    }
    func setTableView() {
        recordTV.separatorStyle = .none
        recordTV.delegate = self
        recordTV.dataSource = self
    }
    
    func setRecordButton() {
        recordButton.addTarget(self, action: #selector(recordButtonClicked), for: .touchUpInside)
    }
    
    @objc func recordButtonClicked() {
        guard let nvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SaveVC") as? SaveVC else { return }
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
}

extension RecordVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension RecordVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let checkingInfo = checkings[indexPath.row]
        let cell = recordTV.dequeueReusableCell(withIdentifier: "RecordTVC") as! RecordTVC
        cell.mediNameLabel.text = checkingInfo.name
        cell.mediDurationLabel.text = " ~\(checkingInfo.date ?? "")"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SearchResultVC") as? SearchResultVC else {
            return
        }
        let mediInfo = checkings[indexPath.row]
        nvc.name = mediInfo.name
        nvc.purpose = ""
        nvc.catuion = mediInfo.caution
        nvc.companyName = ""
        nvc.stateLabel?.isHidden = true
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    

    
}
