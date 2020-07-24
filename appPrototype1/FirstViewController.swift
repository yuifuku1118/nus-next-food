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
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let shopdatabase = Database()
    var locationManager = CLLocationManager()
    
    var curLongni : Double?
    var curLangni : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //shopdatabase.gerCurrentVersion()
        //shopdatabase.deleteCoreData(name: "Shop")
     
        shopdatabase.set()
        
        shopdatabase.setData()

        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()

           if CLLocationManager.locationServicesEnabled(){
               locationManager.startUpdatingLocation()
           }
    }

 
    @IBAction func mapFindButton(_ sender: UIButton) {
        curLangni = locationManager.location?.coordinate.latitude
        curLongni  =  locationManager.location?.coordinate.longitude
        self.performSegue(withIdentifier: "goToMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToMap"){
            let destinationVC = segue.destination as! MapViewController
            destinationVC.curLang = Float(curLangni ?? 37.11)
            destinationVC.curLong = Float(curLongni ?? 37.11)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        let location = locations.last! as CLLocation

        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print(center.latitude)
    }
    
}

