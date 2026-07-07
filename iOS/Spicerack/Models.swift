import Foundation

struct SpiceEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var purchaseDate: Date
    var shelfLocation: String

    init(id: UUID = UUID(), name: String = "", purchaseDate: Date = Date(), shelfLocation: String = "") {
        self.id = id
        self.name = name
        self.purchaseDate = purchaseDate
        self.shelfLocation = shelfLocation
    }
}
