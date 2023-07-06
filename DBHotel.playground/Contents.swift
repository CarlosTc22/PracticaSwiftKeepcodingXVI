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
    // Crea un listado para almacenar reservas, es privado pero se puede acceder desde fuera a ver su contenido
    
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
    
    func cancelReservation(with id: Int) throws {
        if let index = reservations.firstIndex(where: { $0.id == id }) {
            reservations.remove(at: index)
        } else {
            throw ReservationError.reservationNotFound
        }
    }
}

// test

func testAddReservation() {
    let hotelReservationManager = HotelReservationManager()
    let goku = Client(name: "Goku", age: 24, height: 175)
    let vegeta = Client(name: "Vegeta", age: 27, height: 175)
    let vegeta2 = Client(name: "Vegeta2", age: 27, height: 175)
    
    do {
        try hotelReservationManager.addReservation(hotelName: "DB Hotel", clients: [goku, vegeta2], duration: 3, breakfast: true)
        assert(hotelReservationManager.reservations.count == 1, "Debe haber 1 reserva")
        
        try hotelReservationManager.addReservation(hotelName: "DB Hotel", clients: [vegeta], duration: 4, breakfast: true)
        assert(hotelReservationManager.reservations.count == 2, "Debe haber 2 reservas")
    } catch {
        assertionFailure("No se esperaba un error al añadir reservas")
    }
    
    do {
        try hotelReservationManager.addReservation(hotelName: "DB Hotel", clients: [goku], duration: 3, breakfast: true)
    } catch ReservationError.clientAlreadyReserved {
        print("Cliente ya reservado, error esperado")
    } catch {
        assertionFailure("Se esperaba un error de tipo 'clientAlreadyReserved'")
    }
}

func testCancelReservation() {
    let hotelReservationManager = HotelReservationManager()
    let goku = Client(name: "Goku", age: 24, height: 175)
    let vegeta = Client(name: "Vegeta", age: 27, height: 175)
    let vegeta2 = Client(name: "Vegeta2", age: 27, height: 175)
    
    do {
        try hotelReservationManager.addReservation(hotelName: "DB Hotel", clients: [goku, vegeta2], duration: 3, breakfast: true)
        try hotelReservationManager.addReservation(hotelName: "DB Hotel", clients: [vegeta], duration: 4, breakfast: true)
        
        try hotelReservationManager.cancelReservation(with: 2)
        assert(hotelReservationManager.reservations.count == 1, "Debe haber 1 reserva después de cancelar")
    } catch {
        assertionFailure("No se esperaba un error al cancelar la reserva")
    }
    
    do {
        try hotelReservationManager.cancelReservation(with: 2)
    } catch ReservationError.reservationNotFound {
        print("Error esperado al cancelar una reserva inexistente")
    } catch {
        assertionFailure("Se esperaba un error de tipo 'reservationNotFound'")
    }
}

func testReservationPrice() {
    let hotelReservationManager = HotelReservationManager()
    let goku = Client(name: "Goku", age: 24, height: 175)
    let vegeta = Client(name: "Vegeta", age: 27, height: 175)
    
    do {
        let reservation1 = try hotelReservationManager.addReservation(hotelName: "DB Hotel", clients: [goku], duration: 3, breakfast: true)
        let reservation2 = try hotelReservationManager.addReservation(hotelName: "DB Hotel", clients: [vegeta], duration: 3, breakfast: true)
        assert(reservation1.price == reservation2.price, "Los precios de las reservas deberían ser iguales")
    } catch {
        assertionFailure("No se esperaba un error al añadir reservas")
    }
}
testAddReservation()
testCancelReservation()
testReservationPrice()
