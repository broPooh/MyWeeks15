//
//  ReactiveViewController.swift
//  MyWeeks15
//
//  Created by bro on 2022/06/15.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxAlamofire

struct SampleData {
    var user: String
    var age: Int
    var rate: Double
}

class ReactiveViewModel {
    var data = [
        SampleData(user: "Jack", age: 13, rate: 2.2),
        SampleData(user: "Hue", age: 11, rate: 4.4),
        SampleData(user: "Bro", age: 12, rate: 3.2)
    ]
    
    //var list = BehaviorSubject<[SampleData]>(value: data)
    //var list = PublishSubject<[SampleData]>()
    var list = PublishRelay<[SampleData]>()
    
    func fetchData() {
        //list.onNext(data)
        list.accept(data)
    }
    
    func filterData(query: String) {
        let result = query != "" ? data.filter { $0.user.contains(query) } : data
        //list.onNext(result)
        list.accept(result)
    }
}

class ReactiveViewController: UIViewController {
    
    let disposBag = DisposeBag()
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let resetBtn = UIButton()
    
    let viewModel = ReactiveViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
            
        //viewmodel data -> tableView ??
        /*
        viewModel
            .list
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element.user): \(element.age)세 (\(element.rate))"
                return cell
            }
            .disposed(by: disposBag)
        */
        
        viewModel
            .list
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element.user): \(element.age)세 (\(element.rate))"
                return cell
            }
            .disposed(by: disposBag)

        resetBtn
            .rx.tap
            .subscribe { _ in //Backward matching of the unlabeled trailing closure is deprecated
                print("click")
                self.viewModel.fetchData()
            }
            .disposed(by: disposBag)
        
        searchBar
            .rx.text //서치바 텍스트가 변경이 될때 이벤트 발생
            .orEmpty //옵셔널 해제
            .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged() //중복되는 값은 받지 않는다.
            .subscribe { value in
                print(value)
                self.viewModel.filterData(query: value.element ?? "")
            }
            .disposed(by: disposBag)
        
        var apple = 1
        var banana = 2
        
        print(apple + banana)
        
        apple = 10
        banana = 20
        
        
        let a = BehaviorSubject(value: 1)
        let b = BehaviorSubject(value: 2)
        
        Observable.combineLatest(a, b) { $0 + $1 }
            .subscribe {
                print($0.element ?? 100)
            }
            .disposed(by: disposBag)
        
        a.onNext(50)
        a.onNext(100)
        b.onNext(20)

    }
    
    func setUp() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(resetBtn)
        resetBtn.backgroundColor = .red
        resetBtn.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    
}
