//
//  SecondViewController.swift
//  sample1
//
//  Created by 福島雄一朗 on 2020/05/09.
//  Copyright © 2020 福島雄一朗. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController{
    
    let shopdatabase = Database()
    
    @IBOutlet weak var shopName: UITextField!
    var categTitle :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopName.delegate = self
    }

    
    // this is when user press one of the category button
     @IBAction func categorySerch(_ sender: UIButton) {
         print(sender.currentTitle!)
        let categ = sender.currentTitle!
        categTitle = sender.currentTitle!
        self.performSegue(withIdentifier: "toGoList", sender: self)
     }
}

//MARK: - UITextFieldDelegate

extension SecondViewController: UITextFieldDelegate{
    //this is whwn user press the serch button
    @IBAction func serchPressed(_ sender: UIButton) {
        shopName.endEditing(true)
    }
    
    //this is when the user press return on the keypad
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shopName.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if( shopName.text != ""){
            return true
        }else{
            shopName.placeholder = "Type somthing pls"
            return false
        }
    }
    
    //this func gets triggered when textFieldShouldReturn is true
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
        print(shopName.text!)
        self.performSegue(withIdentifier: "toGoSerchResult", sender: self)
         shopName.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if( segue.identifier == "toGoList"){
            let destinationVC = segue.destination as! ShopListViewController
            destinationVC.mainLabelText = categTitle
        }else if(segue.identifier == "toGoSerchResult"){
            let destinationVC = segue.destination as! SerchResultViewController
            destinationVC.userInput = shopName.text!
            
        }
    }
}
