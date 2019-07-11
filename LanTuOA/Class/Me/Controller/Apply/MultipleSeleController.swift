//
//  MultipleSeleController.swift
//  LanTuOA
//
//  Created by HYH on 2019/4/22.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  多选 控制器  -> 数据由上一层控制器提供

import UIKit

class MultipleSeleController: UIViewController {
    
    /// 选中数据回调
    var didBlock: (([String]) -> ())?
    /// 数据
    var contentArray: [String]! {
        didSet {
//
//            if let  contentArray = contentArray {
//                tableView.reloadData()
//            }
        }
    }

    /// tableview
    private var tableView: UITableView!
    /// 选择按钮
    private var determineBtn: UIButton!
    
    
    /// 选中的row
    private var selectedRows = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        
        let btnView = UIView().taxi.adhere(toSuperView: view) // 按钮背景框
            .taxi.layout { (make) in
                make.height.equalTo(62 + (isIphoneX ? SafeH : 18))
                make.left.right.bottom.equalToSuperview()
        }
        
        determineBtn = UIButton().taxi.adhere(toSuperView: btnView) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.width.equalToSuperview().offset(-30)
                make.top.equalToSuperview().offset(18)
                make.height.equalTo(44)
            })
            .taxi.config({ (btn) in
                btn.setTitle("选定", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = UIColor(hex: "#2E4695")
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(btnView.snp.top)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.register(SelePersonnelCell.self, forCellReuseIdentifier: "SelePersonnelCell")
            })
    }
    
    // MARK: - 按钮点击
    /// 点击确定
    @objc private func determineClick() {
        
        if didBlock != nil {
            var seleArray = [String]()
            for index in 0..<contentArray.count {
                for row in selectedRows {
                    if row == index {
                        let str = contentArray[index]
                        seleArray.append(str)
                    }
                }
               
            }
           didBlock!(seleArray)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension MultipleSeleController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelePersonnelCell", for: indexPath) as! SelePersonnelCell
        let row = indexPath.row
        var isSele = selectedRows.count != 0
        if isSele { // 有数据
            isSele = false
            for index in 0..<selectedRows.count {
                let selectedRow = selectedRows[index]
                if selectedRow == row {
                    isSele = true
                    break
                }
            }
        }
        cell.data = (contentArray[row], "", isSele)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        var isSele = false
        for index in (0..<selectedRows.count).reversed() {
            let selectedRow = selectedRows[index]
            if selectedRow == row {
                selectedRows.remove(at: index)
                isSele = true
                break
            }
        }
        if !isSele {
            selectedRows.append(row)
        }
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
        determineBtn.isEnabled = contentArray.count > 0 // 处理按钮可否点击
        determineBtn.backgroundColor = contentArray.count > 0 ? UIColor(hex: "#2E4695") : UIColor(hex: "#999999")
    }
}
