//
//  ConfirmBookingRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 13/03/24.
//

import Foundation
struct ConfirmBookingRequestModel{
  var meetingId: Int = 0
  var meetingRoom: String = ""
  var sittingConfig: [ConfigurationDetails] = []
  var roomprice:String = ""
  var location : String = ""
  var date: String = ""
  var displayStartTime: String = ""
  var displayendTime: String = ""
  var startTime:String = ""
  var endTime: String = ""
  var teamMembers: [TeamMembersList] = []
  var guest: [String] = []
  var amenityArray: [Amenity] = []
    var freeamenityArray: [AmenityFree] = []
  var deskList: [Desk] = []
    var noOfSeats :Int = 0
    var totalHrs:Int = 0
    var officeBookingId: Int = 0
    var amenityTotalHours:[Int : Int] = [:]
    var mainPrice : Mainprice?
    var weekDay : Weekday?
    var weekEnd : Weekend?
    var surcharge:Surcharge?
    //order Details Values
    var orderDetailsOfMeetingRoom : [Total] = []
    var orderDetailsOfMeetingRoomwithAll : RoomBookingOrderDetails?
    
    var orderDetailsOfOffice : [TotalOfficeOrderDetails] = []
    var orderDetailsfOfficewithAll: OfficeBookingOrderDetails?
   
    var finalTotalOfMeetingRoom:String = ""
    
    //computed property
  var floatPrice : Float {
    let price =  Float(self.roomprice) ?? 0.0
    return price
  }
  
  var timeDifferece: Float {
      get {
          let formatter = DateFormatter()
          formatter.dateFormat = "HH:mm"
          if let startTimeDate = formatter.date(from: self.startTime),
             let endTimeDate = formatter.date(from: self.endTime) {
              let calendar = Calendar.current
              let components = calendar.dateComponents([.hour], from: startTimeDate, to: endTimeDate)
              
              if let differenceInHours = components.hour {
                  // Ensure the difference is at least 1 hour or more
                  return max(Float(differenceInHours), 1.0)
              }
          }
          return 1.0 // Default to 1 if there's an issue
      }
      set {
          // The setter is not used in this example. You can implement it if needed.
      }
  }

  // calculation of amenity with price * amenity hours
    var totalOfAmenity: Float {
        var totalAmenityPrice: Float = 0.0
        // Check if the amenity has selected hours in the amenityTotalHours dictionary

        for amenity in amenityArray {
            let amenityPrice = Float(amenity.price ?? "0.0") ?? 0.0
            if let selectedHours = amenityTotalHours[amenity.id] {
                totalAmenityPrice += (amenityPrice * Float(selectedHours))
            }
        }
        
        return totalAmenityPrice
    }
    
    
  var totalOfMeetingRoom: Float {
    let price = self.floatPrice
    let timeDifference = self.timeDifferece
    return price * timeDifference
  }
  var subTotal : Float{
    let total1 = self.totalOfMeetingRoom
    let total2 = self.totalOfAmenity
    return total1 + total2
  }
    
    
  var calculatedVat : Float{
    return self.subTotal * 0.05
  }
  
  var finalTotal : Float{
    //return self.subTotal + self.calculatedVat
      return self.subTotal
  }
    
    var grossTotalMeetingRoom: Float {
        guard !self.orderDetailsOfMeetingRoom.isEmpty else { return 0 }
        
        // Initialize subTotal to 0
        var total: Float = 0.0
        
        for item in self.orderDetailsOfMeetingRoom {
            if item.name == "Subtotal" {
                       if let price = item.price {
                           total = Float(price) ?? 0.0
                           print("total is ",total)
                    }
            }
        }
        
        // Calculate VAT as 5% of the total
            let vat = total * 0.05
        return total + vat
    }
    

    //desk calcualtions
  var deskSubTotal: Float {
    var subTotal: Float = 0.0
    for desk in deskList {
      let deskPrice = desk.price
      let deskPriceFloat = Float(deskPrice) ?? 0.0
        let totalDeskPrice = deskPriceFloat
      subTotal = subTotal + totalDeskPrice
    }
    return subTotal
  }
  var deskVatTotal: Float {
    var vatTotal: Float = 0.0
    vatTotal = deskSubTotal * 5 / 100
    print("deskVatTotal: \(vatTotal)") // Debugging statement

    return vatTotal
  }
  var deskFinalTotal: Float {
    var total: Float = 0.0
    total = deskSubTotal + deskVatTotal
      print("deskFinalTotal: \(total)") // Debugging statement

    return total
  }
    
    
    // office calculations
    //computed property
    var floatPriceOffice : Float {
      let price =  Float(self.roomprice) ?? 0.0
      return price
    }
    
    var officeSubTotal: Float {
      var subTotalOffice: Float = 0.0
        let officePrice = self.floatPriceOffice
        let officePriceFloat = Float(officePrice) ?? 0.0
        let totalOfficePrice = officePriceFloat * timeDifferece
        subTotalOffice = subTotalOffice + totalOfficePrice
      return subTotalOffice
    }

    var officeVatTotal: Float {
      var vatTotalOffice: Float = 0.0
        vatTotalOffice = officeSubTotal * 5 / 100
      return vatTotalOffice
    }
    
    var officeFinalTotal: Float {
      var totalFinalOffice: Float = 0.0
       // totalFinalOffice = officeSubTotal + officeVatTotal
       // totalFinalOffice  = orderDetailsOfOffice
      return totalFinalOffice
    }
    var grossTotalOffice: Float {
        // Guard to safely unwrap the `orderDetailOfOffice` array
        guard !self.orderDetailsOfOffice.isEmpty else { return 0 }
        
        // Initialize subTotal to 0
        var total: Float = 0.0
        
        // Iterate through the items in `orderDetailsOfMeetingRoom`
        for item in self.orderDetailsOfOffice {
            // Check if the item's name is "Subtotal"
            if item.name == "Subtotal" {
                       // Convert price to Float directly from string
                       if let price = item.price {
                           total = Float(price) ?? 0.0
                    }
            }
        }
        
        // Calculate VAT as 5% of the total
            let vat = total * 0.05
        return total + vat + totalOfAmenity
    }
  mutating func setValues(model: RoomDetailResponse){
    self.meetingId = model.data.id
    self.meetingRoom = model.data.name
    self.roomprice = model.data.price
    self.location = model.data.locationName
    self.sittingConfig = model.data.configurationsDetails
    self.date = model.datetime.date
    self.startTime = model.datetime.startTime
    self.endTime = model.datetime.endTime
    self.teamMembers = model.members ?? []
    self.amenityArray = model.amenity
    self.freeamenityArray = model.amenityFree ?? []
    
  }
    mutating func setValuesforOrderDetails(model: StoreRoomBookingResponse){
        
        self.orderDetailsOfMeetingRoomwithAll = model.orderDetails
        self.orderDetailsOfMeetingRoom = model.orderDetails?.total ?? []
        self.mainPrice = model.orderDetails?.mainprice
        self.weekDay = model.orderDetails?.weekday
        self.surcharge = model.orderDetails?.surcharge
        self.weekEnd = model.orderDetails?.weekend
        // Convert `String?` to `Int?` safely for `totalHrs`
           if let totalHrsString = model.totalHrs, let totalHrsInt = Int(totalHrsString) {
               self.totalHrs = totalHrsInt
           } else {
               self.totalHrs = 0
           }
    }
    
  mutating func setValues(response: StoreDeskBookingResponseModel){
    let startTimeString = response.data?.startTime ?? ""
    if let regularStartTime = Date.convertTo(startTimeString, givenFormat: .HHmmss, newFormat: .HHmm) {
      self.startTime = regularStartTime
    }
    if let displayStartTime = Date.convertTo(startTimeString, givenFormat: .HHmmss, newFormat: .hhmma) {
      self.displayStartTime = displayStartTime
    }
    // End time
    let endTimeString = response.data?.endTime ?? ""
    if let regularEndTime = Date.convertTo(endTimeString, givenFormat: .HHmmss, newFormat: .HHmm) {
      self.endTime = regularEndTime
    }
    
    if let displayEndTime = Date.convertTo(endTimeString, givenFormat: .HHmmss, newFormat: .hhmma) {
      self.displayendTime = displayEndTime
      
    }
    // Display date
    let bookingdate = response.data?.date ?? ""
    self.date = bookingdate
   // self.roomprice = "\(response.data?.totalPrice ?? 0)"
      if let firstDesk = self.deskList.first {
              self.roomprice = firstDesk.price
          } else {
              self.roomprice = "0.0" // Default value if no desks are available
          }
//      // Calculate the total price from desks' prices
//          let totalDeskPrice = self.deskList.reduce(0.0) { (result, desk) -> Double in
//              return result + (Double(desk.price) ?? 0.0)
//          }
//          
//          // Assign the calculated desk price to roomprice
//          self.roomprice = "\(totalDeskPrice)"
          
    self.meetingId = response.data?.id ?? 0
    self.deskList = response.desks ?? []
      
      
  }
    
    mutating func setValues(response: StoreofficeBookingResponse){
      let startTimeString = response.data?.startTime ?? ""
      if let regularStartTime = Date.convertTo(startTimeString, givenFormat: .HHmmss, newFormat: .HHmm) {
        self.startTime = regularStartTime
      }
      if let displayStartTime = Date.convertTo(startTimeString, givenFormat: .HHmmss, newFormat: .hhmma) {
        self.displayStartTime = displayStartTime
      }
      // End time
      let endTimeString = response.data?.endTime ?? ""
      if let regularEndTime = Date.convertTo(endTimeString, givenFormat: .HHmmss, newFormat: .HHmm) {
        self.endTime = regularEndTime
      }
      
      if let displayEndTime = Date.convertTo(endTimeString, givenFormat: .HHmmss, newFormat: .hhmma) {
        self.displayendTime = displayEndTime
        
      }
      // Display date
      let bookingdate = response.data?.date ?? ""
      self.date = bookingdate
      self.roomprice = "\(response.data?.price ?? "0" )"
      self.meetingId = response.data?.officeID ?? 0
      self.meetingRoom = response.data?.name ?? ""
      self.noOfSeats = response.data?.seats ?? 0
      self.totalHrs = response.data?.totalHrs ?? 0
      self.officeBookingId = response.data?.id ?? 0
      self.orderDetailsOfOffice = response.orderDetails?.total ?? []
        self.orderDetailsfOfficewithAll = response.orderDetails
        
    }
}
