//
//  SaveVC.swift
//  Medi
//
//  Created by 이윤진 on 2021/05/26.
//

import UIKit
import FirebaseFirestore

class SaveVC: UIViewController {
    
    @IBOutlet weak var durationDatePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var effectTextField: UITextField! // 효능 설명 부분
    @IBOutlet weak var cautionTextView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    
    var saveDate: String?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationLayout()
        setSaveButton()
    }
    
    @IBAction func setDatePicker(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let datePickerView = sender
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: datePickerView.date)
        let formatDate = formatter.date(from: date)
        let afterDate = calendar.date(byAdding: .month, value: 2, to: formatDate!)
        
        let formattedAfterDate = formatter.string(from: afterDate!)
        saveDate = formattedAfterDate
        print("이게뭐고\(saveDate)")
    }
    
    
}

extension SaveVC {
    func setSaveButton(){
        recordButton.addTarget(self, action: #selector(didTapRecordButton), for: .touchUpInside)
    }
    @objc func didTapRecordButton() {
        
        
        if let medicineName = nameTextField.text, let date = saveDate, let caution = cautionTextView.text, let purpose = effectTextField.text {
            db.collection("Patient").addDocument(data: ["caution": caution,"date":date,"name":medicineName,"purpose":purpose]){ (error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("saved Success!")
                    self.navigationController?.popViewController(animated: true)
            }
        }
    }
        
    }
    
    func setLayout() {
        cautionTextView.delegate = self
        cautionTextView.text = "복용 시 주의사항을 적어주세요."
        cautionTextView.textColor = UIColor.lightGray
        cautionTextView.layer.borderWidth = 1.0
        cautionTextView.layer.cornerRadius = 8.0
        cautionTextView.layer.borderColor = CGColor.init(red: 192, green: 192, blue: 192, alpha: 0.3)
    }
    
    func setNavigationLayout() {
        navigationController?.navigationItem.backBarButtonItem?.title = " "
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
    }
}

extension SaveVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if cautionTextView.textColor == UIColor.lightGray {
            cautionTextView.text = nil
            cautionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if cautionTextView.text.isEmpty {
            textView.text = "복용 시 주의사항을 적어주세요."
            cautionTextView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            cautionTextView.resignFirstResponder()
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        cautionTextView.resignFirstResponder()
        return true
    }
    func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -200 // Move view 150 points upward
        
    }
    
    func keyboardWillHide(_ sender: Notification){
        self.view.frame.origin.y = 0
    }

}
