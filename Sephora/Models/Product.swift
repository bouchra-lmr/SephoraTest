import Foundation

struct Product: Codable {
    let productID: Int
    let productName: String
    let description: String
    let price: Double
    let isSpecialBrand: Bool
    let imageURL: ImageURL
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productName = "product_name"
        case description
        case price
        case isSpecialBrand = "is_special_brand"
        case imageURL = "images_url"
    }
}

struct ImageURL: Codable {
    let small: String
    let large: String
}
