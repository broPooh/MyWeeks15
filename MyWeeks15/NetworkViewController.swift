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

// MARK: - Lotto
struct Lotto: Codable {
    let totSellamnt: Int
    let returnValue, drwNoDate: String
    let firstWinamnt, drwtNo6, drwtNo4, firstPrzwnerCo: Int
    let drwtNo5, bnusNo, firstAccumamnt, drwNo: Int
    let drwtNo2, drwtNo3, drwtNo1: Int
}


class NetworkViewController: UIViewController {
 
    let urlString = "https://aztro.sameerkumar.website/?sign=aries&day=today"
    let lottoURL = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=903"
    let disposBag = DisposeBag()
    
    let label = UILabel()
    
    let number = BehaviorSubject<String>(value: "오늘의 운세")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
        number
            .bind(to: label.rx.text)
            .disposed(by: disposBag)

//        number
//            .observe(on: MainScheduler.instance)
//            .subscribe { value in
//                self.label.text = value
//            }
//            .disposed(by: disposBag)
        
        let request = useURLSession()
            .share() // 스트림(데이터)를 공유한다 -> Drive함수는 share를 내부적으로 가지고 있다.
            .decode(type: Lotto.self, decoder: JSONDecoder())
        
    
        
        request
            .subscribe { value in
                print("value1")
                //self.number.onNext(value.drwNoDate)
            }
            .disposed(by: disposBag)
        
        request
            .subscribe { value in
                print("value2")
                //self.number.onNext(value.drwNoDate)
            }
            .disposed(by: disposBag)

    }
    
    func setUp() {
        view.addSubview(label)
        label.backgroundColor = .white
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func rxAlamofire() {
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
    
    
    func useURLSession() -> Observable<Data> {
        return Observable.create { value in
            let url = URL(string: self.lottoURL)!
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    value.onError(ExampleError.fail)
                    return
                }
                
                //response, data, json, encoding 생략
                
                if let data = data, let json = String(data: data, encoding: .utf8) {
                    print("dataTask")
                    value.onNext(data)
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
