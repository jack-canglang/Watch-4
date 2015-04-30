//
//  InterfaceController.swift
//  xiaoboaqi WatchKit Extension
//
//  Created by xiaobo on 15/4/23.
//  Copyright (c) 2015年 xiaobo. All rights reserved.
//

import WatchKit
import Foundation

struct CityAQI {
    var city:String
    var aqi:Int
    var level:String
}

func warningInfo(aqi:Int) -> (bgcolor: UIColor,fgcolor: UIColor,suggestion:String) {
    
    switch aqi {
    case 0...50:
        return (UIColor.greenColor(),UIColor.lightGrayColor(),"清新世界太美丽")
    case 51...100:
        return (UIColor.yellowColor(),UIColor.lightGrayColor(),"平淡日子静静流")
    case 101...150:
        return (UIColor.orangeColor(),UIColor.whiteColor(),"愁云惨雾万里凝")
    case 151...200:
        return (UIColor.redColor(),UIColor.whiteColor(),"雾霾来袭兵临城")
    case 201...300:
        return (UIColor.purpleColor(),UIColor.whiteColor(),"魔王压境无明日")
    case 300...999:
        return (UIColor.brownColor(),UIColor.whiteColor(),"天诛地灭人绝迹")

    default:
        return (UIColor.blackColor(),UIColor.whiteColor(),"")
    }
}

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var labelCityBJ: WKInterfaceLabel!

    @IBOutlet weak var labelCitySH: WKInterfaceLabel!
    
    @IBOutlet weak var labelCitySY: WKInterfaceLabel!
    
    @IBOutlet weak var labelCityDL: WKInterfaceLabel!
    
    
    @IBOutlet weak var labelAQIBJ: WKInterfaceLabel!
    
    @IBOutlet weak var labelAQISH: WKInterfaceLabel!
    
    @IBOutlet weak var labelAQISY: WKInterfaceLabel!
    
    @IBOutlet weak var labelAQIDL: WKInterfaceLabel!
    
    
    @IBOutlet weak var labelLvlBJ: WKInterfaceLabel!
    
    @IBOutlet weak var labelLvlSH: WKInterfaceLabel!
    
    @IBOutlet weak var labelLvlSY: WKInterfaceLabel!
    
    @IBOutlet weak var labelLvlDL: WKInterfaceLabel!
    
    
    @IBOutlet weak var labelSugBJ: WKInterfaceLabel!
    
    @IBOutlet weak var labelSugSH: WKInterfaceLabel!
    
    @IBOutlet weak var labelSugSY: WKInterfaceLabel!
    
    @IBOutlet weak var labelSugDL: WKInterfaceLabel!
    
    
    @IBOutlet weak var gpBJ: WKInterfaceGroup!
    
    @IBOutlet weak var gpSH: WKInterfaceGroup!
    
    @IBOutlet weak var gpSY: WKInterfaceGroup!
    
    @IBOutlet weak var gpDL: WKInterfaceGroup!
    

    func getAQI(city:String, completion:(CityAQI?)->()) {
        let baseURL = "http://apistore.baidu.com/microservice/aqi?city="
        
        let session = NSURLSession.sharedSession()
        let requestURL = (baseURL + city).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.dataTaskWithURL(NSURL(string: requestURL!)!, completionHandler: { (data, _, error) -> Void in
            if error == nil {
                if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary {
                    
                    if let retData = json["retData"] as? NSDictionary, aqi = retData["aqi"] as? Int, level = retData["level"] as? String {
                        
                        let cityAQI = CityAQI(city: city, aqi: aqi, level: level)
                        
                        completion(cityAQI)
                        
                    }
                    
                }
            }
        })
        
        task.resume()
        
    }
    
    
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        //如果是北京AQI标签可见的话
        if let bj = labelAQIBJ, levelbj = labelLvlBJ {
            getAQI("北京", completion: { (ca:CityAQI?) -> () in
                if let ca = ca {
                    bj.setText(ca.aqi.description)
                    bj.setTextColor(warningInfo(ca.aqi).fgcolor)
                    
                    levelbj.setText(ca.level)
                    levelbj.setTextColor(warningInfo(ca.aqi).fgcolor)
                    
                    self.gpBJ.setBackgroundColor(warningInfo(ca.aqi).bgcolor)
                    self.labelSugBJ.setText(warningInfo(ca.aqi).suggestion)
                    
                } else {
                    println("没有获取到数据!")
                }
            })
        }
        
        
        //如果是上海AQI标签可见
        if let sh = labelAQISH, levelsh = labelLvlSH {
            getAQI("上海", completion: { (ca:CityAQI?) -> () in
                if let ca = ca {
                    sh.setText(ca.aqi.description)
                    sh.setTextColor(warningInfo(ca.aqi).fgcolor)
                    
                    levelsh.setText(ca.level)
                    levelsh.setTextColor(warningInfo(ca.aqi).fgcolor)
                    
                    self.gpSH.setBackgroundColor(warningInfo(ca.aqi).bgcolor)
                    self.labelSugSH.setText(warningInfo(ca.aqi).suggestion)
                    
                } else {
                    println("没有获取到数据")
                }
            })
        }

        
        //三亚
        if let sy = labelAQISY, levelsy = labelLvlSY {
            getAQI("三亚", completion: { (ca:CityAQI?) -> () in
                if let ca = ca {
                    sy.setText(ca.aqi.description)
                    sy.setTextColor(warningInfo(ca.aqi).fgcolor)
                    
                    levelsy.setText(ca.level)
                    levelsy.setTextColor(warningInfo(ca.aqi).fgcolor)
                    
                    self.gpSY.setBackgroundColor(warningInfo(ca.aqi).bgcolor)
                    self.labelSugSY.setText(warningInfo(ca.aqi).suggestion)
                    
                    
                } else {
                    println("没有获取到数据")
                }
            })
        }

        //大连
        if let dl = labelAQIDL, leveldl = labelLvlDL {
            getAQI("大连", completion: { (ca:CityAQI?) -> () in
                if let ca = ca {
                    dl.setText(ca.aqi.description)
                    dl.setTextColor(warningInfo(ca.aqi).fgcolor)
                    
                    leveldl.setText(ca.level)
                    leveldl.setTextColor(warningInfo(ca.aqi).fgcolor)
                    
                    self.gpDL.setBackgroundColor(warningInfo(ca.aqi).bgcolor)
                    self.labelSugDL.setText(warningInfo(ca.aqi).suggestion)
                    
                } else {
                    println("没有获取到数据")
                }
            })
        }
        
    
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
