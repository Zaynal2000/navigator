//
//  Alert.swift
//  JuniorTest
//
//  Created by Зайнал Гереев on 23.08.2021.
//

import UIKit

extension UIViewController {
    
    func alertAdd(title: String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let tfText = alertController.textFields?.first       //не понядл что-за first
            guard let text = tfText?.text else { return }
            completionHandler(text)
            
            
            
        }
        
        alertController.addTextField { (tf) in
            tf.placeholder = placeholder
        }
        
        let alertCancel = UIAlertAction(title: "Отмена", style: .default) { (_) in
        }
        
        alertController.addAction(alertOk)
        alertController.addAction(alertCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
  
    func alertError(title: String, messege: String ){
        let alertController = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(alertOk)
        
        present(alertController, animated: true, completion: nil)
    }  
}
