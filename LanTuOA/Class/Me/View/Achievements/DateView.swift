//
//  DateView.swift
//  LanTuOA
//
//  Created by panzhijing on 2019/6/20.
//  Copyright © 2019 广西蛋卷科技有限公司. All rights reserved.
//

import UIKit

class DateView: UIView {
    var backDate: ((String,String) -> Void)?
    ///获取当前日期
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day ,.hour,.minute],   from: Date())    //日期类型
    var picker: UIPickerView!
    let backView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor(red: CGFloat(0 / 255.0), green: CGFloat(0 / 255.0), blue: CGFloat(0 / 255.0), alpha: 0.3 / 1.0)
        layer.masksToBounds = true
        backView.backgroundColor = UIColor.white
        addSubview(backView)
        backView.frame = CGRect(x: 0, y: ScreenHeight-248, width: ScreenWidth, height: 248)
        
        //取消
        let cancel = UIButton(frame: CGRect(x: 0, y: 10, width: 70, height: 40))
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor(hex: "#666666"), for: .normal)
        cancel.addTarget(self, action: #selector(self.onClickCancel), for: .touchUpInside)
        backView.addSubview(cancel)
        //确定
        let sure = UIButton(frame: CGRect(x: ScreenWidth - 80, y: 10, width: 70, height: 40))
        sure.setTitle("确认", for: .normal)
        sure.setTitleColor(UIColor(hex: "#2E4695"), for: .normal)
        sure.addTarget(self, action: #selector(self.onClickSure), for: .touchUpInside)
        sure.tag = 55
        backView.addSubview(sure)
        //PickerView
        picker = UIPickerView(frame: CGRect(x: 0, y: 50, width: ScreenWidth, height: 150))
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.clear
        picker.clipsToBounds = true//如果子视图的范围超出了父视图的边界，那么超出的部分就会被裁剪掉。
        picker.reloadAllComponents()
        picker.selectRow(2, inComponent: 0, animated: true)
        picker.selectRow((self.currentDateCom.month!) - 1, inComponent: 1, animated:  true)
//        picker.selectRow((self.currentDateCom.day!) - 1, inComponent: 2, animated: true)
        //创建日期选择器
        backView.addSubview(picker)

        
    }
    
    //MARK: 取消按钮
    @objc func onClickCancel() {
        self.removeFromSuperview()
    }
    //MARK: 确定按钮
    @objc func onClickSure() {
//        let dateString = String(format: "%02ld%02ld", self.picker.selectedRow(inComponent: 0) + (self.currentDateCom.year! - 2),self.picker.selectedRow(inComponent: 1) + 1 )
        let dateString = String(format: "%02ld", self.picker.selectedRow(inComponent: 0) + (self.currentDateCom.year! - 2))
        let moth = String(format:"%02ld",self.picker.selectedRow(inComponent: 1) + 1)
        /// 直接回调显示
        if self.backDate != nil{
            self.backDate!(dateString,moth)
        }
        self.removeFromSuperview()
    }
    ///点击任意位置view消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.removeFromSuperview()
    }
    
}

//MARK: - PickerViewDelegate
extension DateView:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return 3
            }else {
                return self.currentDateCom.month!
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 70
     }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
            var pickerLabel = view as? UILabel
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont.systemFont(ofSize: 16)
                pickerLabel?.tag = component
                pickerLabel?.textAlignment = .center
            }
            if component == 0 {
                pickerLabel?.text = "\((currentDateCom.year!-2) + row )年"
            }else {
                pickerLabel?.text = "\(row + 1)月"
            }
            pickerLabel?.textColor = UIColor(hex: "#333333")
            return pickerLabel!

        
    }
    
}

