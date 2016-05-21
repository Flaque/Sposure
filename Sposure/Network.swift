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
    func search(q : String, onSuccess : (SearchResponse)->Void, onError : (String)->Void = NETWORK.logError) {
        
        //Build parameters
        let params = [
            "api_key" : API_KEY,
            "q"       : q
        ]
        
        //Send request
        Alamofire.request(.GET, BASE_URL+SEARCH_URL, parameters: params)
            .responseObject { (response: Response<SearchResponse, NSError>) in
                
            //Fail if didn't map correctly
            guard let searchResponse : SearchResponse = response.result.value
                else { onError("Looks like the internet went kapootz. (Object didn't map to SearchResponse) Whoops."); return }
                
            //Fail if not status = 200
            guard (searchResponse.meta?.status == 200)
                else { onError((searchResponse.meta?.msg)!); return }
                
            //We got past the guards! Free the prisoners!
            onSuccess(searchResponse)
        }
    }
    
    /**
     Utility function that logs errors
    */
    func logError(msg : String) {
        print("NETWORK ERROR: " + msg)
    }
    
    
};