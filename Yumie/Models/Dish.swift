import Foundation


struct Dish: Codable {
    let id: String?
    let name: String?
    let description: String?
    let image: String?
    let calories: Int?
    
    var formattedCalories: String {
        return String(calories ?? 0)+" calories"
    }
    
}
