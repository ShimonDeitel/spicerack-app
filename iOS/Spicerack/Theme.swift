import SwiftUI

/// Unique palette for Spice Rack Index — mood: spice-market red/paprika/turmeric
enum Theme {
    static let accent = Color(hex: "#D1495B")
    static let background = Color(hex: "#241512")
    static let textPrimary = Color(hex: "#FBEDE7")
    static let secondary = Color(hex: "#F2A65A")

    static let titleFont = Font.system(.largeTitle, design: .serif).weight(.bold)
    static let headingFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .default)
}

extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
