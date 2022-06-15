//
//  ValidationViewConroller.swift
//  MyWeeks15
//
//  Created by bro on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxAlamofire

class ValidationViewModel {
    var validText = BehaviorRelay<String>(value: "최소 8자 이상 필요해요")
}

class ValidationViewConroller: UIViewController {
    
    let nameValidationLabel = UILabel()
    let nameTextFiled = UITextField()
    let button = UIButton()
    
    let viewModel = ValidationViewModel()
    let disposBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel.validText
            .asDriver()
            .drive(nameValidationLabel.rx.text)
            .disposed(by: disposBag)
        
        let validation = nameTextFiled
            .rx.text
            .orEmpty
            .map { $0.count >= 8 }
            .share(replay: 1, scope: .whileConnected)
        
        validation
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposBag)
        
        validation
            .bind(to: nameValidationLabel.rx.isHidden)
            .disposed(by: disposBag)
        
        button
            .rx.tap
            .subscribe { _ in
                self.present(ReactiveViewController(), animated: true, completion: nil)
            }
            .disposed(by: disposBag)
        
        setup()
        
    }
    
    
    func setup() {
        [nameTextFiled, button, nameValidationLabel].forEach {
            $0.backgroundColor = .lightGray
            view.addSubview($0)
        }
        
        nameTextFiled.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        nameValidationLabel.snp.makeConstraints { make in
            make.top.equalTo(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(300)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
    }
    
}
