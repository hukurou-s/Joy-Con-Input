//
//  main.swift
//  Joy-Con-Driver
//
//  Created by 石井怜央 on 2018/05/29.
//  Copyright © 2018 LEO. All rights reserved.
//

import Foundation
import IOKit.hid

var JoyConR: IOHIDDevice? = nil
//static let target = JoyCon()
//let manager = IOHIDManagerCreate(nil, 0)
let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
let matching = [kIOHIDVendorIDKey: 0x057E, kIOHIDProductIDKey: 0x2007]

IOHIDManagerSetDeviceMatching(manager, matching as CFDictionary?)

IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
let result = IOHIDManagerOpen(manager, 1)

print(result)
