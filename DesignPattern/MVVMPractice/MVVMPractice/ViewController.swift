//
//  ViewController.swift
//  MVVMPractice
//
//  Created by 박진섭 on 2022/04/17.
//

import UIKit

class ViewController: UIViewController {

    //MARK: -- View
    @IBOutlet weak var datetimeLabel: UILabel!
    
    //yesterday button
    //now button
    //tomorrow button
    
    @IBAction func onYesterday(_ sender: UIButton) {
        guard let yesterday = Calendar.current.date(byAdding: .day,
                                                    value: -1,
                                                    to: currentDateTime) else { return }
        currentDateTime = yesterday
        updateDateTime()
    }
    
    @IBAction func onNow(_ sender: UIButton) {
        fetchNow()
    }
    
    @IBAction func onTomorrow(_ sender: UIButton) {
        guard let tomorrow = Calendar.current.date(byAdding: .day,
                                                    value: +1,
                                                    to: currentDateTime) else { return }
        currentDateTime = tomorrow
        updateDateTime()
    }
    
    //MARK: Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    private var currentDateTime = Date()
    
    private func fetchNow() {
        let url = "http://worldclockapi.com/api/json/utc/now"
        
        datetimeLabel.text = "Loading.."
        
        
        URLSession.shared.dataTask(with: URL(string:url)!) {[weak self] data, _ , _ in
            guard let data = data else  { return }
            guard let model = try? JSONDecoder().decode(UTcTimeModel.self, from: data) else { return }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
            
            guard let now = formatter.date(from: model.currentDateTime) else { return }
            
            self?.currentDateTime = now
            
            DispatchQueue.main.async {
                self?.updateDateTime()
            }
            
        }.resume()
        
    }
    
    private func updateDateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        datetimeLabel.text = formatter.string(from: currentDateTime)
    }

    
    //MARK: -- Model
    
    struct UTcTimeModel:Codable {
        let currentDateTime: String
    }
    
    
}

/*
 Model의 변천사
 -> JSON
 -> UTcTimeModel
 -> String
 -> Date
 -> String
 
//세 가지 형태의 모델
 serverModel(Entity)
 -> UTcTimeModel
    
 Model
 -> Date
 
 View Model
-> String
 
 
 //흐름
 
 Repository
 
 serverModel(Entity)
 -> UTcTimeModel
    
 Mapper -> decoding
 
 Model
 -> Date
 
 Logic
 
 View Model
-> String
 
 View
 
 
 
*/
