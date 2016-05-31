//
//  GiphyManager.swift
//  Sposure
//
//  Created by Evan Conrad on 5/29/16.
//  Copyright © 2016 Evan Conrad. All rights reserved.


/**
 * TODO: This loads WAYYYYY more than it needs to and could
 * be HEAVILY optimized.
 * 
 * Currently this loads ALL the gifs URL's available. Like all of them.
 * If Giphy has 50k cat gif URLs, it will load in 50k cat gifs.
 * Granted, it only loads them at 100 per second, but still. 
 *
 * This is going to cause some fairly serious network issues for 
 * folks. This 100% needs to get fixed before this ever hits production.
 */

import Foundation
import GCDKit

class GiphyManager {
    
    private let managerGCD   : GCDQueue      = .createSerial("managerGCD")
    private let requestGCD   : GCDQueue      = .createSerial("requestAccessGCD")
    let responseGCD          : GCDQueue      = .createSerial("responseGCD")
    
    ///These are requests going out
    private let requestQueue : Queue<GiphyRequest> = Queue<GiphyRequest>()
    
    ///These are requests coming in
    let responseQueue : Queue<Gif> = Queue<Gif>()
    
    ///Stops when the request queue is empty.
    private var loading = true
    
    init() {
        
        //Ask how many gifs there are.
        Searcher.ping("cats", onSuccess : setTotalCount, onError : NetworkUtility.logError)
    }
    
    func setTotalCount(total_count : Int) {
        populateQueue(total_count)
        addTasks(total_count)
    }
    
    func addTasks(total_count : Int) {
        while (loading) {
            addTask()
        }
    }
    
    /**
     * Populate the queue before we do anything.
     */
    func populateQueue(total_count : Int) {
        
        let limit = 100
        let runs = Int(ceil(Double(total_count)/Double(limit)))
        print(runs)
        
        for i in 0...runs {
            let request = GiphyRequest(offset: i*limit, limit: limit)
            
            self.requestQueue.enqueue(request)
        }
    }
    
    /**
     * Dequeue a request, then process that request synchronously in a serial queue.
     */
    func addTask() {
        requestGCD.sync() {
            guard (!self.requestQueue.isEmpty()) else { self.onEmpty(); return }
                        let request : GiphyRequest! = self.requestQueue.dequeue()
            self.launchBatch(request)
        }
    }
    
    /**
     * Launches a batch, which will call Alamofire, which launches
     * an async request to do onSuccess.
     */
    func launchBatch(request : GiphyRequest) {
        managerGCD.async() {
            
            //Don't ask for more than 100 per second. Rate limits and stuff (right? I dunno honestly)
            sleep(1)
            Searcher.search(request, onSuccess: self.onSuccess, onError: self.onError)
        }
    }
    
    /**
     * If something failed, add it back to the end of the queue
     * for a retry and then continue on.
     */
    func onError(msg : String, request : GiphyRequest) -> Void {
        
        //Uhhhhhh do something here?
        //The last 30 or so of each one will fail because we asked for 
        //100 and there's only like 70
        print(msg)
    }
    
    /**
     * If something succeeds, add it to the responseQueue.
     */
    func onSuccess(gif : Gif) -> Void {
        
        responseGCD.async() {
            //print("found a: \(gif.getURL())")
            self.responseQueue.enqueue(gif)
        }
    }
    
    
    func onEmpty() {
        //Tell the UI Asyncly what to do if we're empty.
        loading = false
    }
}