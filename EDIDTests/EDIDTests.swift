//
//  EDIDTests.swift
//  EDIDTests
//
//  Created by Splenden on 2023/11/9.
//

import XCTest

final class EDIDTests: XCTestCase {
    //
    // EDID validation URL: https://hverkuil.home.xs4all.nl/edid-decode/edid-decode.html
    //
    struct MockEDIDs {
        static let DELL_P2415Q = Data([
          0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x10, 0xAC, 0xC0, 0xA0, 0x4C, 0x55, 0x36, 0x30,
          0x2D, 0x18, 0x01, 0x03, 0x80, 0x35, 0x1E, 0x78, 0xEA, 0xE2, 0x45, 0xA8, 0x55, 0x4D, 0xA3, 0x26,
          0x0B, 0x50, 0x54, 0xA5, 0x4B, 0x00, 0x71, 0x4F, 0x81, 0x80, 0xA9, 0xC0, 0xA9, 0x40, 0xD1, 0xC0,
          0xE1, 0x00, 0x01, 0x01, 0x01, 0x01, 0xA3, 0x66, 0x00, 0xA0, 0xF0, 0x70, 0x1F, 0x80, 0x30, 0x20,
          0x35, 0x00, 0x0F, 0x28, 0x21, 0x00, 0x00, 0x1A, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x50, 0x32, 0x50,
          0x43, 0x32, 0x34, 0x42, 0x34, 0x30, 0x36, 0x55, 0x4C, 0x0A, 0x00, 0x00, 0x00, 0xFC, 0x00, 0x44,
          0x45, 0x4C, 0x4C, 0x20, 0x50, 0x32, 0x34, 0x31, 0x35, 0x51, 0x0A, 0x20, 0x00, 0x00, 0x00, 0xFD,
          0x00, 0x1D, 0x4C, 0x1E, 0x8C, 0x1E, 0x00, 0x0A, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x01, 0x96,
          0x02, 0x03, 0x2A, 0xF1, 0x53, 0x90, 0x05, 0x04, 0x02, 0x07, 0x16, 0x01, 0x14, 0x1F, 0x12, 0x13,
          0x27, 0x20, 0x21, 0x22, 0x03, 0x06, 0x11, 0x15, 0x23, 0x09, 0x07, 0x07, 0x6D, 0x03, 0x0C, 0x00,
          0x10, 0x00, 0x30, 0x3C, 0x20, 0x00, 0x60, 0x03, 0x02, 0x01, 0x02, 0x3A, 0x80, 0x18, 0x71, 0x38,
          0x2D, 0x40, 0x58, 0x2C, 0x25, 0x00, 0x0F, 0x28, 0x21, 0x00, 0x00, 0x1F, 0x01, 0x1D, 0x80, 0x18,
          0x71, 0x1C, 0x16, 0x20, 0x58, 0x2C, 0x25, 0x00, 0x0F, 0x28, 0x21, 0x00, 0x00, 0x9E, 0x04, 0x74,
          0x00, 0x30, 0xF2, 0x70, 0x5A, 0x80, 0xB0, 0x58, 0x8A, 0x00, 0x0F, 0x28, 0x21, 0x00, 0x00, 0x1E,
          0x56, 0x5E, 0x00, 0xA0, 0xA0, 0xA0, 0x29, 0x50, 0x30, 0x20, 0x35, 0x00, 0x0F, 0x28, 0x21, 0x00,
          0x00, 0x1A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF9,
        ])
        static let InvalidRGBWColor = [CGPointMake(0.0, 0.0),CGPointMake(0.0, 0.0),CGPointMake(0.0, 0.0),CGPointMake(0.0, 0.0)]
    }
    func testHexConversion() throws {
        let hexes = ["0a1b", "0a 1b", "0x0a1b"]
        let expectResult = Data([0x0a, 0x1b])
        for hexString in hexes {
            let result = EDIDTests.hexStringToData(hexString: hexString)
            XCTAssertEqual(expectResult, result, "\(expectResult) - \(String(describing: result))")
        }
    }
    
    func testDellP2415Q() throws {
        guard let rawEdid = EDID_CTA861(data: [UInt8](MockEDIDs.DELL_P2415Q)) else {
            XCTFail("EDID data parsing failure")
            return
        }
        let edid = ConvenientEDID(edid: rawEdid)
        let color = [
            CGPointMake(0.6591, 0.3339),
            CGPointMake(0.3007, 0.6386),
            CGPointMake(0.1494, 0.0429),
            CGPointMake(0.3134, 0.3291)
        ]
        try testColor(edid, color)
        try testImageSize(edid, 53, 30)
        try testNativeResolution(edid, EDID_CTA861.Resolution(width: 3840, height: 2160, refreshRate: 29.980602))
        try testMaxSize(edid, maxSize: CGSizeMake(3840, 2160))
        try testMiscellaneous(edid, modelName: "DELL P2415Q", edidVersion: (1,3))
    }
    
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}

//MARK: inner test
extension EDIDTests {
    private func testColor(_ edid: ConvenientEDID ,_ predictRGBW: [CGPoint]) throws {
        XCTAssertEqual(edid.redPoint.x, predictRGBW[0].x, accuracy: 0.05)
        XCTAssertEqual(edid.redPoint.y, predictRGBW[0].y, accuracy: 0.05)
        XCTAssertEqual(edid.greenPoint.x, predictRGBW[1].x, accuracy: 0.05)
        XCTAssertEqual(edid.greenPoint.y, predictRGBW[1].y, accuracy: 0.05)
        XCTAssertEqual(edid.bluePoint.x, predictRGBW[2].x, accuracy: 0.05)
        XCTAssertEqual(edid.bluePoint.y, predictRGBW[2].y, accuracy: 0.05)
        XCTAssertEqual(edid.whitePoint.x, predictRGBW[3].x, accuracy: 0.05)
        XCTAssertEqual(edid.whitePoint.y, predictRGBW[3].y, accuracy: 0.05)
    }
    private func testImageSize(_ edid: ConvenientEDID, _ width: Double?, _ height: Double?) throws {
        XCTAssertEqual(edid.screenWidth?.value, width)
        XCTAssertEqual(edid.screenHeight?.value, height)
    }
    private func testNativeResolution(_ edid: ConvenientEDID, _ resolution: EDID_CTA861.Resolution) throws {
        guard let first = edid.preferredResolutions.first else {
            XCTFail("preferredResolutions shouldn't be empty")
            return
        }
        XCTAssertEqual(first.height, resolution.height)
        XCTAssertEqual(first.width, resolution.width)
        XCTAssertEqual(first.refreshRate, resolution.refreshRate, accuracy: 0.05)
    }
    private func testMaxSize(_ edid: ConvenientEDID, maxSize: CGSize) throws {
        XCTAssertEqual(edid.maxWidth, UInt32(maxSize.width))
        XCTAssertEqual(edid.maxHeight, UInt32(maxSize.height))
    }
    private func testMiscellaneous(_ edid: ConvenientEDID, modelName: String, edidVersion:(UInt8, UInt8)) throws {
        XCTAssertEqual(edid.displayName, modelName)
        XCTAssertEqual(edid.edidVersion, edidVersion.0)
        XCTAssertEqual(edid.edidRevision, edidVersion.1)
    }
}

//MARK: Utilities
extension EDIDTests {
    private class func hexStringToData(hexString: String) -> Data? {
        // Trim the hex string to remove spaces and newlines from both ends
        let trimmedHexString = hexString.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
        
        var data = Data(capacity: trimmedHexString.count / 2)

        // If the string starts with '0x', remove it
        var cleanHexString = trimmedHexString
        if cleanHexString.hasPrefix("0x") {
            cleanHexString.removeFirst(2)
        }

        // Ensure the string has an even number of characters
        if cleanHexString.count % 2 != 0 {
            print("The hex string must have an even number of characters")
            return nil
        }

        var index = cleanHexString.startIndex
        while index < cleanHexString.endIndex {
            let nextIndex = cleanHexString.index(index, offsetBy: 2)
            if nextIndex <= cleanHexString.endIndex {
                let byteString = cleanHexString[index..<nextIndex]
                if let byte = UInt8(byteString, radix: 16) {
                    data.append(byte)
                } else {
                    print("Invalid hex string")
                    return nil
                }
                index = nextIndex
            }
        }

        return data
    }
}
