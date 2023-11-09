//
//  main.swift
//  EDID
//
//  Created by Splenden on 2023/11/9.
//

import Foundation

print("Hello, World!")

//Get EDIDs from https://github.com/linuxhw/EDID
//Compare parsing result with https://hverkuil.home.xs4all.nl/edid-decode/edid-decode.html

let AUS2702 = """
00 ff ff ff ff ff ff 00 06 b3 02 27 c4 ba 00 00
01 1f 01 03 80 3c 22 78 2a 26 65 ae 50 45 a0 25
0e 50 54 bf cf 00 81 40 81 80 95 00 71 4f 81 c0
b3 00 01 01 01 01 02 3a 80 18 71 38 2d 40 58 2c
45 00 56 50 21 00 00 1e 3a 7f 80 88 70 38 14 40
18 20 35 00 56 50 21 00 00 1e 00 00 00 fd 00 30
90 1e c8 3c 00 0a 20 20 20 20 20 20 00 00 00 fc
00 56 47 32 37 39 51 4c 31 41 0a 20 20 20 01 1b

02 03 4b f1 50 01 03 04 13 1f 12 02 11 90 0e 0f
1d 1e 3f 60 61 23 09 07 07 83 01 00 00 67 03 0c
00 10 00 38 3c 67 d8 5d c4 01 78 80 03 6d 1a 00
00 02 01 30 90 f0 00 00 00 00 00 e3 05 e2 81 e4
0f 00 c0 00 e6 06 07 01 62 56 1c 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 14
"""

if let data = hexStringToData(hexString: AUS2702), let rawEDID = EDID_CTA861(data: [UInt8](data)) {
    let edid = ConvenientEDID(edid: rawEDID)
    print(edid.redPoint)
    print(edid.greenPoint)
    print(edid.bluePoint)
    print(edid.whitePoint)
    print((edid.screenWidth, edid.screenHeight))
    print(edid.manufacturerId)
    print(edid.productCode)
    print(edid.serialNumber)
    print((edid.edidVersion, edid.edidRevision))
    print(edid.preferredResolutions)
    print((edid.preferredWidth, edid.preferredHeight))
    print((edid.maxWidth, edid.maxHeight))
}



func hexStringToData(hexString: String) -> Data? {
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
