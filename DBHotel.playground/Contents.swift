// Client: nombre, edad, altura (cm)

struct Client {
    let name: String
    let age: Int
    let height: Int
}

// Reservation: ID único, nombre del hotel, lista de clientes, duración (días), precio,opción de desayuno (true/false)

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

class HotelReservationManager {
    // Crea un listado para almacenar reservas
    
    private (set) var reservations: [Reservation] = []
    
    //Crea método para añadir una reserva. Añade una reserva dado estos parámetros: lista de clientes, duración, opción de desayuno. Asigna un ID único (puedes usar un contador por ejemplo), calcula el precio y agrega el nombre del hotel
    
    func addReservation(hotelName: String, clients: [Client], duration: Int, breakfast: Bool) throws -> Reservation {
        let newID = (reservations.last?.id ?? 0) + 1
        let basePrice = 20.0
        
        //Verifica que la reserva sea única por ID y cliente antes de agregarla al listado. En caso de ser incorrecta, lanza o devuelve el error ReservationError correspondiente
        
        for reservation in reservations {
            if reservation.id == newID {
                throw ReservationError.sameID
            }

        for client in reservation.clients {
            for newClient in clients {
                if client.name == newClient.name {
                    throw ReservationError.clientAlreadyReserved
                    }
                }
            }
        }
        
        // Calculo del precio
        
        let clientCount = Double(clients.count)
        let durationDouble = Double(duration)
        let breakfastPrice = breakfast ? 1.25 : 1.0
        let price = clientCount * basePrice * durationDouble * breakfastPrice
        
        // Añade la reserva al listado de reservas
        
        let newReservation = Reservation(id: newID, hotelName: hotelName, clients: clients, duration: duration, price: price, breakfast: breakfast)
        reservations.append(newReservation)
        
        // Devuelve la reserva
        
        return newReservation
    }
}

// test

let hotelReservationManager = HotelReservationManager()
let goku = Client(name: "Goku", age: 24, height: 175)
try hotelReservationManager.addReservation(hotelName: "DB Hotel", clients: [goku], duration: 3, breakfast: true)

print (hotelReservationManager.reservations)
