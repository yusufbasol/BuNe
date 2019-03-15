//
//  ViewController.swift
//  BuNe
//
//  Created by yusufbasol on 28.02.2019.
//  Copyright © 2019 com.yusufbasol. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
   
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var resimAlani: UIImageView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    let resimYakala = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resimYakala.delegate = self
        resimYakala.sourceType = .camera
        resimYakala.allowsEditing = false 
    }
// didfinished yazınca fonk otomatik cikiyor.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let kullaniciResim = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        
            resimAlani.image = kullaniciResim
            
            guard let ciimage = CIImage(image: kullaniciResim) else {
                fatalError("Resim dönüştürülemedi!")
            }
            
            tespitEt(image: ciimage)
        
        }
        resimYakala.dismiss(animated: true, completion: nil)
    }
                        //import Vision -> VNCoreMLModel
    func tespitEt(image: CIImage){
       
        guard let model = try? VNCoreMLModel(for: kerasToCoreML().model) else {
            fatalError("Model yüklenemedi!")
        }
        
        let istek = VNCoreMLRequest(model: model) { (istek, error) in
            guard let sonuclar = istek.results as? [VNClassificationObservation] else {
                fatalError("Modelde bir sıkıntı var!")
            }
            
            print(sonuclar,"")  //konsolda cikti
            let ilk3sonuc = sonuclar.prefix(3)
            print(ilk3sonuc)
            
            let ilkSonuc = sonuclar[0]
            let ikinciSonuc = sonuclar[1]
            let ucuncuSonuc = sonuclar[2]
            
            self.navigationItem.title = "Tahmin"
            self.label.text = "\(ilkSonuc.identifier) %\(ilkSonuc.confidence*100)"
            self.label2.text = "\(ikinciSonuc.identifier) %\(ikinciSonuc.confidence*100)"
            self.label3.text = "\(ucuncuSonuc.identifier) %\(ucuncuSonuc.confidence*100)"
        }
        
        let denetle = VNImageRequestHandler(ciImage: image)
        
        do {
             try denetle.perform([istek])
        }
        catch {
            print(error)
        }
       
    }
    
    @IBAction func kameraBas(_ sender: UIBarButtonItem) {
        present(resimYakala, animated: true, completion: nil)
    }
   
    
}

