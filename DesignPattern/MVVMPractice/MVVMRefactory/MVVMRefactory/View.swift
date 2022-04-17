//
//  ViewController.swift
//  MVVMPractice
//
//  Created by 박진섭 on 2022/04/17.
//

//FLOW
/*
 
 Repository -> Entity -> Mapper -> Model -> Logic -> ViewModel -> View
 
 */


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datetimeLabel: UILabel!
    
    //이제 화면 입장에서는 어떤 이벤트가 발생할때 ViewModel한테 시킴.
    @IBAction func onYesterday(_ sender: UIButton) {
        viewModel.moveDay(-1)
    }
    
    @IBAction func onNow(_ sender: UIButton) {
        datetimeLabel.text = "로딩중~ "
        viewModel.reload()
    }
    
    @IBAction func onTomorrow(_ sender: UIButton) {
        viewModel.moveDay(+1)
    }
    
    let viewModel = ViewModel()
    
    //MARK: Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reload()
        
        //업데이트가 일어났다
        viewModel.onUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.datetimeLabel.text = self?.viewModel.dateTimeString           //ViewModel의 값을 가져오기만 하면 된다.
            }
        }
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
    
 Mapper
 
 Model
 -> Date
 
 Logic
 
 View Model
-> String
 
 View
 
 
 
*/
