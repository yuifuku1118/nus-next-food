//
//  ShopListViewController.swift
//  sample1
//
//  Created by 福島雄一朗 on 2020/05/10.
//  Copyright © 2020 福島雄一朗. All rights reserved.
//

import UIKit

class ShopListViewController: UIViewController {
    
    let shopdatabase = Database()
    
    var pressedButton : String?
    var mainLabelText : String?
    var spesificShopName : String?
    
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var srrollV: UIScrollView!
    
    var arrayB: [UIButton] = [UIButton]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainLabel.text = ""
        print(mainLabelText!)
        
        self.loadListBeta(shoplist: shopdatabase.getByCategory(categ: mainLabelText!))

    }
    
    
    func loadListBeta(shoplist: [Shop]){
        
        
        mainLabel.text = mainLabelText
        print(shoplist)
        var x = 1
        for eachshop in shoplist {
            
            //adding image
            let shopimage = UIImageView(frame: CGRect(x: 20, y: 100 * x, width: 70, height: 50))
            shopimage.image = UIImage(data: eachshop.image!)
            self.srrollV.addSubview(shopimage)
            
            // adding button with shop name
            let button = UIButton(frame: CGRect(x: 100, y: 100 * x, width: 250, height: 50))
            let nameOfShop = eachshop.name!
            let locationKey = eachshop.locationKey!
            let shopId = eachshop.id!
            let title = nameOfShop + "@" + locationKey
            button.setTitle(title, for: .normal)
            button.titleLabel?.font =  UIFont(name: "System", size: 10)
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.accessibilityLabel = shopId
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            self.srrollV.addSubview(button)
            x += 1
        }
        
        srrollV.contentSize.height = 1200
        
    }

    
    @IBAction func goBackToSerch(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
        pressedButton = sender.accessibilityLabel
      self.performSegue(withIdentifier: "fromCategoryToCurrent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fromCategoryToCurrent"){
            let destinationVC = segue.destination as! CurrentShopViewController
            destinationVC.shopName = pressedButton
            destinationVC.buttonTitle = "Go back to category serch"
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
