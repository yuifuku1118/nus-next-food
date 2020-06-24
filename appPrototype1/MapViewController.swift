
//
//  MapViewController.swift
//  sample1
//
//  Created by 福島雄一朗 on 2020/05/10.
//  Copyright © 2020 福島雄一朗. All rights reserved.
//

import UIKit
 import CoreLocation

class MapViewController: UIViewController {
    
    var curLong : Float?
    var curLang : Float?

   

    
    @IBOutlet weak var scrollV: UIScrollView!
    
    var pressedButton : String = ""
    
    let shopdatabase = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadListBeta(shoplist: shopdatabase.getByCategory())
    }
    
    func loadListBeta(shoplist: [Shop]){
        
        var distanceArr = [Double]()
        let currcoordinate = CLLocation(latitude: CLLocationDegrees(curLang!), longitude: CLLocationDegrees(curLong!))
     
        for x in shoplist{
            let tempLong = x.locLong
            let tempLang = x.locLang
            let tempcoordinate = CLLocation(latitude: CLLocationDegrees(tempLang), longitude: CLLocationDegrees(tempLong))
            let distanceInMeters = currcoordinate.distance(from: tempcoordinate)
            
            distanceArr.append(distanceInMeters)
        }
        
        // use zip to combine the two arrays and sort that based on the first
        let combined = zip(distanceArr, shoplist).sorted {$0.0 < $1.0}
        print(combined) // "[(1.2, 1), (1.5, 3), (2.4, 0), (10.9, 0), (20.0, 2)]"

        // use map to extract the individual arrays
        let sorted1 = combined.map {$0.0}
        let sorted2 = combined.map {$0.1}

        print(sorted1)  // "[1.2, 1.5, 2.4, 10.9, 20.0]"
        print(sorted2)  // "[1, 3, 0, 0, 2]"
            
        var x = 1
        
        var o = 0
        for eachshop in sorted2 {
            
            //add distance label
            let label = UILabel(frame: CGRect(x: 20, y: (110 * x) - 20, width: 200, height: 20))
            label.textAlignment = .left
            let nume = round(sorted1[o])
            label.text = String(nume) + "m"
            self.scrollV.addSubview(label)
            
            //adding image
            let shopimage = UIImageView(frame: CGRect(x: 20, y: 110 * x, width: 70, height: 50))
            shopimage.image = UIImage(data: eachshop.image!)
            self.scrollV.addSubview(shopimage)
            
            // adding button with shop name
            let button = UIButton(frame: CGRect(x: 100, y: 110 * x, width: 250, height: 50))
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
            self.scrollV.addSubview(button)
            x += 1
            o += 1
        }
        scrollV.contentSize.height = 1700
    }
    
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
      pressedButton = sender.accessibilityLabel!
      self.performSegue(withIdentifier: "shopFromMap", sender: self)
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "shopFromMap"){
            let destinationVC = segue.destination as! CurrentShopViewController
            destinationVC.shopName = pressedButton
            destinationVC.buttonTitle = "Go back to  map result"
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
