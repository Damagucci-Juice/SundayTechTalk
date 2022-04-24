//
//  ViewController.swift
//  CachingPractice
//
//  Created by 박진섭 on 2022/04/24.
//

import UIKit

//imageCache를 담당할 싱글톤 클래스
class ImageCacheManger {
    static let shared = NSCache<NSString,UIImage>()
    private init() { }
}

class ViewController: UIViewController {

    @IBOutlet weak var imageView0: UIImageView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    private var imageViewOrder = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func loadimage(imageView: UIImageView) {
        
        guard let bonoImageURL = URL(string: "https://image.fmkorea.com/files/attach/new/20200627/486616/1469193793/2965047365/45fce19853d009c717c2e7018a017a11.png") else { return }
        
        //Cache가 저장되는 path
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
        
        print(path)

        URLSession.shared.dataTask(with: bonoImageURL) { [weak self] data, _, _ in
            
            let cacheKey = NSString(string: bonoImageURL.lastPathComponent) //URL의 마지막 Path Component로 Key를 만듬.
            
            print(ImageCacheManger.shared.object(forKey: cacheKey))
            
            //Cache에 이미 image가 있다면 image를 가져와서 넣고 함수를 종료함.
            DispatchQueue.main.async {
                if let cachedImage = ImageCacheManger.shared.object(forKey: cacheKey) {
                    imageView.image = cachedImage
                    return
                }
            }

            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                ImageCacheManger.shared.setObject(image, forKey: cacheKey)    //cacheKey로 image를 등록함.
                imageView.image = image
            }
        }.resume()
    }
    
    //로드 image
    @IBAction func ShowBonoButton(_ sender: UIButton) {
        let imageViews = [imageView0, imageView1, imageView2, imageView3, imageView4]
        
        loadimage(imageView: imageViews[imageViewOrder]!)
        
        if imageViewOrder < 4 {
            imageViewOrder += 1
        } else {
            imageViewOrder = 0
        }
    }
}

