//
//  GCDQueue.swift
//  GCDKit
//
//  Copyright © 2014 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

private var _GCDQueue_Specific: Void?

/**
A wrapper and utility class for dispatch_queue_t.
*/
@available(iOS, introduced: 7.0)
public enum GCDQueue {
    
    /**
    The serial queue associated with the application’s main thread
    */
    case main
    
    /**
    A system-defined global concurrent queue with a User Interactive quality of service class. On iOS 7, UserInteractive is equivalent to UserInitiated.
    */
    case userInteractive
    
    /**
    A system-defined global concurrent queue with a User Initiated quality of service class. On iOS 7, UserInteractive is equivalent to UserInitiated.
    */
    case userInitiated
    
    /**
    A system-defined global concurrent queue with a Default quality of service class.
    */
    case `default`
    
    /**
    A system-defined global concurrent queue with a Utility quality of service class.
    */
    case utility
    
    /**
    A system-defined global concurrent queue with a Background quality of service class.
    */
    case background
    
    /**
    A user-created custom queue. Use DispatchQueue.createSerial() or DispatchQueue.createConcurrent() to create with an associated dispatch_queue_t object.
    */
    case custom(DispatchQueue)
    
    /**
    Creates a custom queue to which blocks can be submitted serially.
    
    - parameter label: An optional string label to attach to the queue to uniquely identify it in debugging tools such as Instruments, sample, stackshots, and crash reports.
    - returns: A new custom serial queue.
    */
    public static func createSerial(_ label: String? = nil) -> GCDQueue {
        
        return self.createCustom(isConcurrent: false, label: label, targetQueue: nil)
    }
    
    /**
    Creates a custom queue and specifies a target queue to which blocks can be submitted serially.
    
    - parameter label: An optional string label to attach to the queue to uniquely identify it in debugging tools such as Instruments, sample, stackshots, and crash reports.
    - parameter targetQueue: The new target queue for the custom queue.
    - returns: A new custom serial queue.
    */
    public static func createSerial(_ label: String? = nil, targetQueue: GCDQueue) -> GCDQueue {
        
        return self.createCustom(isConcurrent: false, label: label, targetQueue: targetQueue)
    }
    
    /**
    Creates a custom queue to which blocks can be submitted concurrently.
    
    - parameter label: A String label to attach to the queue to uniquely identify it in debugging tools such as Instruments, sample, stackshots, and crash reports.
    - returns: A new custom concurrent queue.
    */
    public static func createConcurrent(_ label: String? = nil) -> GCDQueue {
        
        return self.createCustom(isConcurrent: true, label: label, targetQueue: nil)
    }
    
    /**
    Creates a custom queue and specifies a target queue to which blocks can be submitted concurrently.
    
    - parameter label: An optional string label to attach to the queue to uniquely identify it in debugging tools such as Instruments, sample, stackshots, and crash reports.
    - parameter targetQueue: The new target queue for the custom queue.
    - returns: A new custom concurrent queue.
    */
    public static func createConcurrent(_ label: String? = nil, targetQueue: GCDQueue) -> GCDQueue {
        
        return self.createCustom(isConcurrent: true, label: label, targetQueue: targetQueue)
    }
    
    /**
    Submits a closure for asynchronous execution and returns immediately.
    
    - parameter closure: The closure to submit.
    - returns: The block to submit. Useful when chaining blocks together.
    */
    public func async(_ closure: () -> Void) -> GCDBlock {
        
        return self.async(GCDBlock(closure))
    }
    
    /**
    Submits a block for asynchronous execution and returns immediately.
    
    - parameter block: The block to submit.
    - returns: The block to submit. Useful when chaining blocks together.
    */
    public func async(_ block: GCDBlock) -> GCDBlock {
        
        self.dispatchQueue().async(execute: block.dispatchBlock())
        return block
    }
    
    /**
    Submits a closure for execution and waits until that block completes.
    
    - parameter closure: The closure to submit.
    - returns: The block to submit. Useful when chaining blocks together.
    */
    public func sync(_ closure: () -> Void) -> GCDBlock {
        
        return self.sync(GCDBlock(closure))
    }
    
    /**
    Submits a block object for execution on a dispatch queue and waits until that block completes.
    
    - parameter block: The block to submit.
    - returns: The block to submit. Useful when chaining blocks together.
    */
    public func sync(_ block: GCDBlock) -> GCDBlock {
        
        self.dispatchQueue().sync(execute: block.dispatchBlock())
        return block
    }
    
    /**
    Enqueue a closure for execution after a specified delay.
    
    - parameter delay: The number of seconds delay before executing the closure
    - parameter closure: The block to submit.
    - returns: The block to submit. Useful when chaining blocks together.
    */
    public func after(_ delay: TimeInterval, _ closure: () -> Void) -> GCDBlock {
        
        return self.after(delay, GCDBlock(closure))
    }
    
    /**
    Enqueue a block for execution after a specified delay.
    
    - parameter delay: The number of seconds delay before executing the block
    - parameter block: The block to submit.
    - returns: The block to submit. Useful when chaining blocks together.
    */
    public func after(_ delay: TimeInterval, _ block: GCDBlock) -> GCDBlock {
        
        self.dispatchQueue().asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: block.dispatchBlock())
        return block
    }
    
    /**
    Submits a barrier closure for asynchronous execution and returns immediately.
    
    - parameter closure: The closure to submit.
    - returns: The block to submit. Useful when chaining blocks together.
    */
    public func barrierAsync(_ closure: () -> Void) -> GCDBlock {
        
        return self.barrierAsync(GCDBlock(closure))
    }
    
    /**
    Submits a barrier block for asynchronous execution and returns immediately.
    
    - parameter closure: The block to submit.
    - returns: The block to submit. Useful when chaining blocks together.
    */
    public func barrierAsync(_ block: GCDBlock) -> GCDBlock {
        
        self.dispatchQueue().async(flags: .barrier, execute: block.dispatchBlock())
        return block
    }
    
    /**
    Submits a barrier closure for execution and waits until that block completes.
    
    - parameter closure: The closure to submit.
    - returns: The block to submit. Useful when chaining blocks together.
    */
    public func barrierSync(_ closure: () -> Void) -> GCDBlock {
        
        return self.barrierSync(GCDBlock(closure))
    }
    
    /**
    Submits a barrier block for execution and waits until that block completes.
    
    - parameter closure: The block to submit.
    - returns: The block to submit. Useful when chaining blocks together.
    */
    public func barrierSync(_ block: GCDBlock) -> GCDBlock {
        
        self.dispatchQueue().sync(flags: .barrier, execute: block.dispatchBlock())
        return block
    }
    
    /**
    Submits a closure for multiple invocations.
    
    - parameter iterations: The number of iterations to perform.
    - parameter closure: The closure to submit.
    */
    public func apply<T: UnsignedInteger>(_ iterations: T, _ closure: @escaping (_ iteration: T) -> Void) {
        
        DispatchQueue.concurrentPerform(iterations: numericCast(iterations)) { (iteration) -> Void in
            
            autoreleasepool {
                
                closure(numericCast(iteration))
            }
        }
    }
    
    /**
    Checks if the queue is the current execution context. Global queues other than the main queue are not supported and will always return nil.
    
    - returns: true if the queue is the current execution context, or false if it is not.
    */
    public func isCurrentExecutionContext() -> Bool {
        
        let dispatchQueue = self.dispatchQueue()
        let rawPointer = UnsafeMutableRawPointer(bitPattern: UInt(bitPattern: ObjectIdentifier(dispatchQueue)))
        
        dispatchQueue.setSpecific(key: /*Migrator FIXME: Use a variable of type DispatchSpecificKey*/ _GCDQueue_Specific,
            value: rawPointer)
        
        return DispatchQueue.getSpecific(&_GCDQueue_Specific) == rawPointer
    }
    
    /**
    Returns the dispatch_queue_t object associated with this value.
    
    - returns: The dispatch_queue_t object associated with this value.
    */
    public func dispatchQueue() -> DispatchQueue {
        
        #if USE_FRAMEWORKS
            
            switch self {
                
            case .Main:
                return dispatch_get_main_queue()
                
            case .UserInteractive:
                return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
                
            case .UserInitiated:
                return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
                
            case .Default:
                return dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
                
            case .Utility:
                return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
                
            case .Background:
                return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
                
            case .Custom(let rawObject):
                return rawObject
            }
        #else
            
            switch self {
                
            case .main:
                return DispatchQueue.main
                
            case .userInteractive:
                if #available(iOS 8.0, *) {
                    
                    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
                }
                else {
                    
                    return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
                }
                
            case .userInitiated:
                if #available(iOS 8.0, *) {
                    
                    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
                }
                else {
                    
                    return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
                }
                
            case .default:
                if #available(iOS 8.0, *) {
                    
                    return DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
                }
                else {
                    
                    return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
                }
                
            case .utility:
                if #available(iOS 8.0, *) {
                    
                    return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
                }
                else {
                    
                    return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.low)
                }
                
            case .background:
                if #available(iOS 8.0, *) {
                    
                    return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
                }
                else {
                    
                    return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background)
                }
                
            case .custom(let rawObject):
                return rawObject
            }
        #endif
    }
    
    fileprivate static func createCustom(isConcurrent: Bool, label: String?, targetQueue: GCDQueue?) -> GCDQueue {
        
        let queue = GCDQueue.custom(
            DispatchQueue(
                label: label.flatMap { ($0 as NSString).utf8String } ?? nil,
                attributes: (isConcurrent ? DispatchQueue.Attributes.concurrent : DispatchQueue.Attributes())
            )
        )
        
        if let target = targetQueue {
            
            queue.dispatchQueue().setTarget(queue: target.dispatchQueue())
        }
        return queue
    }
}

public func ==(lhs: GCDQueue, rhs: GCDQueue) -> Bool {
    
    switch (lhs, rhs) {
        
    case (.main, .main):
        return true
        
    case (.userInteractive, .userInteractive):
        return true
        
    case (.userInitiated, .userInitiated):
        return true
        
    case (.default, .default):
        return true
        
    case (.utility, .utility):
        return true
        
    case (.background, .background):
        return true
        
    case (.custom(let lhsRawObject), .custom(let rhsRawObject)):
        return lhsRawObject === rhsRawObject

    case (.userInitiated, .userInteractive), (.userInteractive, .userInitiated):
        #if USE_FRAMEWORKS
            
            return false
        #else
            
            if #available(iOS 8.0, *) {
                
                return false
            }
            return true
        #endif
        
    default:
        return false
    }
}

extension GCDQueue: Equatable { }
