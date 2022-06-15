//
//  Operator.swift
//  MyWeeks15
//
//  Created by bro on 2022/06/14.
//

import UIKit
import RxSwift

enum ExampleError: Error {
    case fail
}

class Operator: UIViewController {
    
    var disposeBag = DisposeBag()
    
    //var observable: Observable<Int>?
    var intDisposable: Disposable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //Observable의 생명주기
       //Observable → Subscribe → Next → Complete / Error → Dispose
       //disposed: deinit
        
        Observable.from(["가", "나", "다", "라", "마"])
            .subscribe { value in
                print("next: \(value)")
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("dispose  ")
            }
            .disposed(by: disposeBag)

        let intervalObservable = Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("next: \(value)")
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("dispose  ")
            }
            .disposed(by: disposeBag)
        
        
         let repeatObservable = Observable.repeatElement("Bro")
            .take(Int.random(in: 1...10))
            .subscribe { value in
                print("next: \(value)")
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //하나의 옵저버블을 취소할때는 dispose를 실행하면 된다.
//            intervalObservable.dispose()
//            repeatObservable.dispose()
            
            //DisposeBag을 새롭게 객체를 생성해서 대입을 해주게 되면,
            //등록되어 있는 disposeBag이 새로운 것으로 변경이 되었기때문에
            //돌아가고 있던 Observable의 메모리를 해제할 수 있다.
            self.disposeBag = DisposeBag()
            
            //self.navigationController?.pushViewController(GradeVIewController(), animated: true)
            //self.dismiss(animated: true, completion: nil)
            //self.present(GradeVIewController(), animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit {
        print("Operator Deinit")
    }
    
    
    func basic() {
        //처음 연습
        let items = [3.3, 2.0, 4.0, 5.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(items)
            .subscribe { value in
                print("just - \(value)")
            }
            .disposed(by: disposeBag)
        
        
        Observable.of(items, itemsB)
            .subscribe { value in
                print("of - \(value)")
            }
            .disposed(by: disposeBag)
        
        Observable.from(items)
            .subscribe { value in
                print("from - \(value)")
            }
            .disposed(by: disposeBag)
        
        
        //Observable 기초
        Observable<Double>.create { observer -> Disposable in
            for i in items {
//                if i < 3.0 {
//                    observer.onError(ExampleError.fail)
//                }
                observer.onNext(i)
            }
            observer.onCompleted()
            
            return Disposables.create()
        }.subscribe { value in
            print(value)
        } onError: { error in
            print(error) // Alert
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("disposed")
        }
        .disposed(by: disposeBag)
    }
    
}
