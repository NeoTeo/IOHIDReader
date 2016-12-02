//
//  AppDelegate.swift
//  Theora
//
//  Created by Teo Sartori on 02/12/2016.
//  Copyright © 2016 Matteo Sartori. All rights reserved.
//

import Cocoa
import IOKit.hid

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var hidManager: IOHIDManager!
    var hidContext: UnsafeMutableRawPointer!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        hidContext = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        hidManager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
        
        let criterion = [
            kIOHIDDeviceUsagePageKey : kHIDPage_GenericDesktop,
            kIOHIDDeviceUsageKey : kHIDUsage_GD_GamePad
        ]
        
        IOHIDManagerSetDeviceMatching(hidManager, criterion as CFDictionary?)
        
        let hidDeviceWasAdded: IOHIDDeviceCallback = { context, result, sender, device in
            print("device added")
        }
        
        let hidDeviceWasRemoved: IOHIDDeviceCallback = { context, result, sender, device in
            print("device removed")
        }

        let hidDeviceInput: IOHIDReportCallback = { context, result, sender, type, reportId, report, reportLength in
            print("device input \(Date())")
        }
        
        IOHIDManagerRegisterDeviceMatchingCallback(hidManager, hidDeviceWasAdded, hidContext)
        IOHIDManagerRegisterDeviceRemovalCallback(hidManager, hidDeviceWasRemoved, hidContext)
        
        IOHIDManagerRegisterInputReportCallback(hidManager, hidDeviceInput, hidContext)
        ///IOHIDManagerRegisterInputReportCallback(_ manager: IOHIDManager, _ callback: @escaping IOKit.IOHIDReportCallback, _ context: UnsafeMutableRawPointer?)
        IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        
        IOHIDManagerOpen(hidManager, IOOptionBits(kIOHIDOptionsTypeNone))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

//    func hidDeviceWasAdded(context: UnsafeMutablePointer<Void>, result: IOReturn, sender: UnsafeMutablePointer<Void>, device: IOHIDDevice) {
//        print("device was added")
//    }
}
