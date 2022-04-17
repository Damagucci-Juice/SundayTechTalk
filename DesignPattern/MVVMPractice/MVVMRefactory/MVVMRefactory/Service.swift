//
//  Logic.swift
//  MVVMRefactory
//
//  Created by 박진섭 on 2022/04/17.
//

//MARK: 로직을 처리하는 곳
//MARK: Entity를 로직에서 사용할 필요한 값들만 뽑아서 모델로 전환  UTcTimeModel -> Model(Date)
import Foundation

class Service {
    
    //로직을 처리하는 Service는 로직을 처리하기 위한 데이터가 필요하므로 repository를 가지고 있다.
    let repository = Repository()
    
    var currentModel = Model(currentDateTime: Date() )
    
    func fetchNow(onCompleted: @escaping (Model) -> Void) {
        //Service는 entity를 받아 어떠한 로직을 가지고 처리를 하고 모델을 만들어 전달한다.
        repository.fetchNow { [weak self] entity in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
            
            guard let now = formatter.date(from: entity.currentDateTime) else { return }
            let model = Model(currentDateTime:now)
            self?.currentModel = model
            onCompleted(model)
        }
    }
    
    
    func moveDay(_ day:Int) {
        guard let movedDay = Calendar.current.date(byAdding: .day,
                                                    value: day,
                                                    to: currentModel.currentDateTime) else { return }
        self.currentModel.currentDateTime = movedDay
    }
}
