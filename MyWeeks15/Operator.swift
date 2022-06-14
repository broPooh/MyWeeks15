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
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
