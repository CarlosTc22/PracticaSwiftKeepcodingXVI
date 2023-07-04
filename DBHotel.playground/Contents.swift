// Client: nombre, edad, altura (cm)

struct Client {
    let name: String
    let age: Int
    let height: Int
}

// Reservation: ID único, nombre del hotel, lista de clientes, duración (días), precio,opción de desayuno (true/false).

struct Reservation {
    let id: Int
    let hotelName: String
    let clients: [Client]
    let duration: Int
    let price: Double
    let breakfast: Bool
}
