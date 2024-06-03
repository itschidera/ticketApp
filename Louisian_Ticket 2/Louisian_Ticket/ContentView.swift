import SwiftUI

struct ContentView: View {
    @State private var eventType = ""
    @State private var eventVenue = ""
    @State private var seatingArea = ""
    @State private var ticketQuantity = 1
    @State private var userName = ""
    @State private var phoneNumber = ""
    @State private var couponCode = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    let events = ["Sports", "Concerts", "Theater", "Baseball"]
    let venues = [ "Scotia Bank Arena","Roger's Center", "Enercare Centre"]
    let seatingAreas = ["VIP", "Regular", "Senior"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("User Information")) {
                    TextField("Enter Name", text: $userName)
                    TextField("Enter Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Coupon Code")) {
                    TextField("Enter Coupon Code", text: $couponCode)
                        .keyboardType(.default)
                }
                
                Section(header: Text("Event Details")) {
                    Picker("Event Type", selection: $eventType) {
                        ForEach(events, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Event Venue", selection: $eventVenue) {
                        ForEach(venues, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Seating Area", selection: $seatingArea) {
                        ForEach(seatingAreas, id: \.self) {
                            Text($0)
                        }
                    }
                    Stepper(value: $ticketQuantity, in: 1...10) {
                        Text("Quantity: \(ticketQuantity)")
                    }
                }
                
                Button("PLACE ORDER") {
                    placeOrder()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Order Details"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("Louisian")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            eventSpecial()
                        }) {
                            Text("Event Special")
                        }
                        Button(action: {
                            resetForm()
                        }) {
                            Text("Reset")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                }
            }
        }
    }

    func placeOrder() {
        guard !userName.isEmpty && !phoneNumber.isEmpty else {
            alertMessage = "Please fill User name and phone number."
            showAlert = true
            return
        }
        
        let normalizedCouponCode = couponCode.uppercased()
        
        guard couponCode.isEmpty || normalizedCouponCode.hasPrefix("VENUE") else {
            alertMessage = "Invalid coupon code!"
            couponCode = ""
            showAlert = true
            return
        }
        
        let ticketPrice: Double
        switch seatingArea {
        case "VIP":
            ticketPrice = 250.0
        case "Regular":
            ticketPrice = 150.0
        case "Senior":
            ticketPrice = 50.0
        default:
            ticketPrice = 100.0
        }
        
        let defaultCost = ticketPrice * Double(ticketQuantity)
        let discount = normalizedCouponCode.hasPrefix("VENUE") ? 0.2 : 0.0
        let discountedCost = defaultCost * (1 - discount)
        let tax = discountedCost * 0.13
        let totalCost = discountedCost + tax
        
        alertMessage = """
        Event: \(eventType)
        Venue: \(eventVenue)
        Seating: \(seatingArea)
        Quantity: \(ticketQuantity)
        Total: $\(String(format: "%.2f", totalCost))
        """
        showAlert = true
    }

    func eventSpecial() {
        eventType = "Baseball"
        eventVenue = venues[0]
        seatingArea = seatingAreas[0]
        ticketQuantity = 2
        couponCode = "VENUE1"
    }

    func resetForm() {
        eventType = ""
        eventVenue = ""
        seatingArea = ""
        ticketQuantity = 1
        userName = ""
        phoneNumber = ""
        couponCode = ""
    }
}

#Preview {
    ContentView()
}

