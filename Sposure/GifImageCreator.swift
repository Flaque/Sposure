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


class GifImageCreator {
    
    /**
     Find the UIImage from the gif's url
     gif : the Gif object
     onSuccess : Same as in search
     onError   : Same as in search
     
     */
    class func findImage(gif : Gif!, onSuccess : (GifImage)->Void, onError : (String)->Void = NETWORK.logError) {
        
        let url : String! = gif.getURL()
        
        Alamofire.request(.GET, url!).response {
            (request, response, data, error) in
            
            //Make sure we've got a response 
            guard (response == nil)
                else { onError("We didn't even get a response back from the server! Oh no! ... Does this help? \(request?.URLString)"); return }
            
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