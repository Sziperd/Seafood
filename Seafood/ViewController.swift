//
//  ViewController.swift
//  Seafood
//
//  Created by Patryk Piwowarczyk on 09/03/2022.
//

import UIKit
import CoreML
import Vision






class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
   
    
    let imagePicker = UIImagePickerController()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        
        
        
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        self.imageView.image = userPickedImage
            
            guard  let ciimage = CIImage(image: userPickedImage) else{
                fatalError()
            }
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError()
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError()
            }
            if let firstResult = results.first{
                
                self.navigationItem.title =  firstResult.identifier
                
               
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        
        do {
        try handler.perform([request])
        }catch {
            print(error)
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
}
    

