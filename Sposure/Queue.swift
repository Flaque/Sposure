/*
 Source: https://gist.github.com/kareman/931017634606b7f7b9c0
*/


import Foundation

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

open class Queue<T> {
    
    typealias Element = T
    
    fileprivate var _front : _QueueItem<Element>
    fileprivate var _back  : _QueueItem<Element>
    fileprivate var _count : Int
    
    public init () {
        // Insert dummy item. Will disappear when the first item is added.
        self._back  = _QueueItem(nil)
        self._front = self._back
        self._count = 0
    }
    
    /// Add a new item to the back of the queue.
    func enqueue (_ value: Element) {
        self._back.next = _QueueItem(value)
        self._back = self._back.next!
        self._count += 1
    }
    
    /// Return and remove the item at the front of the queue.
    func dequeue () -> Element? {
        if let newhead = self._front.next {
            self._count -= 1
            self._front = newhead
            return newhead.value
        } else {
            return nil
        }
    }
    
    ///Do something once the queue is past a "low" point
    func dequeue(_ low : Int, onLow : () -> Void) -> Element? {
        if let newhead = self._front.next {
            self._count -= 1
            self._front = newhead
            
            //Do something
            if (low >= self.count()) { onLow() }
            
            //Return
            return newhead.value
        } else {
            return nil
        }
    }
    
    open func say() {
        print("Pretty picture")
    }
    
    func isEmpty() -> Bool {
        return self._count == 0
    }
    
    func count() -> Int {
        return self._count
    }
}
