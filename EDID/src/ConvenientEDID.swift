//
//  File.swift
//
//
//  Created by Splenden on 2023/10/16.
//

import Foundation

@dynamicMemberLookup
public class ConvenientEDID {
    private let edid: EDID_CTA861
    public init(edid: EDID_CTA861) {
        self.edid = edid
    }
    public subscript<T>(dynamicMember keyPath: KeyPath<EDID_CTA861, T>) -> T {
        return edid[keyPath: keyPath]
    }
    
    //MARK: convenient functions
    public lazy var displayName: String? = { [unowned self] in
        self.displayNameArray.first
    }()
    public lazy var displayNameArray: [String] = { [unowned self] in
        edid.descriptors.reduce(into: [String]()) { (result, descriptor) in
            if case .displayName(let name) = descriptor {
                result.append(name)
            }
        }
    }()
    private class func colorSignificantBitsToPoint(lowerBits: UInt8, higherBitsX: UInt8, higherBitsY: UInt8) -> CGPoint {
        // from https://github.com/jackielwu/edid-read-swift/blob/master/Sources/edid-read-swift/BaseBlock.swift
        // validation tool: https://hverkuil.home.xs4all.nl/edid-decode/edid-decode.html
        let x = Double((UInt16(lowerBits & 0x0C) >> 6) + (UInt16(higherBitsX) << 2)) / 1023.0
        let y = Double((UInt16(lowerBits & 0x0C) >> 6) + (UInt16(higherBitsY) << 2)) / 1023.0
        return CGPoint(x: x, y: y)
    }
    public lazy var redPoint: CGPoint = { [unowned self] in
        return ConvenientEDID.colorSignificantBitsToPoint(lowerBits: edid.redAndGreenLeastSignificantBits, higherBitsX: edid.redXValueMostSignificantBits, higherBitsY: edid.redYValueMostSignificantBits)
    }()
    public lazy var greenPoint: CGPoint = { [unowned self] in
        return ConvenientEDID.colorSignificantBitsToPoint(lowerBits: edid.redAndGreenLeastSignificantBits, higherBitsX: edid.greenXValueMostSignificantBits, higherBitsY: edid.greenYValueMostSignificantBits)
    }()
    public lazy var bluePoint: CGPoint = { [unowned self] in
        return ConvenientEDID.colorSignificantBitsToPoint(lowerBits: edid.blueAndWhiteLeastSignificantBits, higherBitsX: edid.blueXValueMostSignificantBits, higherBitsY: edid.blueYValueMostSignificantBits)
    }()
    public lazy var whitePoint: CGPoint = { [unowned self] in
        return ConvenientEDID.colorSignificantBitsToPoint(lowerBits: edid.blueAndWhiteLeastSignificantBits, higherBitsX: edid.whitePointXValueMostSignificantBits, higherBitsY: edid.whitePointYValueMostSignificantBits)
    }()
    
    public lazy var preferredResolutions: [EDID_CTA861.Resolution] = { [unowned self] in
        edid.descriptors.reduce(into: [EDID_CTA861.Resolution]()) { (result, descriptor) in
            if case .timing(let timingInfo) = descriptor {
                let width = timingInfo.horizontalActive
                let height = timingInfo.verticalActive
                let hTotal = timingInfo.horizontalActive + timingInfo.horizontalBlanking
                let vTotal = timingInfo.verticalActive + timingInfo.verticalBlanking
                
                func roundToNearestTenth(_ value: Double) -> Double {
                    return (value * 10).rounded(.toNearestOrAwayFromZero) / 10
                }
                func customRound(_ value: Double) -> Double {
                    // Calculate the next integer and the difference from it
                    let nextInt = ceil(value)
                    let diff = nextInt - value
                    
                    // Check if the difference is less than 0.05 to decide rounding to the next integer
                    if diff < 0.05 {
                        return nextInt
                    } else {
                        // Otherwise, round to one decimal place
                        return (value * 10).rounded() / 10
                    }
                }
                let freshRate = customRound(Double(timingInfo.pixelClock) / Double(hTotal * vTotal) * 10_000)
                
                result.append(EDID_CTA861.Resolution(width: width, height: height, refreshRate: freshRate))
            }
        }.sorted {
            if $0.width != $1.width {
                return $0.width > $1.width
            }
            if $0.height != $1.height {
                return $0.height > $1.height
            }
            return $0.refreshRate > $1.refreshRate
        }
    }()
    
    public lazy var resolutions: [EDID_CTA861.Resolution] = { [unowned self] in
        return Array(Set(preferredResolutions + self.vicsResolutions))
    }()
    
    public lazy var preferredWidth: UInt32? = { [unowned self] in
        preferredResolutions.first?.width
    }()
    public lazy var preferredHeight: UInt32? = { [unowned self] in
        preferredResolutions.first?.height
    }()
    public lazy var maxWidth: UInt32? = { [unowned self] in
        resolutions.reduce(nil) {
            return max($0 ?? 0, $1.width)
        }
    }()
    public lazy var maxHeight: UInt32? = { [unowned self] in
        resolutions.reduce(nil) {
            return max($0 ?? 0, $1.height)
        }
    }()
}






