//
//  SubjectViewController.swift
//  MyWeeks15
//
//  Created by bro on 2022/06/14.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class SubjectViewController: UIViewController {
    
    let label = UILabel()
    
    let nickname = PublishSubject<String>()
    
    let disposBag = DisposeBag()
    
    let array1 = [1, 1, 1, 1, 1]
    let array2 = [2, 2, 2, 2, 2]
    let array3 = [3, 3, 3, 3, 3]
    
    let subject = PublishSubject<[Int]>()
    let behavior = BehaviorSubject<[Int]>(value: [0,0,0,0,0])
    let replay = ReplaySubject<[Int]>.create(bufferSize: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let random1 = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        random1
            .subscribe { value in
                print("random1 \(value)")
            }.disposed(by: disposBag)
        
        random1
            .subscribe { value in
                print("random2 \(value)")
            }.disposed(by: disposBag)
       
        
        let randomSubject = BehaviorSubject(value: 0)
        randomSubject.onNext(Int.random(in: 1...100))
        
        randomSubject
            .subscribe { value in
                print("randomSubject1 \(value)")
            }.disposed(by: disposBag)
        
        randomSubject
            .subscribe { value in
                print("randomSubject2 \(value)")
            }.disposed(by: disposBag)
        
    }
    
    
    func replaySubject() {
        replay.onNext(array1)
        replay.onNext(array2)
        replay.onError(ExampleError.fail)
        replay.onNext(array3)
        replay.onNext([4,4,4,4,4])
        replay.onNext([6, 6, 6, 6, 6])
        
        replay
            .subscribe { value in
                print("replay subject - \(value)")
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("dispose")
            }
        
        replay.onNext([5, 6, 7, 8])
    }
    
    func behaviorSubject() {
        behavior.onNext(array1)
        behavior.onNext(array2)
        behavior.onNext(array3)
        
    
        behavior
            .subscribe { value in
                print("behavior subject - \(value)")
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("dispose")
            }
    }
    
    func publishSubject() {
        subject.onNext(array1)
        subject.subscribe { value in
            print("publish subject - \(value)")
        } onError: { error in
            print(error)
        } onCompleted: {
            print("complete")
        } onDisposed: {
            print("dispose")
        }
        subject.onNext(array2)
        subject.onNext(array3)
        subject.onCompleted()
    }
    
    
    func aboutSubject() {
        setup()
        
        nickname.bind(to: label.rx.text)
            .disposed(by: disposBag)
        
        nickname.onNext("Bro")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.nickname.onNext("BroBro")
        }
    }
    
    func setup() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.backgroundColor = .white
        label.textAlignment = .center
    }
    
}
