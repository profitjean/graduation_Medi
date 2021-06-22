//
//  CameraSearchVC.swift
//  Medi
//
//  Created by 이윤진 on 2021/06/08.
//

import UIKit
import MobileCoreServices
import TesseractOCR
import GPUImage
import FirebaseFirestore

class CameraSearchVC: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    let db = Firestore.firestore()
    var medicines: [Medicine] = []
    

    var searchedName: String?
    
    var resultName: String?
    var resultManu: String?
    var resultCaution: String?
    var resultPurpose: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchButton()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 3.0
        textView.layer.cornerRadius = 8.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        // 1
        let imagePickerActionSheet =
            UIAlertController(title: "약품 촬영 / 약품 사진 업로드",
                              message: nil,
                              preferredStyle: .actionSheet)
        
        // 2
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(
                title: "카메라로 촬영하기",
                style: .default) { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                self.present(imagePicker, animated: true, completion: {
                    print("success")
                })
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        // 3
        let libraryButton = UIAlertAction(
            title: "앨범에서 선택하기",
            style: .default) { (alert) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            self.present(imagePicker, animated: true, completion: {
                print("success")
            })
        }
        imagePickerActionSheet.addAction(libraryButton)
        
        // 4
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        
        // 5
        present(imagePickerActionSheet, animated: true)
        
        
    }
    
    func performImageRecognition(_ image: UIImage) {
        let scaledImage = image.scaledImage(1000) ?? image
        let preprocessedImage = scaledImage.preprocessedImage() ?? scaledImage
        
        if let tesseract = G8Tesseract(language: "eng+kor") {
            //tesseract.engineMode = .tesseractCubeCombined
            tesseract.pageSegmentationMode = .auto
            
            tesseract.image = preprocessedImage
            tesseract.recognize()
            textView.text = tesseract.recognizedText
            searchedName = tesseract.recognizedText
            print("\(tesseract.recognizedText ?? "")")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationLayout()
        
    }
}

extension CameraSearchVC {
    
    func setSearchButton() {
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
    }
    
    @objc func searchButtonClicked() {
        db.collection("Medicine").whereField("name", isEqualTo: "제이레인점안액").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting Documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
                if let snapshotDocuments = QuerySnapshot?.documents {
                    snapshotDocuments.forEach { (doc) in
                        let data = doc.data()
                        if let name = data["name"] as? String, let caution = data["caution"] as? String, let manu = data["manu"] as? String, let purpose = data["purpose"] as? String {
//                            self.medicines.append(Medicine(name: name, purpose: purpose, caution: caution, manu: manu))
                        
                            self.resultName = name
                            self.resultManu = manu
                            self.resultCaution = caution
                            self.resultPurpose = purpose
                            
                        }
                    }
                }
            }
        }
        
        
        guard let nvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SearchResultVC") as? SearchResultVC else {
            return
        }
        
        nvc.name = resultName
        nvc.purpose = resultPurpose
        nvc.catuion = resultCaution
        nvc.companyName = resultManu
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    func setNavigationLayout(){
        navigationController?.navigationItem.backBarButtonItem?.title = " "
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}

// MARK: - UINavigationControllerDelegate
extension CameraSearchVC: UINavigationControllerDelegate {
    
}

// MARK: - UIImagePickerControllerDelegate
extension CameraSearchVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedPhoto =
                info[.originalImage] as? UIImage else {
            dismiss(animated: true)
            return
        }
        dismiss(animated: true) {
            self.performImageRecognition(selectedPhoto)
        }
    }
}

// MARK: - UIImage extension
extension UIImage {
    func scaledImage(_ maxDimension: CGFloat) -> UIImage? {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            scaledSize.height = size.height / size.width * scaledSize.width
        } else {
            scaledSize.width = size.width / size.height * scaledSize.height
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func preprocessedImage() -> UIImage? {
        let stillImageFilter = GPUImageAdaptiveThresholdFilter()
        stillImageFilter.blurRadiusInPixels = 15.0
        let filteredImage = stillImageFilter.image(byFilteringImage: self)
        return filteredImage
    }
}

