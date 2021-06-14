//
//  WikiAPIViewController.swift
//  PoseNetDetection
//
//  Created by curry敏 on 2021/5/21.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class WikiAPIViewController: UIViewController {
    
    @IBOutlet var apiActionName: UILabel!
    @IBOutlet var apiActionDescription: UILabel!
    @IBOutlet var apiImage: UIImageView!
    
    var actionName: String?
    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"

    override func viewDidLoad() {
        
        print("\(String(describing: actionName))")
        
        if let name = actionName {
            print("wiki receives \(name)")
            requestInfo(yogaName: name)
        }
    }
    
    func requestInfo (yogaName: String) {
        
        var category: String?
        
        switch yogaName {
        case "tree": category = "Vriksasana"
        case "squat": category = "Squatting position"
        case "lotus": category = "Lotus position"
        default:
            category = "Lotus position"
        }
        print("API send \(String(describing: category))")
        let parameters : [String:String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts|pageimages",
        "exintro" : "",
        "explaintext" : "",
        "titles" : category!,
        "indexpageids": "",
        "redirects" : "1",
        "pithumbsize": "500"
        ]
        
        AF.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value) :
                //print("got the info")
                print(value)
                let yogaJSON: JSON = JSON(value)
                let pageid = yogaJSON["query"]["pageids"][0].stringValue
                let yogaDescription = yogaJSON["query"]["pages"][pageid]["extract"].stringValue
                let yogaImageURL = yogaJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
                
                self.apiActionName.text = category
                self.apiActionDescription.text = yogaDescription
                self.apiImage.sd_setImage(with: URL(string: yogaImageURL))
                
            case .failure(let error) :
                print(error)
            }
        }
    }
    
}
