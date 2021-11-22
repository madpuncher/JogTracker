struct JogChangeRequest: Encodable {
    let id: Int
    let userId: String
    let distance: Int
    let time: Int
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case id, distance, time, date
        case userId = "user_id"
    }
}
