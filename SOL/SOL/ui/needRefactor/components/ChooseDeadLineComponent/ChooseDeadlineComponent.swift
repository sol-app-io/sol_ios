//
//  ChooseDeadlineComponent.swift
//  SOL
//
//  Created by Rostislav Maslov on 09.06.2021.
//

import SwiftUI

import SwiftUI
import CalendarKit
import EventKit
import EventKitUI
import UIKit



struct ChooseDeadlineComponent: View {
    @State var eventDates: [Date] = [Date()]
    
    var body: some View {
        VStack{
            Spacer().frame(width: 0, height: 18, alignment: .center)
            Text("Plan your work")
            Spacer().frame(width: 0, height: 12, alignment: .center)
                .background(SolColor.colors().addTask.addTaskBackground)
                .frame(width: .infinity, height: 24, alignment: .center)
            Spacer().frame(width: 0, height: 0, alignment: .center)
            
            TestingCalendarController(eventDates: $eventDates)
            Spacer().frame(width: 0, height: 0, alignment: .center)
        }.background(SolColor.colors().addTask.addTaskBackground)
    }
    
}

struct ChooseDeadlineComponent_Previews: PreviewProvider {
    static var previews: some View {
        ChooseDeadlineComponent()
    }
}