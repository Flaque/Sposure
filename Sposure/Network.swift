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
    func search(q : String, limit : Int, onSuccess : ([GifImage])->Void, onError : (String)->Void = NETWORK.logError) {
        
        //Build parameters
        let params = [
            "api_key" : API_KEY,
            "q"       : q,
            "limit"   : String(limit),
            "rating"  : "r"
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
            self.collect(searchResponse, onSuccess: onSuccess, onError: onError)
        }
    }
    
    /**
     Takes a search Response and collects a bunch of GifImages into an array and returns it
     
     - param searchResponse
     - param onSuccess
     - param onError
    */
    private func collect(searchResponse : SearchResponse, onSuccess : ([GifImage])->Void, onError : (String)->Void = NETWORK.logError) {
        
        let length = searchResponse.gifs!.count
        var count : Int = 0
        var results : [GifImage] = []
        
        func addTo(gifImage : GifImage) -> Void {
            count += 1
            results.append(gifImage)
            
            if (count == length) { onSuccess(results) }
        }
        
        for (_, gif) in searchResponse.gifs!.enumerate() {
            findImage(gif, onSuccess: addTo, onError: onError)
        }
    }
    
    
    /**
     Find the UIImage from the gif's url
     gif : the Gif object
     onSuccess : Same as in search
     onError   : Same as in search
 
    */
    private func findImage(gif : Gif!, onSuccess : (GifImage)->Void, onError : (String)->Void = NETWORK.logError) {
        
        let url : String! = gif.getURL()
        
        Alamofire.request(.GET, url!).response {
            (request, response, data, error) in
            
            //Fail if status == 200
            guard (response?.statusCode == 200)
                else { onError("Internet failed when we tried to get the image. Oops."); return }
            
            //Fail if the data can't make the image
            guard let img : UIImage = UIImage(gifData: data!)
                else { onError("Data didn't work to make the image: "); return }
            
            //Woo! We've succeeded! Create the ImageReturnObject and continue on!
            let gifImage = GifImage(image: img, gif: gif)
            onSuccess(gifImage)
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