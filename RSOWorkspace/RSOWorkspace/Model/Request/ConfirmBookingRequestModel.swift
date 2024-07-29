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
  var teamMembers: [String] = []
  var guest: [String] = []
  var amenityArray: [Amenity] = []
  var deskList: [Desk] = []
    var noOfSeats :Int = 0
    var totalHrs:Int = 0
    
  //computed property
  var floatPrice : Float {
    let price =  Float(self.roomprice) ?? 0.0
    return price
  }
  
  //computed property
  var timeDifferece : Float{
    get {
      let formatter = DateFormatter()
      formatter.dateFormat = "HH:mm"
      
      if let startTimeDate = formatter.date(from: self.startTime),
         let endTimeDate = formatter.date(from: self.endTime) {
        print("startTimeDate",startTimeDate)
        print("endTimeDate",endTimeDate)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: startTimeDate, to: endTimeDate)
        
        if let differenceInHours = components.hour {
          return Float(differenceInHours)
        }
      }
      return 0.0
    }
    set{
      
    }
  }
  
  var totalOfAmenity: Float {
    var totalAmenityPrice: Float = 0.0
    let timeDifference = self.timeDifferece
    
    for amenity in amenityArray {
      let amenityPrice = Float(amenity.price ?? "0.0") ?? 0.0
      totalAmenityPrice += (amenityPrice * timeDifference)
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
    return self.subTotal + self.calculatedVat
  }
  var deskSubTotal: Float {
    var subTotal: Float = 0.0
    for desk in deskList {
      let roomPrice = desk.price
      let roomPriceFloat = Float(roomPrice) ?? 0.0
      let totalRoomPrice = roomPriceFloat * timeDifferece
      subTotal = subTotal + totalRoomPrice
    }
    return subTotal
  }
  var deskVatTotal: Float {
    var vatTotal: Float = 0.0
    vatTotal = deskSubTotal * 5 / 100
    return vatTotal
  }
  var deskFinalTotal: Float {
    var total: Float = 0.0
    total = deskSubTotal + deskVatTotal
    return total
  }
    
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
        totalFinalOffice = officeSubTotal + officeVatTotal
      return totalFinalOffice
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
    //self.teamMembers = model.members ?? []
    self.amenityArray = model.amenity
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
    self.roomprice = "\(response.data?.totalPrice ?? 0)"
    self.meetingId = response.data?.deskTypeID ?? 0
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
        
    }
}
