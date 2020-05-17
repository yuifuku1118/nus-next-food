//
//  SerchResultViewController.swift
//  sample1
//
//  Created by 福島雄一朗 on 2020/05/10.
//  Copyright © 2020 福島雄一朗. All rights reserved.
//

import UIKit

class SerchResultViewController: UIViewController {
    
    let shopdatabase = Database()

    @IBOutlet weak var serchRes: UIScrollView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var backB: UIButton!
    
    var pressedB : String?
    var userInput : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainLabel.text = "Results similar to .."
        + userInput!
        
        self.loadList(shoplist: shopdatabase.findMatch(keyWord: userInput!))
        


        // Do any additional setup after loading the view.
        

    }
    func loadList(shoplist: [Shop]){
        
        print(shoplist)
        var x = 1
        for eachshop in shoplist {
            
            //adding image
            let shopimage = UIImageView(frame: CGRect(x: 20, y: 100 * x, width: 70, height: 50))
            shopimage.image = UIImage(data: eachshop.image!)
            self.serchRes.addSubview(shopimage)
            
            
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
            self.serchRes.addSubview(button)
            x += 1
        }
        
        serchRes.contentSize.height = 1200
        
    }
    
    
    @objc func buttonAction(sender: UIButton!) {
        pressedB = sender.accessibilityLabel
      self.performSegue(withIdentifier: "fromSerchResToCurrent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fromSerchResToCurrent"){
            let destinationVC = segue.destination as! CurrentShopViewController
            destinationVC.shopName = pressedB!
            destinationVC.buttonTitle = "Go back to  serch result"
        }
    }

    @IBAction func goBack(_ sender: Any) {
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
