//
//  FirstViewController.swift
//  sample1
//
//  Created by 福島雄一朗 on 2020/05/09.
//  Copyright © 2020 福島雄一朗. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseFirestore

class FirstViewController: UIViewController {
    
    
    let shopdatabase = Database()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //shopdatabase.gerCurrentVersion()
        //shopdatabase.deleteCoreData(name: "Shop")
     
        shopdatabase.set()
        
        shopdatabase.setData()

        
        
        // Do any additional setup after loading the view.

    }

 
    @IBAction func mapFindButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToMap", sender: self)
        
    }
    
}

