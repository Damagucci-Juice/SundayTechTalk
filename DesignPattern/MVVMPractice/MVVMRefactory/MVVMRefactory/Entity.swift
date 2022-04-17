//
//  Entity.swift
//  MVVMRefactory
//
//  Created by 박진섭 on 2022/04/17.
//

//MARK: 서버로 부터 온 (데이터를 Swift에 맞게 디코딩 될) 모델

import Foundation

struct UTcTimeModel:Codable {
    let utcOffset: String
    let isDayLightSavingsTime : Bool
    let currentDateTime: String
}


