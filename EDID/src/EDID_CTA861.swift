//
//  EDID_CTA861.swift
//
//
//  Created by Splenden on 2023/10/16.
//

public class EDID_CTA861 : EDID {
    // Define a struct to hold resolution and refresh rate information
    public struct Resolution: CustomStringConvertible, Hashable {
        public var description: String {
            return "\(width)x\(height) @ \(refreshRate)Hz"
        }
        
        public let width: UInt32
        public let height: UInt32
        public let refreshRate: Double
        
        public init(width: UInt32, height: UInt32, refreshRate: Double) {
            self.width = width
            self.height = height
            self.refreshRate = refreshRate
        }
    }
    
    public lazy var vicsResolutions: [EDID_CTA861.Resolution] = {
        guard rawValue.count >= 256 else { return [] }
        let decodedDataAfter128 = rawValue[128...255]
        let vicList = parseVICs(edidData: [UInt8](decodedDataAfter128))
        
        // Map VICs to Resolutions
        var resolutionList: [EDID_CTA861.Resolution] = []
        for vic in vicList {
            if let resolution = resolutionForVIC(vic) {
                resolutionList.append(resolution)
            }
        }
        
        return resolutionList
    }()
    
    // Function to map VIC to a resolution
    // https://en.wikipedia.org/wiki/Extended_Display_Identification_Data EIA/CEA-861 standard resolutions and timings
    private func resolutionForVIC(_ vic: UInt8) -> Resolution? {
        switch vic {
        case 1:
            return Resolution(width: 640, height: 480, refreshRate: 59.94)
        case 2, 3:
            return Resolution(width: 720, height: 480, refreshRate: 59.94)
        case 4:
            return Resolution(width: 1280, height: 720, refreshRate: 60)
        case 5:
            return Resolution(width: 1920, height: 540, refreshRate: 60)
        case 6, 7, 8, 9:
            return Resolution(width: 1440, height: 240, refreshRate: 59.94)
        case 10, 11, 12, 13:
            return Resolution(width: 2880, height: 240, refreshRate: 59.94)
        case 14, 15:
            return Resolution(width: 1440, height: 480, refreshRate: 59.94)
        case 16:
            return Resolution(width: 1920, height: 1080, refreshRate: 60)
        case 17, 18:
            return Resolution(width: 720, height: 576, refreshRate: 50)
        case 19:
            return Resolution(width: 1280, height: 720, refreshRate: 50)
        case 20, 39:
            return Resolution(width: 1920, height: 540, refreshRate: 50)
        case 21, 22, 23, 24:
            return Resolution(width: 1440, height: 288, refreshRate: 50)
        case 25, 26, 27, 28:
            return Resolution(width: 2880, height: 288, refreshRate: 50)
        case 29, 30:
            return Resolution(width: 1440, height: 576, refreshRate: 50)
        case 31:
            return Resolution(width: 1920, height: 1080, refreshRate: 50)
        case 32:
            return Resolution(width: 1920, height: 1080, refreshRate: 24)
        case 33:
            return Resolution(width: 1920, height: 1080, refreshRate: 25)
        case 34:
            return Resolution(width: 1920, height: 1080, refreshRate: 30)
        case 35, 36:
            return Resolution(width: 2880, height: 240, refreshRate: 59.94)
        case 37, 38:
            return Resolution(width: 2880, height: 576, refreshRate: 50)
        case 40:
            return Resolution(width: 1920, height: 540, refreshRate: 100)
        case 41, 70:
            return Resolution(width: 1280, height: 720, refreshRate: 100)
        case 42, 43, 52, 53:
            return Resolution(width: 720, height: 576, refreshRate: 100)
        case 44, 45:
            return Resolution(width: 1440, height: 576, refreshRate: 100)
        case 46:
            return Resolution(width: 1920, height: 540, refreshRate: 120)
        case 47:
            return Resolution(width: 1280, height: 720, refreshRate: 120)
        case 48, 49, 56, 57:
            return Resolution(width: 720, height: 576, refreshRate: 120)
        case 50, 51:
            return Resolution(width: 1440, height: 576, refreshRate: 120)
        case 54, 55:
            return Resolution(width: 1440, height: 288, refreshRate: 200)
        case 58, 59:
            return Resolution(width: 1440, height: 240, refreshRate: 240)
        case 60, 65:
            return Resolution(width: 1280, height: 720, refreshRate: 24)
        case 61, 66:
            return Resolution(width: 1280, height: 720, refreshRate: 25)
        case 62, 67:
            return Resolution(width: 1280, height: 720, refreshRate: 30)
        case 63:
            return Resolution(width: 1920, height: 1080, refreshRate: 120)
        case 64:
            return Resolution(width: 1920, height: 1080, refreshRate: 100)
        case 68:
            return Resolution(width: 1280, height: 720, refreshRate: 50)
        case 69:
            return Resolution(width: 1280, height: 720, refreshRate: 60)
        case 71:
            return Resolution(width: 1280, height: 720, refreshRate: 120)
        case 72:
            return Resolution(width: 1920, height: 1080, refreshRate: 24)
        case 73:
            return Resolution(width: 1920, height: 1080, refreshRate: 25)
        case 74:
            return Resolution(width: 1920, height: 1080, refreshRate: 30)
        case 75:
            return Resolution(width: 1920, height: 1080, refreshRate: 50)
        case 76:
            return Resolution(width: 1920, height: 1080, refreshRate: 60)
        case 77:
            return Resolution(width: 1920, height: 1080, refreshRate: 100)
        case 78:
            return Resolution(width: 1920, height: 1080, refreshRate: 120)
        case 79:
            return Resolution(width: 1680, height: 720, refreshRate: 24)
        case 80:
            return Resolution(width: 1680, height: 720, refreshRate: 25)
        case 81:
            return Resolution(width: 1680, height: 720, refreshRate: 30)
        case 82:
            return Resolution(width: 1680, height: 720, refreshRate: 50)
        case 83:
            return Resolution(width: 1680, height: 720, refreshRate: 60)
        case 84:
            return Resolution(width: 1680, height: 720, refreshRate: 100)
        case 85:
            return Resolution(width: 1680, height: 720, refreshRate: 120)
        case 86:
            return Resolution(width: 2560, height: 1080, refreshRate: 24)
        case 87:
            return Resolution(width: 2560, height: 1080, refreshRate: 25)
        case 88:
            return Resolution(width: 2560, height: 1080, refreshRate: 30)
        case 89:
            return Resolution(width: 2560, height: 1080, refreshRate: 50)
        case 90:
            return Resolution(width: 2560, height: 1080, refreshRate: 60)
        case 91:
            return Resolution(width: 2560, height: 1080, refreshRate: 100)
        case 92:
            return Resolution(width: 2560, height: 1080, refreshRate: 120)
        case 93...95, 103...105:
            return Resolution(width: 3840, height: 2160, refreshRate: [93: 24, 94: 25, 95: 30, 103: 24, 104: 25, 105: 30][vic]!)
        case 96, 97, 106, 107:
            return Resolution(width: 3840, height: 2160, refreshRate: [96: 50, 97: 60, 106: 50, 107: 60][vic]!)
        case 98...102:
            return Resolution(width: 4096, height: 2160, refreshRate: [98: 24, 99: 25, 100: 30, 101: 50, 102: 60][vic]!)
        case 108, 109:
            return Resolution(width: 1280, height: 720, refreshRate: 48)
        case 110:
            return Resolution(width: 1680, height: 720, refreshRate: 48)
        case 111, 112:
            return Resolution(width: 1920, height: 1080, refreshRate: 48)
        case 113:
            return Resolution(width: 2560, height: 1080, refreshRate: 48)
        case 114, 115, 116:
            return Resolution(width: [114: 3840, 115: 4096, 116: 3840][vic]!, height: 2160, refreshRate: 48)
        case 117, 118, 119:
            return Resolution(width: 3840, height: 2160, refreshRate: [117: 100, 118: 120, 119: 100][vic]!)
        case 120:
            return Resolution(width: 3840, height: 2160, refreshRate: 120)
        case 121...127, 193:
            return Resolution(width: 5120, height: 2160, refreshRate: [121: 24, 122: 25, 123: 30, 124: 48, 125: 50, 126: 60, 127: 100, 193: 120][vic]!)
        case 194...199:
            return Resolution(width: 7680, height: 4320, refreshRate: [194: 24, 195: 25, 196: 30, 197: 48, 198: 50, 199: 60][vic]!)
        case 200...201:
            return Resolution(width: 7680, height: 4320, refreshRate: [200: 100, 201: 120][vic]!)
        case 202...209:
            return Resolution(width: 7680, height: 4320, refreshRate: [202: 24, 203: 25, 204: 30, 205: 48, 206: 50, 207: 60, 208: 100, 209: 120][vic]!)
        case 210...217:
            return Resolution(width: 10240, height: 4320, refreshRate: [210: 24, 211: 25, 212: 30, 213: 48, 214: 50, 215: 60, 216: 100, 217: 120][vic]!)
        case 218...219:
            return Resolution(width: 4096, height: 2160, refreshRate: [218: 100, 219: 120][vic]!)
        default:
            return Resolution(width: 1920, height: 1080, refreshRate: 60)
        }
    }
    
    private func parseVICs(edidData: [UInt8]) -> [UInt8] {
        var vicList: [UInt8] = []
        
        // Find the CEA extension block (usually at 128-byte intervals)
        for blockIndex in stride(from: 0, to: edidData.count, by: 128) {
            // Verify if the block is a CEA-861 block
            if edidData[blockIndex] == 0x02 && edidData[blockIndex + 1] == 0x03 {
                // The 4th byte in the CEA block contains the offset where the 18-byte data blocks begin
                let dataBlockOffset = Int(edidData[blockIndex + 2])
                
                for i in stride(from: blockIndex + 4, to: blockIndex + dataBlockOffset, by: 1) {
                    // If it's a Video Data Block (tag code 2)
                    if (edidData[i] >> 5) == 2 {
                        // Length of the video data block
                        let videoDataBlockLength = edidData[i] & 0x1F
                        // Read the VICs
                        for j in 1...videoDataBlockLength {
                            vicList.append(edidData[i + Int(j)])
                        }
                        break
                    }
                }
            }
        }
        return vicList
    }
}
