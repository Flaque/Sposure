//
//  GiphyManager.swift
//  Sposure
//
//  Created by Evan Conrad on 5/22/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

/* URL Components */
let BASE_URL   = "https://api.giphy.com/"
let SEARCH_URL = "/v1/gifs/search"
let API_KEY    = "dc6zaTOxFJmzC"

class GiphyManager {
    
    
    /**
     Sends the Giphy search query
     
     pushToQueue : function that will complete on completion for each gif
     onError     : function that will complete on error (optional)
                 : [Default] NETWORK.logError
     **/
    class func search(pushToQueue : (Gif)->Void, onError : (String)->Void = GifBuffer.logError) {
        
        //Build parameters
        let params = [
            "api_key" : API_KEY,
            "q"       : "cats",
            "limit"   : "10",
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
            for gif in searchResponse.gifs! {
                pushToQueue(gif)
            }
        }
    }
    
}

