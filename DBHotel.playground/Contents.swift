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

// ReservationError. Enumerado que implemente Error con tres errores (cases) posibles: se encontró reserva con el mismo ID, se encontró reserva para un cliente y no se encontró reserva

enum ReservationError: Error {
    case sameID
    case clientAlreadyReserved
    case reservationNotFound
}

