//
//  UploadImage.swift
//  Pinterest
//
//  Created by Adrian Alejandro Sandoval Perez on 5/8/19.
//  Copyright © 2019 Adrian Alejandro Sandoval Perez. All rights reserved.
//

import UIKit
import Firebase
import CoreML
import Vision

class UploadImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.addSubview(chooseButton)
        view.addSubview(uploadButton)
        view.addSubview(imageToUpload)
        view.addSubview(pinMessageTextField)
        
        chooseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chooseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 210).isActive = true
        chooseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        chooseButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 160).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        uploadButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
        imageToUpload.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        imageToUpload.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageToUpload.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageToUpload.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        pinMessageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pinMessageTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 250).isActive = true
        pinMessageTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pinMessageTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    let imageToUpload : UIImageView = {
        let imageV = UIImageView()
        imageV.image = #imageLiteral(resourceName: "pig")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    
    lazy var chooseButton : UIButton = {
        let ub = UIButton()
        ub.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        ub.setTitle("Elegir imagen", for: .normal)
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        return ub
    }()
    
    lazy var uploadButton : UIButton = {
        let ub = UIButton()
        ub.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        ub.setTitle("Subir imagen", for: .normal)
        ub.translatesAutoresizingMaskIntoConstraints = false
        ub.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        return ub
    }()
    
    
    let pinMessageTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "mensaje..."
        tf.backgroundColor = .white
        tf.text = ""
        return tf
    }()
    
    
    // -------------- Al presionar el boton --------------------
    @objc func handleButton(_ sender:UIButton){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        /*let datosViewC = datosViewController()
         self.navigationController?.pushViewController(datosViewC, animated: true)*/
    }
    
    
    @objc func uploadImage(){
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("MEMES").child("\(imageName).jpg")
        var UID = "123"//userL?.uid
        
        var metaData = StorageMetadata()
        metaData.customMetadata = [ "user uuid" : UID, "message" : "imagen de prueba", "url" : "1223"] as! [String : String]
        
        if let uploadData = imageToUpload.image?.jpegData(compressionQuality: 305){
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error == nil {
                    print("error al subir imagen, sustituyendo")
                    var imagenSustituto = #imageLiteral(resourceName: "pinterest")
                    imagenesArray.append(imagenSustituto as! UIImage)
                    return
                }
                //print(metadata)
                
                
                var ref = Database.database().reference(fromURL: "https://pinterest-tecmi.firebaseio.com/")
                let values = ["nombre" :imageName, "type": "jpg", "uuid" : UID, "message" : self.pinMessageTextField.text as! String, "url" : "123"]
                let usersRef = ref.child("imagesURLS").child(imageName)
                
                usersRef.updateChildValues(values, withCompletionBlock: { (error, databaseRef:DatabaseReference?) in
                    if  error != nil { print(error) }
                })
                
            })
        }
        
        self.loadPines()
        
    }
    
    
    func run(after seconds: Int, completion: @escaping () -> Void){
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    //================== Cargar datos de BD
    func loadPines() -> Int {
        let URLSRef = Database.database().reference().child("imagesURLS")
        
        //print("++++++probar load aqui")
        URLSRef.observe(DataEventType.value, with: {(snapshot)  in
            if snapshot.childrenCount > 0 {
                //print("aqui ya tenemos el snapshot")
                
                imagenesArray.removeAll()
                urlsList.removeAll()
                messagesArray.removeAll()
                
                for pines in snapshot.children.allObjects as! [DataSnapshot]{
                    let pinObject = pines.value as? [String: AnyObject]
                    var pinName = pinObject?["nombre"] as! String!
                    var pinType = pinObject?["type"] as! String!
                    var currentMessage = pinObject?["message"] as! String!
                    messagesArray.append(currentMessage!)
                    var imageToDownload = pinName! + "." + pinType!
                    //imageToDownload = "A890070B-6C88-4B39-92A9-A84DC26F755D.jpg"
                    urlsList.append(imageToDownload)
                    
                    storageRef = Storage.storage().reference().child("IMAGES/\(imageToDownload)")
                    
                    
                    
                    storageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
                        if let error = error {
                            //print("-------- hubo un error al descargar \(imageToDownload). el error fue \(error)")
                            print("error, sustituyendo imagen")
                            var imagenSustituto = #imageLiteral(resourceName: "pinterest")
                            imagenesArray.append(imagenSustituto as! UIImage)
                        } else {
                            // Data for "images/island.jpg" is returned
                            let image = UIImage(data: data!)
                            imagenesArray.append(image as! UIImage)
                        }
                    }
                    print("nueva imagen: \(imageToDownload) cuenta nueva de urlsList \(urlsList.count)")
                }
                
                
                self.run(after: 3){
                    
                    let layout = PinterestLayout()
                    let collectionViewC = HomeFeedCollectionViewController(collectionViewLayout: layout)
                    self.navigationController?.pushViewController(collectionViewC, animated: true)                }
                
            } else {
                
            }
            
        })
        
        
        
        
        
        return urlsList.count
    }
    
    fileprivate func predirect(cgImage: CGImage) {
        
        guard let model = try? VNCoreMLModel (for: Inceptionv3().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            
            guard let firstObservation = results.first else { return }
            
            
            
            print("predict \(firstObservation.identifier) \(firstObservation.confidence)")
                
        }
                
            try? VNImageRequestHandler ( cgImage: cgImage, options: [:]).perform([request])
    }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            print(editedImage.size)
            selectedImageFromPicker = editedImage
            print(selectedImageFromPicker?.size)
        }
        /*
         else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
         print(originalImage.size)
         }*/
        if let selectedImage = selectedImageFromPicker {
            imageToUpload.image = selectedImage
            if let imagetoPredirect = selectedImage.cgImage {
                predirect(cgImage: imagetoPredirect)
            }
            
        }
        
        print("imagen seleccionada")
        //print(info)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled")
    }
    
    
}
