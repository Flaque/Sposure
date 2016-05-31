//
//  GifImageCreator.swift
//  Sposure
//
//  Created by Evan Conrad on 5/22/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import GCDKit

internal let imageSerialQueue : GCDQueue = .createSerial("imageModuleQueueGCD")

class Imager {
    
    
    class func findImage(gif : Gif!, onSuccess : (GifImage)->Void, onError : (String)->Void = NetworkUtility.logError) {
        guard let url : String! = gif.getURL() else { onError("The gif seems to have no URL!"); return }
        
        Alamofire.request(.GET, url!).validate().response {
            (request, response, data, error) in
            
            //Fail if status == 200
            guard (response?.statusCode == 200)
                else { onError("Internet failed when we tried to get the image. Oops. Status code: \(response?.statusCode)"); return }
            
            //Fail if the data can't make the image
            guard let img : UIImage = UIImage(gifData: data!)
                else { onError("Data didn't work to make the image: "); return }
            
            //Woo! We've succeeded! Create the GifImage and continue on!
            let gifImage = GifImage(image: img, gif: gif)
            onSuccess(gifImage)
        }
    }
}