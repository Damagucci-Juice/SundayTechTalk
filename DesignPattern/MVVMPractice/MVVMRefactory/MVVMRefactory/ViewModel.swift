//
//  ViewModel.swift
//  MVVMRefactory
//
//  Created by 박진섭 on 2022/04/17.
//

import Foundation

class ViewModel {
    
    //ViewModel은 데이터를 처리하기 위한 로직을 사용해야하기 때문에 Service를 가지고 있어야함.
    let service = Service()
    
    //업데이트가 되었는지 안되었는지
    var onUpdated: () -> Void = { }
    
    var dateTimeString: String = "로딩중~"             //화면에 보여줄값(Sting) -> View를 위한 모델
    {
        didSet {
            onUpdated()
        }
    }

    
    func moveDay(_ day:Int) {
        service.moveDay(day)
        dateTimeString = dateToString(date: service.currentModel.currentDateTime)
    }
    
    func reload() {
        service.fetchNow { [weak self] model in             //service에서 받아온 모델을 화면에 보여주기 위한 데이터로 처리함. Date -> String
            guard let self = self else { return }
            let dateString = self.dateToString(date: model.currentDateTime)
            self.dateTimeString = dateString
        }
    }
    
    private func dateToString(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        let dateTimeString = formatter.string(from: date)
        return dateTimeString
    }
}
