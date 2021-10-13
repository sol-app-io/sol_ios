//
//  CalendarView.swift
//  SOL
//
//  Created by Rostislav Maslov on 13.07.2021.
//

import Foundation
import Foundation
import SwiftUI
import EventKit
import CalendarKit

//Что делаем дальше:

//6 - подумать над тем, как мы будем удалять слоты, может дополнительное окно для редактирования слота
//7 - занести нужно это все в ToDo

protocol DaySchedulerProtocol {
    func newSlotName() -> String
    func slotsByDay(date: Date, callback:  @escaping (([SlotEntity]) -> Void) )
    func addSlot(startTime: Date, endTime: Date) -> Void
    func changeTimeSlot(slotId: String, startTime: Date, endTime: Date) -> Void
    func onSubmit() -> Void
    func onClose() -> Void
    func onTapEvent(slot: SlotEntity) -> Void
    func onDelete(slotId: String) -> Void
}

struct DaySchedulerView: UIViewControllerRepresentable, DayViewControllerProtocol {

    var delegate: DaySchedulerProtocol
    @State var reloadData: (() -> Void)?
    @State var allSots: [SlotEntity] = []
    var dayViewControllerImpl:DayViewControllerImpl = DayViewControllerImpl()
    
    func newEventTitle() -> String {
        return delegate.newSlotName()
    }
                   
    func eventsForDate(_ date: Date) -> [EventDescriptor] {
        //Получаем инфу о событиях дня. после создание запрашивается заново все события дня
        
        delegate.slotsByDay(date: date, callback: { (results: [SlotEntity]) in
            var needAdd: [SlotEntity] = []
            
            for result in results {
                var hasSlot = false
                for slot in self.allSots {
                    if slot.id == result.id {
                        hasSlot = true
                        break
                    }
                }
                
                if hasSlot == false {
                    needAdd.append(result)
                }
            }
            
            if needAdd.count > 0 {
                self.allSots.append(contentsOf: needAdd)
                DispatchQueue.main.async {
                    self.dayViewControllerImpl.reloadData()
                }
            }
        })
        
        var result:[EventDescriptor] = []
        for slot in allSots {
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyyy"
            
            let firstTime:String = formatter.string(from: date)
            let startTime:String = formatter.string(from: slot.startTime!)
            let endTime:String = formatter.string(from: slot.endTime!)

            if firstTime == startTime || firstTime == endTime {
                result.append(slot.updateAndReturnDescriptor())
            }
        }
        return result
    }
    
    func newEventColor() -> UIColor {
        return UIColor(SolColor.colors().fontColors.normal)
    }
    
    // MARK: Create Event
    func createEvent(eventDescriptor: EventDescriptor) -> Void {
        // Создание нового слота
        delegate.addSlot(startTime: eventDescriptor.startDate, endTime: eventDescriptor.endDate)
    }
    
    // MARK: Edit Event
    func updateEvent(eventDescriptor: EventDescriptor) -> Void{
        // запускается когда мы хотим обновить событие в календаре
        if let ev:CalendarKit.Event = eventDescriptor.editedEvent as? CalendarKit.Event {
            if let slotId:String = ev.userInfo as? String {
                for slot in allSots {
                    if slotId == slot.id {
                        slot.startTime = eventDescriptor.startDate
                        slot.endTime = eventDescriptor.endDate
                        
                        // Commit changes
                        if slot.isDraft == true {
                            delegate.changeTimeSlot(slotId: slotId, startTime: eventDescriptor.startDate, endTime: eventDescriptor.endDate)
                        } else {
                            let req = SlotUpdateRequest(
                                endTime: eventDescriptor.endDate.millisecondsSince1970,
                                startTime: eventDescriptor.startDate.millisecondsSince1970,
                                id: slotId,
                                timezone: Date().timezone)
                          
                            SolApiService.instance?.slot.edit(req, responseFunc: { success, error, isSuccess in
                                print(isSuccess)
                            })
                        }
                    }
                }
                
            }
        }
        
    }
    
    // MARK: Did tap on event
    func didSelectEvent(eventDescriptor: Event) {
        let slotId: String = eventDescriptor.userInfo as! String
        for slot in allSots {
            if slot.id == slotId {
                delegate.onTapEvent(slot: slot)
            }
        }                
    }
    
    
            
    func updateUIViewController(_ uiViewController: UIViewController, context: Context){
        
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        dayViewControllerImpl.eventDelegate = self
        dayViewControllerImpl.title = "Schedule task work"
        
        return dayViewControllerImpl
    }
    
    
}
