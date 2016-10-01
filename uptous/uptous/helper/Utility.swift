//
//  Utility.swift
//  E-Grocery
//
//
//

import UIKit
import CoreLocation

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
} //F.E.

class Weak<T: AnyObject> {
    weak var value : T?
    init (value: T) {
        self.value = value
    }
}

//

let DEFAULT:String! = nil;

enum FontStyle:String {
    case Regular = "Regular", Small = "Small",RegularSmall = "RegularSmall", Normal = "Normal", Medium = "Medium", Large = "Large", LargeV2 = "LargeV2", ExtraLarge = "ExtraLarge",RegularMedium = "RegularMedium",SmallV1 = "SmallV1" ,SmallV2 = "SmallV2",SmallV3 = "SmallV3"
}

enum ColorStyle:String {
    
    case Default = "Default", Clear = "Clear", Black = "Black", White = "White" , Gray = "Gray", GrayV1 = "GrayV1", GrayV2 = "GrayV2", LightGray = "LightGray", BlackT = "BlackT", BlackTL = "BlackTL", BlackTD = "BlackTD", WhiteT = "WhiteT",DarkGreen = "DarkGreen",Red = "Red",OffWhite = "OffWhite",LightRed = "LightRed" , YellowColor = "YellowColor"
    , Blue = "Blue",BlueV1 = "BlueV1",Green = "Green",BlueV2 = "BlueV2",BlueV3 = "BlueV3",
    GrayV3 = "GrayV3", GrayV4 = "GrayV4",GrayV5 = "GrayV5",GrayV6 = "GrayV6",GrayV7 = "GrayV7"
    

}


class Utility: NSObject {
    //Constants
    class var SECOND:Int  {
        get {return 1;}
    } //P.E.
    
    class var MINUTE:Int {
        get {return (60 * SECOND);}
    } //P.E.
    
    class var HOUR:Int {
        get {return (60 * MINUTE);}
    } //P.E.
    
    class var DAY:Int {
        get {return (24 * HOUR);}
    } //P.E.
    
    
    class func sortArray (arr:NSArray , isAscending : Bool , key : String) -> NSArray {
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: key, ascending: isAscending)
        return arr.sortedArrayUsingDescriptors([descriptor])
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
  
    
    class func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    class var MONTH:Int {
        get {return (30 * DAY);}
    } //P.E.
  
    
    class func getDate () -> String {

        let dateFormatter =  NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        return dateFormatter.stringFromDate(NSDate ());
    }
    
    class func convertDateToNSdate (fromdate : String) -> NSDate {
        
        let dateFormatter =  NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        
        //@hassan if else added just to prevent the Crash
        if !fromdate.isEmpty
        {
            return dateFormatter.dateFromString(fromdate)!
            
        }else{
            
            return NSDate();
        }
        
        //return dateFormatter.dateFromString(fromdate)!
        
    }
    
    class func isCharacterExits (str : String,findCharacter : String)-> Bool {

        let characterSet = NSCharacterSet(charactersInString:findCharacter)
        
        if let _ = str.rangeOfCharacterFromSet(characterSet, options: .CaseInsensitiveSearch) {

            return true
        }
        else {

            return false
        }
    }
    
    
    
    class func isEmailAdddressValid(email:String)->Bool {
        let emailRegex:String="[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate:NSPredicate=NSPredicate(format: "SELF MATCHES %@", emailRegex)
  
        return predicate.evaluateWithObject(email)
   } //F.E.
    
    class func validateURL(urlString:String)-> Bool{
    
        let candidateURL:NSURL=NSURL(string: urlString)!
        
        if ((candidateURL.scheme).characters.count > 0 && (candidateURL.host!).characters.count > 0)
        {
            return true
        }
        //--
        return false
    } //F.E.
    
    class func calculateLabelSize(lbl:UILabel, width:CGFloat)-> CGSize {
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: lbl.text!);
        //--
        let range:NSRange = NSRange(location: 0, length: attString.length);
        //--
        attString.addAttribute(NSFontAttributeName, value: lbl.font, range: range);
    
        let rect:CGRect = attString.boundingRectWithSize(CGSize(width: width, height: 3000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return CGSize(width: width, height: rect.size.height);
    } //F.E.
    
    
    
       
    
    class func showAlert(title:String?, message:String?) {
       
        /*let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        //--
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
        //--
        (UIApplication.sharedApplication().delegate as! AppDelegate).window!.rootViewController?.presentViewController(alert, animated: true, completion: nil);*/
        
        let alert:UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK");
        alert.show();
    } //F.E.

    class func formateDate(date:NSDate) ->String?
    {
        //Thu, Jan 29, 2015
        return self.formateDate(date, dateFormat: "eee, MMM dd,  YYYY");
    } //F.E.
    
    
   class func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        
        
        if NSJSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
    }
    
   class func convertStringToDictionary(text: String) -> NSMutableArray? {
    
   
    
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                
               
                
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSMutableArray
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    class func dateFromString(date : NSDate,format:String) ->String
    {
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let datev = dateFormatter.stringFromDate(date)
        
  //      dateFormatter.dateFormat = format
//        let timeStamp = dateFormatter.stringFromDate(datev!)
        return datev
      
    } //F.E.
    
    
    //IT IS RETURNING DATE IN ISO 8601 WITHOUT COMBINING TIME
    class func formateDateInISO(date:NSDate) ->String
    {
        //2015-12-15
        return self.formateDate(date, dateFormat: "YYYY-MM-dd");
    } //F.E.
    
    class func formateDate(date:NSDate, dateFormat:String) ->String
    {
        let formatrer:NSDateFormatter = NSDateFormatter();
        formatrer.dateFormat = dateFormat;
        
        return formatrer.stringFromDate(date);
    } //F.E.
    
    class func dateFromString(str:String, dateFormat:String, timeZone:NSTimeZone? = nil) ->NSDate
    {
        let formatrer:NSDateFormatter = NSDateFormatter();
        formatrer.dateFormat = dateFormat;
        //--
        if (timeZone != nil) {
            formatrer.timeZone = timeZone!;
        }
        
        return formatrer.dateFromString(str) ?? NSDate();
    } //F.E.
   
    //MARK:- Dates Conversion
    class func checkIfDateWithin7Days(date:NSDate) -> Bool
    {
        let delta:NSTimeInterval = timeIntervaleFromCurrentDateToDate(date);
        //--
        return ((delta > 0) && (delta < Double(7 * DAY)));
    } //F.E.
    
    class func timeIntervaleFromCurrentDateToDate(date:NSDate) -> NSTimeInterval
    {
        return date.timeIntervalSinceDate(NSDate());
    } //F.E.
    
    class func getDayNDate(FromDate date:NSDate)->(day:String, date:String){
 
        //--formatter
        let formatter:NSDateFormatter = NSDateFormatter();
        
        //--day format
        formatter.dateFormat = "EEE";
        let rtnDay = formatter.stringFromDate(date);
        
        //--date format
        formatter.dateFormat = "MM/dd";
        let rtnDate = formatter.stringFromDate(date);
        
        return (rtnDay, rtnDate);
    }//F.E
    
    
    class func getDayFromDateDifference(firstStrDate date1:String, secondStrDate date2:String)-> String {
        return self.getDayFromDateDifference(firstDate: self.dateFromString(date1, dateFormat: "YYYY-MM-dd"), secondDate: self.dateFromString(date2, dateFormat: "YYYY-MM-dd"));
    } //F.E.
    
    class func getDayFromDateDifference(firstDate date1:NSDate, secondDate date2:NSDate)-> String
    {
        let days = self.getDaysBetweenDates(date1, endDate: date2)
        var dayStr:String?
       
        switch (days) {
        
        case 0:
            dayStr = "today"
            break;
            
        case -1:
            dayStr = "yesterday"
            break;
            
        case -2:
            dayStr = "day before yesterday"
            break;

        default:
            break;
        }
     
        return dayStr!;
    }//F.E
    
    class func getDaysBetweenDates(startDate:NSDate, endDate:NSDate) -> NSInteger {
        let gregorian: NSCalendar = NSCalendar.currentCalendar();
        let components = gregorian.components(NSCalendarUnit.Day, fromDate: startDate, toDate: endDate, options: [])
        //--
        return components.day
    }
    
    //Mark -Unit Conversion
    class func convertKilometerToMiles(kilometer:Float) -> NSNumber {
        return ceil((kilometer * 0.621371));
    } //F.E.
    class func convertFeetInchToCentimeter(feet:Float, inch:Float) -> Float {
        return ((((feet * 12.0) + inch)) * 2.54);
    } //F.E.
    
    class func convertCentimeterToFeetInch(centimeter:Float) -> (feet:Float, inch:Float) {
        
        var inch:Float = (centimeter / 2.54);
        let feet:Float = ceilf(inch / 12.0);
        //--
        inch = inch % 12;
        
        return (feet,inch);
    } //F.E.
    
    class func convertPoundsToKilogram(pounds:Float) -> Float {
        return round(pounds / 2.20462) ;
    } //F.E.
    
    class func convertKilogramToPounds(kilogram:Float) -> Float {
        return kilogram * 2.20462;
    } //F.E.
    
    //MARK:- Calculate Age
    class func calculateAge (birthday: NSDate) -> NSInteger
    {
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let unitFlags : NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
        let dateComponentNow : NSDateComponents = calendar.components(unitFlags, fromDate: NSDate())
        let dateComponentBirth : NSDateComponents = calendar.components(unitFlags, fromDate: birthday)
        
        if ((dateComponentNow.month < dateComponentBirth.month) ||
            ((dateComponentNow.month == dateComponentBirth.month) && (dateComponentNow.day < dateComponentBirth.day))
            )
        {
            return dateComponentNow.year - dateComponentBirth.year - 1
        }
        else {
            return dateComponentNow.year - dateComponentBirth.year
        }
    }//F.E.
    
    class func getDistanceFromLocation( currentLocation:CLLocation, destinationLocation:CLLocation ) -> CLLocationDistance  {
        let destinationLocation = CLLocation(latitude: destinationLocation.coordinate.latitude, longitude: destinationLocation.coordinate.longitude);
        let kmMeters:CLLocationDistance = currentLocation.distanceFromLocation(destinationLocation) / 1000.0
        return kmMeters
    } //F.E
    
    class func makeImageFromView(view:UIView) -> UIImage {
        var rtnImg:UIImage?
        
        UIGraphicsBeginImageContext(view.frame.size);
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!);
        rtnImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return rtnImg!;
    } //F.E.
   
    
    class func keyIsExist (key : String, dict:NSDictionary )->Bool {
        
        
        if let _ = dict[key] {
        
            return true
        }
        else {
         
           return false
        }
    }
    
   /* class func formatDateWithDateString(strDate:String , formatType:DateFormatType)-> String{
        
        
        let formatter:NSDateFormatter = NSDateFormatter();
        formatter.dateFormat    = "YYYY-MM-dd HH:mm:ss";
        formatter.timeZone      = NSTimeZone(forSecondsFromGMT: 0);
        let date:NSDate         = formatter.dateFromString(strDate as String)!;
        
        return self.formatDateWithDate(date,formatType: formatType);
    }
    
    
    class func formatDateWithDate(date:NSDate,formatType:DateFormatType)-> String{
        let currDate:NSDate = NSDate();
        return self.formatDateWithStartDate(date, endDate: currDate, formatType: formatType);
    }*/
    
    
    
    /*
    
    +(NSString*)timeAgoStringFromData:(NSString*)dateStr{
    
    NSString *str;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-5"]];
    
    
    NSDate *feedDate=[dateFormatter dateFromString:dateStr];
    
    int dateDiff=(int)[self dateDiffrenceFromDate:feedDate second:[NSDate date]];
    if(dateDiff<30)
    {
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:feedDate];
    
    NSInteger hoursBetweenDates = distanceBetweenDates / 3600;
    NSInteger minsBetweenDate=distanceBetweenDates/60;
    
    if(hoursBetweenDates>0)
    str = [self timeAgoString:hoursBetweenDates];
    else if(minsBetweenDate>0)
    str= [NSString stringWithFormat:@"%d min%@ ago",(int)minsBetweenDate,minsBetweenDate>1?@"s":@""];
    else
    str= [NSString stringWithFormat:@"%.0f sec%@ ago",distanceBetweenDates,distanceBetweenDates>1?@"s":@""];
    }
    
    else {
    
    [dateFormatter setDateFormat: dateDiff>365?@"MMM dd YYYY": @"MMM dd"];
    str= [dateFormatter stringFromDate:feedDate];
    
    
    }
    
    return str;
    dateFormatter=nil;
    }
    //F.E.
    +(NSString*)timeAgoString:(NSInteger)numberOfHours{
    
    NSInteger numberOfDays=numberOfHours/24;
    NSString *str;
    if(numberOfDays==0)
    {
    str=[NSString stringWithFormat:@"%d hour%@ ago",(int)numberOfHours,numberOfHours>1?@"s":@""];
    
    }
    else if(numberOfDays==7)
    str=@"a week ago";
    else if((numberOfDays<7 && numberOfDays>0)|| (numberOfDays>7 && numberOfDays<30) )
    
    str=[NSString stringWithFormat:@"%d day%@ ago",(int)numberOfDays,numberOfDays>1?@"s":@""];
    else if(numberOfDays==30 )
    str=@"a month ago";
    
    return str;
    }//F.E
    
    */
    
    //    class func timeAgoString(numberOfHours:NSIntegar)-> String{
    //
    //        let numberOfDays: NSInteger = numberOfHours / 24 ;
    //        var str : String?
    //
    //        if(numberOfDays == 0){
    //
    //            str = String ("\(numberOfHours) hour%@ ago", numberOfHours > 1 ? "s": "");
    //        }
    //        else if (numberOfDays == 7){
    //
    //            str = "a week ago";
    //        }
    //        else if {
    //
    //             str = String ("\(numberOfHours) hour%@ ago", numberOfHours > 1 ? "s": "");
    //
    //        }
    //
    //
    //    }
    
    
  /*  class func formatDateWithStartDate(startDate:NSDate,endDate:NSDate,formatType:DateFormatType)-> String{
        
        let seconds:Int = 1;
        let minute:Int  = 60 * seconds;
        let hour:Int    = 60 * minute;
        let day:Int     = 24 * hour;
        let month:Int   = 30 * day;
        
        /*
        Message
        Today  : 12:37 pm
        more then a day : Tue
        more than a week: 20 Jan
        more than a year: 20/07/2014
        
        
        Chat
        Today: 12:37 PM
        more than a day : Wed 12:37 PM
        more than a week : 20 Jan 12:37 PM
        more than a year : 27/07/2014 12:37 PM
        */
        
        
        let delta:NSTimeInterval = endDate.timeIntervalSinceDate(startDate);
        let formatter:NSDateFormatter = NSDateFormatter();
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.localTimeZone().secondsFromGMT);
        formatter.AMSymbol = "AM";
        formatter.PMSymbol = "PM";
        
        
        if( delta > Double(12 * month) ){
            //more than a year
            formatter.dateFormat = ( formatType == DateFormatType.kDateFormatTypeMessage) ? "dd/MM/YYYY" : "dd/MM/YYYY hh:mm a" ;
        }
        else if( delta > Double(7 * day) ){
            //more than a week
            formatter.dateFormat = ( formatType == DateFormatType.kDateFormatTypeMessage) ? "dd MMM" : "dd MMM hh:mm a" ;
        }
        else if( delta > Double(24 * hour) ){
            //more than a day
            formatter.dateFormat = ( formatType == DateFormatType.kDateFormatTypeMessage) ? "eee" : "eee hh:mm a" ;
        }
        else{
            //today
            formatter.dateFormat = ( formatType == DateFormatType.kDateFormatTypeMessage) ? "hh:mm a" : "hh:mm a" ;
        }
        
        let rtnFormat = formatter.stringFromDate(startDate);
        return  rtnFormat;
    }*/
    
    
    class func convertBytes(bytes:Int64,type:String)->Int64{
        
        var convertedData:Double = 0;
        if( type == "GB"){
            convertedData = (((Double(bytes) / 1024.0) / 1024.0 ) / 1024.0 )
        }else{
            convertedData = ((Double(bytes) / 1024.0) / 1024.0)
        }
        
        return  Int64(ceil(convertedData));
    }

    
    class func differencesIndate (required : String,currentdate : NSDate,fromdate : NSDate) -> NSDateComponents  {
        
        if required == "second" {
              let calender = NSCalendar.currentCalendar()
              let componentSec =  calender.components(NSCalendarUnit.Second, fromDate:fromdate, toDate: currentdate, options: NSCalendarOptions(rawValue:0))
            
            NSLog("componentsecond is\(componentSec.second)")
            
            if componentSec.second <= 0
            {
                print("PROBLEM in DATE")
            }
            
            return componentSec
        }
        
        else if required == "day" {
            
            let calender = NSCalendar.currentCalendar()
            let componentSec =  calender.components(NSCalendarUnit.Day, fromDate:fromdate, toDate: currentdate, options: NSCalendarOptions(rawValue:0))
            
            return componentSec
        }
     
        return NSDateComponents()
    }
    
    //MARK:- Unique Number For Core Data
    
    //###################################################################################//
    //  getUniqueLocalIDForCoreDataObject() This method generates Unique ID for every    //
    //  newly created Core data Object.                                                  //
    //###################################################################################//
    
    static let UNIQUE_ID_FOR_COREDATA_OBJECTS:String = "UNIQUE_ID_FOR_COREDATA_OBJECTS"
    
    class func getUniqueLocalIDForCoreDataObject() -> String{
        
        let ID : String! = NSUserDefaults.standardUserDefaults().objectForKey(UNIQUE_ID_FOR_COREDATA_OBJECTS) as? String

        if ID == nil {
        
            assert(2>10, "getUniqueLocalIDForCoreDataObject ---> generating NIL for CoerData object ID")
        }

           let uniqueVal = Int(ID)! + 1
            NSUserDefaults.standardUserDefaults().removeObjectForKey(UNIQUE_ID_FOR_COREDATA_OBJECTS)
            NSUserDefaults.standardUserDefaults().setObject("\(uniqueVal)", forKey: UNIQUE_ID_FOR_COREDATA_OBJECTS)
            NSUserDefaults.standardUserDefaults().synchronize()
            print("Core Data New Object local_ID == \(uniqueVal)")
            
            return "\(uniqueVal)"
    }
    
    //###################################################################################//
    //  setInitialDefaultValueForLocalIDofCoreDataOBJ() This method Clean the            //
    //  old ID's and Set new base Value for unique ID generation.                        //
    //###################################################################################//
    
    class func setInitialDefaultValueForLocalIDofCoreDataOBJ(){
    
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UNIQUE_ID_FOR_COREDATA_OBJECTS)
        NSUserDefaults.standardUserDefaults().setObject("1200", forKey: UNIQUE_ID_FOR_COREDATA_OBJECTS)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
} //CLS END
