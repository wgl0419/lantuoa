//
//  ToExamineDetailsFootView.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/7/1.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class ToExamineDetailsFootView: UIView {
    
    /// tableview
    private var tableView: UITableView!
    private var checkListData: [NotifyCheckListSmallData]!
    var data :[NotifyCheckListSmallData]? {
        didSet {
            if let data = data {
                checkListData = data
               tableView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         checkListData = [NotifyCheckListSmallData]()
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews(){
        
        tableView = UITableView(frame: .zero, style: .grouped).taxi.adhere(toSuperView: self) // tableview
            .taxi.layout(snapKitMaker: { (make) in
                make.left.right.top.bottom.equalToSuperview()
            })
            .taxi.config({ (tableView) in
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.estimatedRowHeight = 50
                tableView.sectionHeaderHeight = 0.01
                tableView.tableFooterView = UIView()
                tableView.backgroundColor = UIColor(hex: "#F3F3F3")
                tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.01))
                tableView.register(ToExamineImagesCell.self, forCellReuseIdentifier: "ToExamineImagesCell")
                tableView.register(ToExamineTitleCell.self, forCellReuseIdentifier: "ToExamineTitleCell")
                tableView.register(ToExamineEnclosureCell.self, forCellReuseIdentifier: "ToExamineEnclosureCell")

            })
    }
}

extension ToExamineDetailsFootView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return checkListData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkListData[section].fileArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let indexType = checkListData[section].type
        if indexType == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineImagesCell", for: indexPath) as! ToExamineImagesCell
            cell.isApproval = true
            cell.datas = checkListData[section].fileArr
            cell.isComment = false
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToExamineEnclosureCell", for: indexPath) as! ToExamineEnclosureCell
            cell.data = checkListData[section].fileArr[row]
            cell.isDelete = false
            cell.isComment = false
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let tit = UILabel()
        view.addSubview(tit)
        tit.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.bottom.trailing.equalToSuperview()
        }
        tit.textColor = UIColor(hex: "#999999")
        tit.font = UIFont.medium(size: 14)
        tit.text = data![section].title
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

