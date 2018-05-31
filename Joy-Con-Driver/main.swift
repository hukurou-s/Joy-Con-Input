//
//  main.swift
//  Joy-Con-Driver
//
//  Created by 石井怜央 on 2018/05/29.
//  Copyright © 2018 LEO. All rights reserved.
//

import Foundation
import IOKit.hid

let manager = IOHIDManagerCreate(kCFAllocatorDefault, 0)
let matching = [kIOHIDVendorIDKey: 0x057E, kIOHIDProductIDKey: 0x2007]

IOHIDManagerSetDeviceMatching(manager, matching as CFDictionary?)

let matchingCallback: IOHIDDeviceCallback = {context, result, sender, device in

    IOHIDDeviceOpen(device, 1)
    IOHIDDeviceScheduleWithRunLoop(device, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)

    let reportCallback : IOHIDReportCallback = { context, result, sender, type, reportId, report, reportLength in
        let data = Data(bytes: report, count: reportLength)
        print(data.map { String(format: "%.2hhx", $0) }.joined())
    }

    let report = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)

    IOHIDDeviceRegisterInputReportCallback(device, report, 4, reportCallback, nil)
}


IOHIDManagerRegisterDeviceMatchingCallback(manager, matchingCallback, nil)

let removeCallback: IOHIDDeviceCallback = {context, result, sender, device in
    // do something
}
IOHIDManagerRegisterDeviceRemovalCallback(manager, removeCallback, nil)

IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
let result = IOHIDManagerOpen(manager, 1)
print(result)

CFRunLoopRun()

IOHIDManagerClose(manager, 0)
IOHIDManagerUnscheduleFromRunLoop(manager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)