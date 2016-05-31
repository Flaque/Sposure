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

class Searcher {
    
    
    /**
     * Pings the search query to see how large the total count is.
     */
    class func ping(query : String, onSuccess : (Int) -> Void, onError : (String) -> Void) {
        let params = [
            "api_key" : API_KEY,
            "q"       : query,
            "limit"   : String(1)
        ]
        
        Alamofire.request(.GET, BASE_URL+SEARCH_URL, parameters: params).responseObject {
            (response: Response<SearchResponse, NSError>) in
            
            //Fail if didn't map correctly
            guard let searchResponse : SearchResponse = response.result.value
                else { onError("Looks like the internet went kapootz. (Object didn't map to SearchResponse) Whoops."); return }
            
            //Fail if not status == 200
            guard (searchResponse.meta?.status == 200)
                else { onError((searchResponse.meta?.msg)!); return }
            
            //Somehow no pagination?
            guard let count : Int! = searchResponse.pagination!.count!
                else {onError("No Paginiation!"); return }
            
            onSuccess(searchResponse.pagination!.total_count!)
        }
    }
    
    /**
     Sends the Giphy search query
     
     pushToQueue : function that will complete on completion for each gif
     onError     : function that will complete on error (optional)
                 : [Default] NETWORK.logError
     **/
    class func search(request : GiphyRequest, onSuccess : (Gif)->Void, onError : (String, GiphyRequest)->Void) {
        
        //Build parameters
        let params = [
            "api_key" : API_KEY,
            "q"       : "cats",
            "limit"   : String(request.limit),
            "rating"  : "r",
            "offset"  : String(request.offset)
        ]
        
        //Send request
        Alamofire.request(.GET, BASE_URL+SEARCH_URL, parameters: params).responseObject {
            (response: Response<SearchResponse, NSError>) in
            
            //Fail if didn't map correctly
            guard let searchResponse : SearchResponse = response.result.value
                else { onError("Looks like the internet went kapootz. (Object didn't map to SearchResponse) Whoops.", request); return }
            
            //Fail if not status == 200
            guard (searchResponse.meta?.status == 200)
                else { onError((searchResponse.meta?.msg)!, request); return }
            
            //Fail if there's no gifs!
            guard (searchResponse.gifs?.count > 0)
                else {onError("No gifs!", request); return }
            
            //Make sure we got pagination back
            guard let count : Int! = searchResponse.pagination!.count!
                else {onError("No Paginiation!", request); return }
            
            /** We got past the guards! But the princess is in another castle :( **/
            
            //Push to queue for each response gif
            for gif in searchResponse.gifs! {
                onSuccess(gif)
            }
        }
    }
    
}

