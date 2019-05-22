//
//  SeleEnclosureController.swift
//  LanTuOA
//
//  Created by HYH on 2019/5/21.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//  选择附件  控制器

import UIKit

class SeleEnclosureController: UIViewController {

    /// 确认回调
    var determineBlock: (([String]) -> ())?
    
    /// tableview
    private var tableView: UITableView!
    /// 确定按钮
    private var determineBtn: UIButton!
    /// 已选
    private var selectedLabel: UILabel!
    
    /// 文件名称
    private var nameArray = [String]()
    /// 选中位置
    private var selectedIndexs = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        getName()
    }

    // MARK: - 自定义私有方法
    /// 初始化子控件
    private func initSubViews() {
        title = "选择附件"
        view.backgroundColor = .white
        
        determineBtn = UIButton().taxi.adhere(toSuperView: view) // 确定按钮
            .taxi.layout(snapKitMaker: { (make) in
                make.height.equalTo(44)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().offset(-30)
                make.bottom.equalToSuperview().offset(isIphoneX ? -SafeH : -18)
            })
            .taxi.config({ (btn) in
                btn.isEnabled = false
                btn.setTitleColor(.white, for: .normal)
                btn.setTitle("确定", for: .normal)
                btn.backgroundColor = UIColor(hex: "#CCCCCC")
                btn.addTarget(self, action: #selector(determineClick), for: .touchUpInside)
            })
        
        tableView = UITableView().taxi.adhere(toSuperView: view) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(determineBtn.snp.top).offset(-18)
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.estimatedRowHeight = 50
                tableView.tableFooterView = UIView()
                tableView.register(SelePersonnelCell.self, forCellReuseIdentifier: "SelePersonnelCell")
            })
        
    }
    
    /// 获取文件名称
    private func getName() {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let enclosurePath = cachePath! + ("/enclosure")
        let fileArr = FileManager.default.subpaths(atPath: enclosurePath)
        if fileArr != nil {
            for file in fileArr! {
                nameArray.append(file)
            }
        }
        tableView.reloadData()
    }
    
    /// 初始化顶部视图
    private func initHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 37))
        headerView.backgroundColor = UIColor(hex: "#F3F3F3")

        selectedLabel = UILabel().taxi.adhere(toSuperView: headerView) // 已选
            .taxi.layout(snapKitMaker: { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .taxi.config({ (label) in
                label.text = "已选 \(selectedIndexs.count)/\(nameArray.count)"
                label.textColor = UIColor(hex: "#999999")
                label.font = UIFont.boldSystemFont(ofSize: 12)
            })
        
        return headerView
    }
    
    /// 多选处理
    ///
    /// - Parameter row: 点击的行数
    private func multipleHandle(row: Int) {
        var seleIndex = -1 // 选择位置
        for index in 0..<selectedIndexs.count {
            let selectedindex = selectedIndexs[index]
            if selectedindex == row {
                seleIndex = index
                break
            }
        }
        if seleIndex == -1 { // 之前没有勾选
            selectedIndexs.append(row)
        } else { // 之前有勾选
            selectedIndexs.remove(at: seleIndex)
        }
        selectedLabel.text = "已选 \(selectedIndexs.count)/\(nameArray.count)"
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
    }
    
    // MARK: - 按钮点击
    /// 点击确定
    @objc private func determineClick() {
        var fileArray = [String]()
        for row in selectedIndexs {
            fileArray.append(nameArray[row])
        }
        if determineBlock != nil {
            determineBlock!(fileArray)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension SeleEnclosureController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelePersonnelCell", for: indexPath) as! SelePersonnelCell
        var isSele = false
        for index in 0..<selectedIndexs.count {
            let selectedindex = selectedIndexs[index]
            if selectedindex == indexPath.row {
                isSele = true
                break
            }
        }
        cell.data = (nameArray[indexPath.row], "", isSele)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return initHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        multipleHandle(row: row)
        
        determineBtn.isEnabled = selectedIndexs.count > 0 // 处理按钮可否点击
        determineBtn.backgroundColor = selectedIndexs.count > 0 ? UIColor(hex: "#2E4695") : UIColor(hex: "#999999")
    }
}
