//
//  Repository.swift
//  MVVMRefactory
//
//  Created by 박진섭 on 2022/04/17.
//

//MARK: 서버로부터 온 모델을 가져오는 Repository
//MARK: 서버로부터 온 모델을 전달해주는 역할 JSON -> UTcTimeModel(Entity)
import Foundation

class Repository {
    //UTcTimeModel == Entity
    func fetchNow(onCompleted: @escaping (UTcTimeModel) -> Void) {
        let url = "http://worldclockapi.com/api/json/utc/now"
        
        //Repository의 역할은 그저 Json을 받아서 우리가 원하는 형태(Entity)로 decoding하는 역할
        URLSession.shared.dataTask(with: URL(string:url)!) { data, _ , _ in
            guard let data = data else  { return }
            guard let model = try? JSONDecoder().decode(UTcTimeModel.self, from: data) else { return }
            onCompleted(model)  //성공시 전달한다.
        }.resume()
    
    }
}
