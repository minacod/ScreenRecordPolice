//
//  TableViewControler.swift
//  ScreenRecordPolice
//
//  Created by Mina Abdelfady on 7/22/20.
//  Copyright © 2020 Shafy. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa


class TableViewController: UIViewController ,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSrc :[String] = ["","","","","","","","","","","",""]
    let data : BehaviorRelay<[String]> = BehaviorRelay(value: ["","","","","","","","","","","",""])
    lazy var inputData = Observable.just(dataSrc)
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setContentOffset(CGPoint(x: 0, y: -1), animated: true)
        setupTableView()
        setupCartObserver()
        setupCellConfiguration()
    }
    
    func setupTableView () {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: String(describing: TableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TableCell.self))
    }
    func setupCartObserver() {
      //1
      data.asObservable()
        .subscribe(onNext: { //2
          [unowned self] data in
            self.dataSrc = data
        })
        .disposed(by: disposeBag) //3
    }

    func setupCellConfiguration() {
      //1
      inputData
        .bind(to: tableView
          .rx //2
          .items(cellIdentifier: String(describing: TableCell.self),
                 cellType: TableCell.self)) { //3
                  row, str, cell in
                    cell.initCell(str: str)
                    cell.textField.rx.controlEvent(.editingDidEnd)
                        .withLatestFrom(cell.textField.rx.text.orEmpty)
                        .subscribe(onNext: { [unowned self] text in
                            cell.label?.text = text
                            self.dataSrc[row] = text
                    })
                        .disposed(by: self.disposeBag)
        }
        .disposed(by: disposeBag) //5
    }
}
extension TableViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableCell.self), for: indexPath) as! TableCell
        
        return cell
    }
}
