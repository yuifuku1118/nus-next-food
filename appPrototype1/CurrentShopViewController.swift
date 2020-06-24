//
//  CurrentShopViewController.swift
//  sample1
//
//  Created by 福島雄一朗 on 2020/05/10.
//  Copyright © 2020 福島雄一朗. All rights reserved.
//

import UIKit

class CurrentShopViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var goBackB: UIButton!
    
    // Scroll view for info
    @IBOutlet weak var infoSection: UIScrollView!
    //height init
    var height = 0
    
    let shopdatabase = Database()
        
    var shopName :String?
    var shopID :String?
    var buttonTitle :String?
    
    var thisRating : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentShopRes = shopdatabase.findShop(shopId: shopName!)

        let currentShop = currentShopRes[0]
        
        
        shopNameLabel.text = currentShop.name!
        
        shopID = currentShop.id!
        
        goBackB.setTitle(buttonTitle!, for: .normal)
        
 
        
        //adding image
        let shopimage = UIImageView(frame: CGRect(x: 10, y: 15, width: 350, height: 200))
        shopimage.image = UIImage(data: currentShop.image!)
        self.infoSection.addSubview(shopimage)
        
        
        // add location info
        let locationInfo = UILabel(frame: CGRect(x: 10, y: 225 , width: 350, height: 30))
        locationInfo.text = "Location : " + currentShop.locationKey!
        self.infoSection.addSubview(locationInfo)
        
        //add category info
        let categoryInfo = UILabel(frame: CGRect(x: 10, y: 260 , width: 350, height: 30))
        categoryInfo.text = "Category : " + currentShop.category!
        self.infoSection.addSubview(categoryInfo)
                
        //add category info
        let shopDetail = UILabel(frame: CGRect(x: 10, y: 295 , width: 350, height: 60))
        shopDetail.text = "Detail : " + currentShop.detail!
        shopDetail.numberOfLines = 2;
        self.infoSection.addSubview(shopDetail)
        
        //add the raing
        let _: () = shopdatabase.getRating(keyId: shopName!, completion: {(rate: Double) -> Void in self.loadRating(rating: rate)})
        
        //add the comment
        let commentLabel = UILabel(frame: CGRect(x: 10, y: 390 , width: 350, height: 30))
        commentLabel.text = "Poeples Comments : "
        self.infoSection.addSubview(commentLabel)
        height = 390
       
        let _: () = shopdatabase.getComments(keyId: shopName!, completion: {(list : [String]) -> Void in self.loadComments(comArr: list)})
        
       
        //load the button
        loadSubmitButton(height: 500)
        
        // set the height for info section
        infoSection.contentSize.height = CGFloat(500 + 70)
    }
    
    
    // function to load the rating
    func loadRating(rating : Double){
        let ratingStr =  String(rating)
        let ratingLabel = UILabel(frame: CGRect(x: 10, y: 360 , width: 350, height: 30))
        ratingLabel.text = "Rating : " + ratingStr + "/5.0"
        self.infoSection.addSubview(ratingLabel)
        thisRating = rating
    }
    
    
    // function to load the comments
    func loadComments(comArr : [String]){
        let x = 30
        var contentHeight = 30
        for eachComment in comArr{
            print(eachComment)
            let comments = UILabel(frame: CGRect(x: 10, y: height + x , width: 350, height: 30))
            if (eachComment != ""){
                comments.text = "-" + eachComment
                height += 30
                contentHeight += 30
                self.infoSection.addSubview(comments)
            }
        }
        
    }
    
    
    func loadSubmitButton(height : Int){
        // add rate submit button
        let button = UIButton(frame: CGRect(x: 10, y: height, width: 350, height: 50))
        button.setTitle("Submit a comment and rating for this shop", for: .normal)
        button.titleLabel?.font =  UIFont(name: "System", size: 10)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.infoSection.addSubview(button)
    }

    
    @objc func buttonAction(sender: UIButton!) {
      self.performSegue(withIdentifier: "goToRating", sender: self)
    }


    
    @IBAction func goBackToSerch(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if( segue.identifier == "goToRating"){
            let destinationVC = segue.destination as! RatingViewController
            destinationVC.shopId = shopID
            destinationVC.currentRating = thisRating
        }
        
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
