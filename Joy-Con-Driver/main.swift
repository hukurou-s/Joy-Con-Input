//
//  main.swift
//  Joy-Con-Driver
//
//  Created by 石井怜央 on 2018/05/29.
//  Copyright © 2018 LEO. All rights reserved.
//

import Foundation
import IOKit.hid

/*func buttonCheck(buttonCode: String) -> JoyConButton {
    var button = JoyConButton.Neutral

    switch buttonCode {
    case "3f010008":
        button = JoyConButton.A
    case "3f040008":
        button = JoyConButton.B
    case "3f020008":
        button = JoyConButton.X
    case "3f080008":
        button = JoyConButton.Y
    case "3f004008":
        button = JoyConButton.R
    case "3f008008":
        button = JoyConButton.ZR
    case "3f000208":
        button = JoyConButton.Plus
    case "3f001008":
        button = JoyConButton.Home
    case "3f200008":
        button = JoyConButton.SR
    case "3f100008":
        button = JoyConButton.SL
    default:
        break // do nothing

    }

    return button

}*/

let manager = IOHIDManagerCreate(kCFAllocatorDefault, 0)
let matching = [kIOHIDVendorIDKey: 0x057E, kIOHIDProductIDKey: 0x2007]

IOHIDManagerSetDeviceMatching(manager, matching as CFDictionary?)

func buttonCheck(buttonCode: String) -> JoyConButton {
    var button = JoyConButton.Neutral

    switch buttonCode {
    case "3f010008":
        button = JoyConButton.A
    case "3f040008":
        button = JoyConButton.B
    case "3f020008":
        button = JoyConButton.X
    case "3f080008":
        button = JoyConButton.Y
    case "3f004008":
        button = JoyConButton.R
    case "3f008008":
        button = JoyConButton.ZR
    case "3f000208":
        button = JoyConButton.Plus
    case "3f001008":
        button = JoyConButton.Home
    case "3f200008":
        button = JoyConButton.SR
    case "3f100008":
        button = JoyConButton.SL
    default:
        break // do nothing

    }

    return button

}

let matchingCallback: IOHIDDeviceCallback = {context, result, sender, device in

    IOHIDDeviceOpen(device, 1)
    IOHIDDeviceScheduleWithRunLoop(device, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)

    let reportCallback : IOHIDReportCallback = { context, result, sender, type, reportId, report, reportLength in
        let data = Data(bytes: report, count: reportLength)
        let buttonCode = String(data.map { String(format: "%.2hhx", $0) }.joined())
        print(buttonCode)

        let button: JoyConButton = buttonCheck(buttonCode)

        print(button)
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