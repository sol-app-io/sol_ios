//
//  FindSlotByDayUseCase.swift
//  SOL
//
//  Created by Rostislav Maslov on 04.10.2021.
//

import Foundation

public class FindSlotByDayUseCase: UseCase<[SlotEntity], Bool>{
    let port: SlotRepositoryPort!
    private let input: Input
    
    init(_ port: SlotRepositoryPort, _ input:Input) {
        self.port = port
        self.input = input
    }
    
    override public func execute(_ callback: @escaping ([SlotEntity], Bool?) -> Void) {
        
        port.findByDate(input.date.millisecondsSince1970, input.date.timezone) { (success: BaseApiResponse<BaseListResponse<SlotResponse>>?, error: BaseApiErrorResponse?, isSuccess:Bool) in
            if success != nil && isSuccess == true {
                callback(SlotMapping.mapping(response: success != nil ? success!.result.items : []), true)
            }else{
                callback([], false)
            }
        }
    }
}

extension FindSlotByDayUseCase{
    
    public struct Input{
        var date: Date
    }
    
}
