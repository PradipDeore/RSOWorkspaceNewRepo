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
    //computed property
    var floatPrice : Float {
        let price =  Float(self.roomprice) ?? 0.0
        return price
    }
    
    //computed property
    var timeDifferece : Float{
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

    }
}
