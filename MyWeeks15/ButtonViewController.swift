//
//  ButtonViewController.swift
//  MyWeeks15
//
//  Created by bro on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxAlamofire

class ButtonViewModel: CommonViewModel {
    var disposBag = DisposeBag()
    
    struct Input {
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let text: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let result = input.tap
            .map { "안녕 반가워"}
            .asDriver(onErrorJustReturn: "")
        
        return Output(text: result)
    }
    
}

class ButtonViewController: UIViewController {
    
    let button = UIButton()
    let label = UILabel()
    
    
    let disposBag = DisposeBag()
    
    let viewModel = ButtonViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
             

    }
    
    func bind() {
    
//        button.rx.tap
//            .map { "안녕 반가워" }
//            .asDriver(onErrorJustReturn: "")
//            .drive(label.rx.text)
//            .disposed(by: disposBag)
                
        let input = ButtonViewModel.Input(tap: button.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.text
            .drive(label.rx.text)
            .disposed(by: disposBag)
    }
    
    func setup() {
        view.addSubview(button)
        view.addSubview(label)
        
        button.backgroundColor = .white
        label.backgroundColor = .lightGray
        
        button.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.leading.equalTo(20)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
    }
    
    
}


//버튼 탭 -> 문자열 -> 레이블

//button
//    .rx.tap
//    .observe(on: MainScheduler.instance)
//    .subscribe { value in //subscribe -> 어떤 쓰레드에서 돌지 알 수 없다.
//        print(value)
//        self.label.text = "안녕 반가워"
//    }
//    .disposed(by: disposBag)
//
//button
//    .rx.tap
//    .bind(to: { _ in
//        self.label.text = "안녕 반가워"
//
//    })
//    .disposed(by: disposBag)
//
//button.rx.tap
//    .map { "안녕 반가워" }
//    .bind(to: label.rx.text)
//    .disposed(by: disposBag)
