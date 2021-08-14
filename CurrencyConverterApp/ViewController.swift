//
//  ViewController.swift
//  CurrencyConverterApp
//
//  Created by Alican Kurt on 14.08.2021.
//

import UIKit



class ViewController: UIViewController {
    @IBOutlet weak var audLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var cadLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrency()
    }

    @IBAction func updateButtonClick(_ sender: Any) {
        getCurrency()
    }
    
    
    func getCurrency(){
        // Processes
        // 1) Request & Session
        // 2) Response & Date
        // 3) Parsing & JSON Serialization
        
        // 1).. if this url is not secure (http) we have to add permission on "Info.plist" -> "App Transport Security Settings"
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=2f26e4ceb2cbd77ecf7bc21d8d9b97da&format=1")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil{
                // ALERT
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else if data != nil{
                // 2) Get JSON Format and Serialization as! Dictionary but this process must be async
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                    // ASYNC Process
                    DispatchQueue.main.async {
                        // 3) Parsing
                        //print(jsonResponse["rates"])
                        if let rates = jsonResponse["rates"] as? [String : Any]{
                            var TRY = 0.0
                            if let TL = rates["TRY"] as? Double{
                                let TLRounded = round(TL*10000) / 10000
                                self.eurLabel.text = "EUR : \(TLRounded) TL"
                                TRY = TL
                            }
                            
                            if var aud = rates["AUD"] as? Double{
                                aud = round(1/aud*TRY * 10000) / 10000
                                self.audLabel.text = "AUD : \(aud) TL"
                            }
                            if var usd = rates["USD"] as? Double{
                                usd = round(1/usd*TRY*10000) / 10000
                                self.usdLabel.text = "USD : \(usd) TL"
                            }
                            if var cad = rates["CAD"] as? Double{
                                cad = round(1/cad*TRY*10000) / 10000
                                self.cadLabel.text = "CAD : \(cad) TL"
                            }
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                } catch  {
                    print("error")
                }
                
                
            }
            
            
            
        }
        // we have to do this
        task.resume()
        
    }
    
}

