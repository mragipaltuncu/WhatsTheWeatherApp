//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Mehmet Ragıp Altuncu on 16/01/16.
//  Copyright © 2016 MehmetAltuncu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherForcestLabel: UILabel!
    @IBOutlet weak var getWeatherButton: UIButton!

    

    @IBAction func getWeatherButtonPressed(sender: UIButton) {
        
        var wasSuccesfull = false
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/\(cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-"))/forecasts/latest")
        
        if let url = attemptedUrl {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    let webSiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    if webSiteArray.count > 1 {
                        
                        let weatherArray = webSiteArray[1].componentsSeparatedByString("</span>")
                        
                        if weatherArray.count > 1 {
                            
                            wasSuccesfull = true
                            
                            let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "°")
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.weatherForcestLabel.text = weatherSummary
                            })
                            
                            
                        }//end of weatherArray.count conditinoal
                    }//end of webSiteArray.count conditional
                }//end of urlContent == data conditional
                
                
                if wasSuccesfull == false {
                    
                    self.weatherForcestLabel.text = "Couldn't find weather for that city - Please try another one"
                    
                }
                
            }//end of let = task closure

            
            task.resume()

            
        }else {
            if wasSuccesfull == false {
                
                self.weatherForcestLabel.text = "This is not a proper name for a city - Please try entering a valid city name"
            }
        }//end of url = attemptedUrl conditional
        
        
    }//end of IBAction function

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeatherButton.layer.cornerRadius = 5
        self.cityTextField.delegate = self
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
}//end of class declaration
        







