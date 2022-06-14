//
//  ViewController.swift
//  MyWeeks15
//
//  Created by bro on 2022/06/14.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    
    let label = UILabel()
    
    let disposeBag = DisposeBag()
    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        

        viewModel.items
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .map({ data in
                "\(data)를 클릭했습니다!"
            })
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    func setup() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(label)
        label.backgroundColor = .lightGray
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
        }
    }


}

class ViewModel {
    
    let items = Observable.just([
        "First Item",
        "Second Item",
        "Third Item"
    ])
    
    func addItem(text: String) {
        //items.description.append(<#T##String#>)
    }
    
}
