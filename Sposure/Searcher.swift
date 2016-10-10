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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/* URL Components */
let BASE_URL   = "https://api.giphy.com/"
let SEARCH_URL = "/v1/gifs/search"
let API_KEY    = "dc6zaTOxFJmzC"

class Searcher {
    
    enum ErrorType {
        case mapFailure
        case badStatusCode
        case noGifs
        case noPagination
    }
    
    
    /**
     * Pings the search query to see how large the total count is.
     */
    class func ping(_ query : String, onSuccess : @escaping (Int) -> Void, onError : @escaping (String) -> Void) {
        print("Ping")
        let params = [
            "api_key" : API_KEY,
            "q"       : query,
            "limit"   : String(1)
        ]
        
        Alamofire.request(.GET, BASE_URL+SEARCH_URL, parameters: params).responseObject {
            (response: Response<SearchResponse, NSError>) in
            
            print("Got to success")
            //Fail if didn't map correctly
            guard let searchResponse : SearchResponse = response.result.value
                else { onError("Looks like the internet went kapootz. (Object didn't map to SearchResponse) Whoops."); return }
            
            //Fail if not status == 200
            guard (searchResponse.meta?.status == 200)
                else { onError((searchResponse.meta?.msg)!); return }
            
            //Somehow no pagination?
            guard let count : Int! = searchResponse.pagination!.total_count!
                else {onError("No Paginiation!"); return }
            
            onSuccess(count)
        }
    }
    
    /**
     Sends the Giphy search query
     
     - Parameters:
        - subject     : the subject we are searching for
        - pushToQueue : function that will complete on completion for each gif
        - onError     : function that will complete on error (optional)
      */
    class func search(_ subject : String, request : GiphyRequest, onSuccess : @escaping (Gif)->Void, onError : @escaping (ErrorType, String, GiphyRequest)->Void) {
        
        //Build parameters
        let params = [
            "api_key" : API_KEY,
            "q"       : subject,
            "limit"   : String(request.limit),
            "rating"  : "r",
            "offset"  : String(request.offset)
        ]
        
        //Send request
        Alamofire.request(.GET, BASE_URL+SEARCH_URL, parameters: params).responseObject {
            (response: Response<SearchResponse, NSError>) in
            
            //Fail if didn't map correctly
            guard let searchResponse : SearchResponse = response.result.value
                else { onError(ErrorType.mapFailure, "Looks like the internet went kapootz. (Object didn't map to SearchResponse) Whoops.", request); return }
            
            //Fail if not status == 200
            guard (searchResponse.meta?.status == 200)
                else { onError(ErrorType.badStatusCode,(searchResponse.meta?.msg)!, request); return }
            
            //Fail if there's no gifs!
            guard (searchResponse.gifs?.count > 0)
                else {onError(ErrorType.noGifs, "No gifs!", request); return }
            
            
            /** We got past the guards! But the princess is in another castle :( **/
            
            //Push to queue for each response gif
            for gif in searchResponse.gifs! {
                onSuccess(gif)
            }
        }
    }
    
}

