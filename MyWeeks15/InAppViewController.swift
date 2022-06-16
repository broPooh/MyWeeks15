//
//  InAppViewController.swift
//  MyWeeks15
//
//  Created by bro on 2022/06/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxAlamofire
import StoreKit


class InAppViewController: UIViewController {
    
    //1. 인앱 상품 ID 정의
    var productIdentifiers: Set<String> = [
        "com.memolease.minimemo.gold10",
        "com.jack.minimemo.diamond100",
        "com.jack.memo.cookie100"
    ]
    
    //3-1 인앱상품 배열
    var productArray = Array<SKProduct>()
    //사용자가 인앱상품을 선택하면 그 상품을 담기 위한 변수
    var product: SKProduct?
    
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(100)
        }
        
        requestProductData()
    }
    
    //4. 구매 버튼 클릭
    @objc func buttonClicked() {
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
    }
    
    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        
        //구매 영수증 정보
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(receiptString)
        
        //거래내역(transaction)을 큐에서 제거
        SKPaymentQueue.default().finishTransaction(transaction)
        
    }
    
    
    //정의된 상품이 있는지 물어보기
    //2. productIdentifiers에 정의된 상품ID에 대한 정보 가져오기 및 사용자의 디바이스가 인앱결제가 가능한지 여부 확인
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            print("인앱 결제 가능")
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            print("인앱결제 불가능")
            //나중에는 노티나 얼럿 토스트메시지등을 띄워주어야 한다.
        }
    }
    
}


extension InAppViewController: SKProductsRequestDelegate {
    
    //3. 인앱 상품 정보 조회를 받아오는 함수
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let produtcs = response.products
        
        if produtcs.count > 0 {
            
            //상품을 하나씩 조회
            for product in produtcs {
                productArray.append(product)
                self.product = product//옵션
                
                //print("product: ", product)
                print(product.localizedTitle, product.price, product.priceLocale, product.localizedDescription)
            }
            
        } else {
            print("아이템을 찾을 수 없다")
        }
    }
    
    
}


//SKPaymentTransactionObserver: 구매 취소, 승인등에 대해서 처리할 수 있게 도와주는 프로토콜
extension InAppViewController: SKPaymentTransactionObserver {
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased: //구매 승인 이후에 영수증 검증
                print("Transaction Approved. \(transaction.payment.productIdentifier)")
                
                receiptValidation(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
                
            case .failed: //실패 토스트, product 변수 값 초기화
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction) // 구매항목에서 제거
            @unknown default:
                break
            }
            
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("removedTransaction")
    }
    
}
