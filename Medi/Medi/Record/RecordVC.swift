//
//  RecordVC.swift
//  Medi
//
//  Created by 이윤진 on 2021/05/25.
//

import UIKit

import FirebaseFirestore
import UserNotifications

class RecordVC: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordTV: UITableView!
    @IBOutlet weak var introLabel: UILabel!
    let db = Firestore.firestore()
    var checkings: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAlert()
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
    
    func setAlert() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge],
                                                                completionHandler: {didAllow,Error in
                                                                    print(didAllow)
                                                                })
        UNUserNotificationCenter.current().delegate = self
       
        
    }
    func setFirebase() {
        db.collection("Patient").addSnapshotListener {(QuerySnapshot, error) in
            self.checkings = []
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let snapshotDocuments = QuerySnapshot?.documents {
                    snapshotDocuments.forEach{ (doc) in
                        let data = doc.data()
                        if let name = data["name"] as? String, let caution = data["caution"] as? String, let date = data["date"] as? String, let purpose = data["purpose"] as? String {
                            self.checkings.append(User(caution: caution, date: date, name: name, purpose: purpose))
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
        nvc.purpose = mediInfo.purpose
        nvc.catuion = mediInfo.caution
        nvc.companyName = ""
        nvc.stateLabel?.isHidden = true
        self.navigationController?.pushViewController(nvc, animated: true)
        
        let content = UNMutableNotificationContent()
        content.title = "의약품 복용 기간 만료"
        content.body = "의약품 복용 기간이 일주일 남았습니다.\n가까운 약국에서 폐기처분해주세요."
        let date = Date(timeIntervalSinceNow: 7*86400)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: date)
        let datecomponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: true)
        let timeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        print("확인핮\(formattedDate),\(mediInfo.date)")
        if formattedDate == mediInfo.date {
            let request = UNNotificationRequest(identifier: "timerdone",content: content,trigger: timeIntervalTrigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    

    
}
extension RecordVC : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
       }
       
       func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
           let settingsViewController = UIViewController()
           settingsViewController.view.backgroundColor = .gray
           self.present(settingsViewController, animated: true, completion: nil)
           
       }
}
