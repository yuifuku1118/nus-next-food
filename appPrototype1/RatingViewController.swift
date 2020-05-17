//
//  RatingViewController.swift
//  appPrototype1
//
//  Created by 福島雄一朗 on 2020/05/16.
//  Copyright © 2020 yuifuku. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    
    let shopDatabase = Database()
    
    var shopId : String?
    var currentRating : Double?
    var NewRating : Double?

    @IBOutlet weak var ratingPicker: UIPickerView!
    @IBOutlet weak var newComment: UITextView!
    
    
    let ratings = ["Very poor - 1",
                   "Not bad - 2",
                   "Good - 3",
                   "very nice - 4",
                   "Awsome! - 5"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ratingPicker.delegate = self
        self.ratingPicker.dataSource = self
    }
    
    @IBAction func submit(_ sender: UIButton) {
        print(ratingPicker.customMirror)
        
        shopDatabase.updateCommnent(keyId: shopId!, newComment: newComment.text)
        shopDatabase.UpdateRating(keyId: shopId!, currentRating: currentRating!, newRating: NewRating!)
        self.dismiss(animated: true, completion: nil)
    }
    
                        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RatingViewController : UITextViewDelegate{
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if( newComment.text != ""){
            return true
        }else{
            //newComment.placeholder = "Type somthing pls"
            return false
        }
    }
    
    
}

extension RatingViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratings.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return ratings[row]
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        NewRating = Double(row + 1)
    }
}
