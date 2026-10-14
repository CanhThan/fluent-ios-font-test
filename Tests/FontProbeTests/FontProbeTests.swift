import XCTest
import UIKit
import SwiftUI
import CoreText
import FontProbe

final class FontProbeTests: XCTestCase {
    private let sample = "Thương hiệu IKG – Tiếng Việt"

    override class func setUp() {
        super.setUp()
        for name in ["BeVietnamPro-Regular", "BeVietnamPro-SemiBold"] {
            guard let url = Bundle.module.url(forResource: name, withExtension: "ttf", subdirectory: "Fonts") else {
                print("FONTTEST| register \(name): missing in bundle")
                continue
            }
            var error: Unmanaged<CFError>?
            let ok = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            print("FONTTEST| register \(name): \(ok)")
        }
        print("FONTTEST| family faces: \(UIFont.fontNames(forFamilyName: "Be Vietnam Pro"))")
    }

    private func report(_ label: String, _ font: UIFont?) {
        guard let font = font else {
            print("FONTTEST| \(label) | nil")
            return
        }
        let width = (sample as NSString).size(withAttributes: [.font: font]).width
        let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        let weight = (traits?[.weight] as? NSNumber)?.doubleValue ?? .nan
        print("FONTTEST| \(label) | ps=\(font.fontName) | family=\(font.familyName) | size=\(String(format: "%.1f", font.pointSize)) | w=\(String(format: "%.1f", width)) | weightTrait=\(String(format: "%.3f", weight))")
    }

    func testProbe() {
        report("D1 direct SemiBold", UIFont(name: "BeVietnamPro-SemiBold", size: 28))
        report("D2 direct Regular", UIFont(name: "BeVietnamPro-Regular", size: 28))
        report("F1 fluent Regular+semibold", UIFont.fluent(FontInfo(name: "BeVietnamPro-Regular", size: 28, weight: .semibold), shouldScale: false))
        report("F2 fluent SemiBold+semibold", UIFont.fluent(FontInfo(name: "BeVietnamPro-SemiBold", size: 28, weight: .semibold), shouldScale: false))
        report("F3 fluent SemiBold+regular", UIFont.fluent(FontInfo(name: "BeVietnamPro-SemiBold", size: 28), shouldScale: false))
        report("S1 fluent Regular+semibold scaled", UIFont.fluent(FontInfo(name: "BeVietnamPro-Regular", size: 28, weight: .semibold)))

        let infoOverrides: [FluentTheme.TypographyToken: FontInfo] = [
            .title1: FontInfo(name: "BeVietnamPro-Regular", size: 28, weight: .semibold)
        ]
        let commonTheme = FluentTheme(typographyOverrides: infoOverrides)
        report("T1 theme common init", commonTheme.typography(.title1, adjustsForContentSizeCategory: false))

        if let semi = UIFont(name: "BeVietnamPro-SemiBold", size: 28) {
            let uiOverrides: [FluentTheme.TypographyToken: UIFont] = [.title1: semi]
            let uikitTheme = FluentTheme(typographyOverrides: uiOverrides)
            report("T2 theme UIKit init", uikitTheme.typography(.title1, adjustsForContentSizeCategory: false))
        }
        XCTAssertTrue(true)
    }
}