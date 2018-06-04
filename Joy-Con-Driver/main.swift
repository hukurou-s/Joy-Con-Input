//
//  main.swift
//  Joy-Con-Driver
//
//  Created by 石井怜央 on 2018/05/29.
//  Copyright © 2018 LEO. All rights reserved.
//

import Foundation
import IOKit.hid

func buttonCheck(buttonCode: Int32) -> JoyConButton {
    var button = JoyConButton.Neutral

    switch buttonCode {
    case JoyConButton.A.rawValue:
        button = JoyConButton.A
        print("A")
    case JoyConButton.B.rawValue:
        button = JoyConButton.B
        print("B")
    case JoyConButton.X.rawValue:
        button = JoyConButton.X
        print("X")
    case JoyConButton.Y.rawValue:
        button = JoyConButton.Y
        print("Y")
    case JoyConButton.R.rawValue:
        button = JoyConButton.R
        print("R")
    case JoyConButton.ZR.rawValue:
        button = JoyConButton.ZR
        print("ZR")
    case JoyConButton.Plus.rawValue:
        button = JoyConButton.Plus
        print("Plus")
    case JoyConButton.Home.rawValue:
        button = JoyConButton.Home
        print("Home")
    case JoyConButton.SR.rawValue:
        button = JoyConButton.SR
        print("SR")
    case JoyConButton.SL.rawValue:
        button = JoyConButton.SL
        print("SL")
    default:
        break // do nothing

    }

    return button

}

let manager = IOHIDManagerCreate(kCFAllocatorDefault, 0)
let matching = [kIOHIDVendorIDKey: 0x057E, kIOHIDProductIDKey: 0x2007]
let neutralState : Int32 = 1056964616
var beforeCode = neutralState
var nowCode = neutralState

IOHIDManagerSetDeviceMatching(manager, matching as CFDictionary?)

let matchingCallback: IOHIDDeviceCallback = {context, result, sender, device in

    IOHIDDeviceOpen(device, 1)
    IOHIDDeviceScheduleWithRunLoop(device, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)

    let reportCallback : IOHIDReportCallback = { context, result, sender, type, reportId, report, reportLength in
        beforeCode = nowCode
        let data = Data(bytes: report, count: reportLength)
        nowCode = Int32(bigEndian: data.withUnsafeBytes { $0.pointee })
        let difference = nowCode - beforeCode
        buttonCheck(buttonCode: difference)
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