import UIKit

extension String {
    
    static func returnFormattedDate(value: Int?) -> String {
        let date = Date(timeIntervalSince1970: Double(value ?? 0))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let localDate = dateFormatter.string(from: date)
        
        return localDate
    }
    
    static func secondsToMinutes(seconds : Int) -> String {
      return String(describing: (seconds % 3600) / 60)
    }
}

extension String {
    
    static let dateFormatter = "dd-MM-yyyy"
}
