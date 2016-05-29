/*
 Source: https://gist.github.com/kareman/931017634606b7f7b9c0
*/


import Foundation
import GCDKit

/**
 Inner Queue item
 **/
class _QueueItem<T> {
    let value: T!
    var next: _QueueItem?
    
    init(_ newvalue: T?) {
        self.value = newvalue
    }
}

/**
 Queue
*/
public class Queue<T> {
    
    typealias Element = T
    
    private var _front : _QueueItem<Element>!
    private var _back  : _QueueItem<Element>!
    private var _count : Int
    
    /**
     * This variable is refering to a Grand Central Dispatch Queue.
     * NOT a Queue object (like this class). God naming this is so annoying.
     *
     * [Docs](https://cocoapods.org/?q=lang%3Aswift%20grand%20central)
     */
    let sharedGCD : GCDQueue = .createSerial("queue_update")
    
    
    public init () {
        // Insert dummy item. Will disappear when the first item is added.
        _back = _QueueItem(nil)
        _front = _back
        _count = 0
    }
    
    /// Add a new item to the back of the queue.
    func enqueue (value: Element) {
        _back.next = _QueueItem(value)
        _back = _back.next!
        _count += 1
    }
    
    /// Return and remove the item at the front of the queue.
    func dequeue () -> Element? {
        if let newhead = _front.next {
            _count -= 1
            _front = newhead
            return newhead.value
        } else {
            return nil
        }
    }
    
    func isEmpty() -> Bool {
        return _front === _back
    }
    
    func count() -> Int {
        return _count
    }
}