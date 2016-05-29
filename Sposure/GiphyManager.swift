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
    
    var offset : Int = 0
    var isSearching : Bool = false
    
    init() {}
    
    /**
     Sends the Giphy search query
     
     pushToQueue : function that will complete on completion for each gif
     onError     : function that will complete on error (optional)
                 : [Default] NETWORK.logError
     **/
    func search(pushToQueue : (Gif)->Void, onError : (String)->Void = GifBuffer.logError) {
        
        //Lock to keep this from happening a million times per second.
        guard (!isSearching) else { return; }
        isSearching = true
        
        //Build parameters
        let params = [
            "api_key" : API_KEY,
            "q"       : "cats",
            "limit"   : "20",
            "rating"  : "r",
            "offset"  : String(offset)
        ]
        
        //Send request
        Alamofire.request(.GET, BASE_URL+SEARCH_URL, parameters: params).responseObject {
            (response: Response<SearchResponse, NSError>) in
            
            self.isSearching = false
            
            //Fail if didn't map correctly
            guard let searchResponse : SearchResponse = response.result.value
                else { onError("Looks like the internet went kapootz. (Object didn't map to SearchResponse) Whoops."); return }
            
            //Fail if not status == 200
            guard (searchResponse.meta?.status == 200)
                else { onError((searchResponse.meta?.msg)!); return }
            
            //Fail if there's no gifs!
            guard (searchResponse.gifs?.count > 0)
                else {onError("No gifs!"); return }
            
            //Make sure we got pagination back
            guard let count : Int! = searchResponse.pagination!.count!
                else {onError("No Paginiation!"); return }
            
            /** We got past the guards! But the princess is in another castle :( **/
            
            //Update offset
            self.offset += count
            
            //Push to queue for each response gif
            for gif in searchResponse.gifs! {
                pushToQueue(gif)
            }
        }
    }
    
}

