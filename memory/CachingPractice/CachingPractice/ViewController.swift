//
//  ViewController.swift
//  CachingPractice
//
//  Created by 박진섭 on 2022/04/24.
//

import UIKit

//imageCache를 담당할 싱글톤 클래스
class ImageCacheManger {
    static let shared = NSCache<NSString,UIImage>() //memory
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
        
        guard let imageURL = URL(string: "https://user-images.githubusercontent.com/80263729/165081176-7a7c6f3a-7fdd-44ce-9037-91f20b3112ec.png") else { return }
        
        URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, _ in
            
            //URL의 마지막 Path Component로 Key를 만듬.
            let cacheKey = NSString(string: imageURL.lastPathComponent)
            
            print(ImageCacheManger.shared.object(forKey: cacheKey))
            
            //1. Cache에 이미 image가 있다면 image를 가져와서 넣고 함수를 종료함. (Memory Cache확인)
            DispatchQueue.main.async {
                if let cachedImage = ImageCacheManger.shared.object(forKey: cacheKey) {
                    imageView.image = cachedImage
                    return
                }
            }
            
            //2. Memory Cache에 없다 -> diskCache를 찾아봄
            let fileManager = FileManager()
     
            //Cache가 저장되는 path(Disk Caching)
            guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
            print(path)
                
            var filePath = URL(fileURLWithPath: path)
            print(filePath)
            
            filePath.appendPathComponent(imageURL.lastPathComponent)
            print(filePath)
            
            //disk에서 cache된 파일이 있다.
            //3. Cache된 데이터를 이용해서 이미지를 띄운다.
            //4. 다음을 위해서 memoryCache에 넣는다.
            if fileManager.fileExists(atPath: filePath.path) {
                guard let imageData = try? Data(contentsOf: filePath),
                      let image = UIImage(data: imageData) else { return }
                DispatchQueue.main.async {
                    imageView.image = image
                }
                ImageCacheManger.shared.setObject(image, forKey: cacheKey)    //cacheKey로 image를 등록함.
                return
            }
            

            //disk에도 cache된 파일이 없다.
            //5. disk에 파일을 생성한다.
            //6. MemoryCache와 Disk 모두 없기 때문에 URL에서 비동기로 가지고 온다.
            //7. Memorycache와 Disk 모두 저장해둔다.
            guard let imageData = data,
                  let image = UIImage(data: imageData) else { return }
            if !fileManager.fileExists(atPath: filePath.path) {
                fileManager.createFile(atPath: filePath.path, contents: image.pngData(), attributes: nil)
                ImageCacheManger.shared.setObject(image, forKey: cacheKey)    //cacheKey로 image를 등록함.
                DispatchQueue.main.async {
                    imageView.image = image
                }
                return
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

