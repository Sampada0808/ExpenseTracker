import Foundation
import UIKit


extension UIFont {
    convenience init(type: FontType, size : FontSizes) {
        self.init(name: type.name, size: size.value)!
    }
    static func style(_ style:FontStyle) -> UIFont{
        return style.font
        
    }
}

enum FontType : String {
    case rubikBold = "Rubik-Bold"
    case rubikLight = "Rubik-Light"
    case rubikMedium = "Rubik-Medium"
    case rubikSemiBold = "Rubik-SemiBold"
}


extension FontType {
    var name : String{
        return self.rawValue
    }
}


enum FontSizes{
    case custom(Double)
    case theme(FontStyle)
}

extension FontSizes {
    var value : Double {
        switch self{
        case .custom(let customSize): return customSize
        case .theme(let size): return size.size
        }
    
    }
}

enum FontStyle {
    case h1
    case h2
    case h3
    case body
    case secondaryText
    case caption
}

extension FontStyle {
    var size : Double {
        switch self{
        case .h1 : return 32
        case .h2: return 26
        case .h3: return 22
        case .body: return 20
        case .secondaryText: return 18
        case .caption: return 14
        }
    }
    private var fontDescription : FontDescription {
        switch self {
        case .h1: FontDescription(font: .rubikBold, size: .theme(.h1), style: .title1)
        case .h2: FontDescription(font: .rubikBold, size: .theme(.h2), style: .largeTitle)
        case .h3: FontDescription(font: .rubikMedium, size: .theme(.h3), style: .headline)
        case .body: FontDescription(font: .rubikSemiBold, size: .theme(.body), style: .body)
        case .secondaryText: FontDescription(font: .rubikMedium, size: .theme(.secondaryText), style: .caption1)
        case .caption: FontDescription(font: .rubikBold, size: .theme(.caption), style: .footnote)
        }
    }
    
    var font : UIFont {
        guard let font = UIFont(name: fontDescription.font.name, size: fontDescription.size.value) else{
            return UIFont.preferredFont(forTextStyle: fontDescription.style)
        }
        let fontMetrics = UIFontMetrics(forTextStyle: fontDescription.style)
        return fontMetrics.scaledFont(for: font)
    }
}

private struct FontDescription {
    let font : FontType
    let size : FontSizes
    let style : UIFont.TextStyle
    
}
