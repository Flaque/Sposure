//
//  Network.swift
//  Sposure
//
//  Created by Evan Conrad on 5/20/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftGifOrigin

//Create a global instance
let NETWORK = Network()

/* URL Components */
let BASE_URL   = "https://api.giphy.com/"
let SEARCH_URL = "/v1/gifs/search"
let API_KEY    = "dc6zaTOxFJmzC"


class Network {
    

    /** 
     Sends the Giphy search query
     
     q : search query term or phrase
     onSuccess : function that will complete on completion
     onError   : function that will complete on error (optional)
               : [Default] NETWORK.logError
    **/
    func search(q : String, onSuccess : (UIImage)->Void, onError : (String)->Void = NETWORK.logError) {
        
        //Build parameters
        let params = [
            "api_key" : API_KEY,
            "q"       : q
        ]
        
        //Send request
        Alamofire.request(.GET, BASE_URL+SEARCH_URL, parameters: params).responseObject {
            (response: Response<SearchResponse, NSError>) in
                
            //Fail if didn't map correctly
            guard let searchResponse : SearchResponse = response.result.value
                else { onError("Looks like the internet went kapootz. (Object didn't map to SearchResponse) Whoops."); return }
                
            //Fail if not status == 200
            guard (searchResponse.meta?.status == 200)
                else { onError((searchResponse.meta?.msg)!); return }
                
            //Fail if there's no gifs!
            guard (searchResponse.gifs?.count > 0)
                else {onError("No gifs!"); return }
                
            //We got past the guards! But the princess is in another castle :(
            //Blaze ahead! Find the Image!
            self.findImage(searchResponse.gifs![0], onSuccess: onSuccess, onError: onError)
        }
    }
    
    /**
     Find the UIImage from the gif's url
     gif : the Gif object
     onSuccess : Same as in search
     onError   : Same as in search
    */
    func findImage(gif : Gif!, onSuccess : (UIImage)->Void, onError : (String)->Void = NETWORK.logError) {
        
        let url : String! = gif.url
        
        Alamofire.request(.GET, url).response {
            (request, response, data, error) in
            
            //Fail if status == 200
            guard (response?.statusCode == 200)
                else { onError("Internet failed when we tried to get the image. Oops."); return }
            
            //Fail if the data can't make the image
            guard let img : UIImage = UIImage.gifWithData(data!)
                else { onError("Data didn't work to make the image: "); return }
            
            //Woo! We've succeeded! Return the image
            onSuccess(img)
        }
    }
    
    /**
     Utility function that logs errors
     msg : String - The error msg
    */
    func logError(msg : String) {
        print("NETWORK ERROR: " + msg)
    }
    
    
};