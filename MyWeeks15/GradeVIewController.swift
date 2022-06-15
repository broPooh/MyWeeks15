//
//  GradeVIewController.swift
//  MyWeeks15
//
//  Created by bro on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class GradeVIewController: UIViewController {
    
    let mySwitch = UISwitch()
    let disposBag = DisposeBag()
    
    let first = UITextField()
    let second = UITextField()
    let resultLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
        Observable.of(true)
            .bind(to: mySwitch.rx.isOn)
            .disposed(by: disposBag)
        
        
        Observable.combineLatest(first.rx.text.orEmpty, second.rx.text.orEmpty) { textValue1, textValue2 -> Double in
            return ((Double(textValue1) ?? 0.0) + (Double(textValue2) ?? 0.0)) / 2
        }
        .map{ $0.description }
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposBag)
        
        
    }
    
    func setUp() {
        view.backgroundColor = .white
        view.addSubview(mySwitch)
        
        mySwitch.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(first)
        view.addSubview(second)
        view.addSubview(resultLabel)

        first.backgroundColor = .lightGray
        second.backgroundColor = .lightGray
        resultLabel.backgroundColor = .lightGray
        
        first.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.size.equalTo(50)
            make.leading.equalTo(50)
        }
        
        second.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.size.equalTo(50)
            make.leading.equalTo(120)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.size.equalTo(50)
            make.leading.equalTo(200)
        }
        
    }
    
}
