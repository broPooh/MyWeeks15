//
//  NetworkViewController.swift
//  MyWeeks15
//
//  Created by bro on 2022/06/15.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import RxAlamofire

class NetworkViewController: UIViewController {
 
    let urlString = "https://aztro.sameerkumar.website/?sign=aries&day=today"
    let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=903"
    let disposBag = DisposeBag()
    
    let label = UILabel()
    
    let number = BehaviorSubject<String>(value: "오늘의 운세")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.backgroundColor = .white
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        number
            .bind(to: label.rx.text)
            .disposed(by: disposBag)
        
        //number.onNext("오늘의 운세: 숫자")
        
//        json(.get, lottoURL)
//            .subscribe { value in
//                print(value)
//            } onError: { error in
//                print(error)
//            } onCompleted: {
//                print("complete")
//            } onDisposed: {
//                print("dispose")
//            }
//            .disposed(by: disposBag)

        //json(.post, urlString, parameters: ["a" : "g", "asd" : "asd"])
        //JSONSerialization
        json(.post, urlString)
            .subscribe { value in
                print(value)
                guard let data = value as? [String: Any] else { return }
                guard let result = data["lucky_number"] as? String else { return }
                print("==\(result)")
                self.number.onNext(result)
                
                
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("dispose")
            }
            .disposed(by: disposBag)
    }
    
    
    func useURLSession(url: String) -> Observable<String> {
        return Observable.create { value in
            let url = URL(string: self.lottoURL)!
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    value.onError(ExampleError.fail)
                    return
                }
                
                //response, data, json, encoding 생략
                
                if let data = data, let json = String(data: data, encoding: .utf8) {
                    value.onNext("\(data)")
                }
                
                value.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create() {
                task.cancel()
            }
        }
    }
}
