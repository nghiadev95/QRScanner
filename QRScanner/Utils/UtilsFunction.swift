//
//  UtilsFunction.swift
//  QRScanner
//
//  Created by Nghia Nguyen on 6/17/18.
//  Copyright © 2018 Nghia Nguyen. All rights reserved.
//

import Foundation
import AVFoundation

class UtilsFunction {
    public static func getObjectTypeName(type: AVMetadataObject.ObjectType) -> String {
        let type = type.rawValue.split(separator: ".")
        return String(type.last ?? "Not found")
    }
    
    public static func getListObjectTypeSupported() -> [AVMetadataObject.ObjectType] {
        return [AVMetadataObject.ObjectType.aztec,
                AVMetadataObject.ObjectType.code128,
                AVMetadataObject.ObjectType.code39,
                AVMetadataObject.ObjectType.code39Mod43,
                AVMetadataObject.ObjectType.code93,
                AVMetadataObject.ObjectType.ean13,
                AVMetadataObject.ObjectType.ean8,
                AVMetadataObject.ObjectType.interleaved2of5,
                AVMetadataObject.ObjectType.itf14,
                AVMetadataObject.ObjectType.pdf417,
                AVMetadataObject.ObjectType.qr,
                AVMetadataObject.ObjectType.upce]
    }
}
