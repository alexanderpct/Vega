//
//  PickTableViewCell.swift
//  Vega
//
//  Created by Peter Kvasnikov on 09.03.2021.
//

import UIKit

protocol CheckOptionsDelegate: AnyObject {
    func didChecked(checkedCond: Int)
}

class PickTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var pickerData = ["Один", "Два", "Три"]
    
    weak var checkOptionsDelegate: CheckOptionsDelegate?
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Условие:"
        return label
    }()
    
    let picker = UIPickerView()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isUserInteractionEnabled = true
        tf.allowsEditingTextAttributes = false
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        picker.delegate = self
        picker.dataSource = self
        
        contentView.addSubview(textField)
        textField.inputView = picker
        
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        label.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        textField.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = pickerData[row]
        checkOptionsDelegate?.didChecked(checkedCond: row)
        
        
    }
    
    func configure(checkType: CheckType, checkedCond: Int) {
        let timeTitles = ["не выбрано", "до", "после", "равно"]
        let ratingTitles = ["не выбрано", "меньше", "больше", "равно"]
        
        if checkType == .publicationDate || checkType == .uploadTime {
            pickerData = timeTitles
        } else {
            pickerData = ratingTitles
        }
        
        picker.reloadAllComponents()
        
        switch checkedCond {
        case 0: picker.selectRow(0, inComponent: 0, animated: true)
            picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        case 1: picker.selectRow(1, inComponent: 0, animated: true)
            picker.delegate?.pickerView?(picker, didSelectRow: 1, inComponent: 0)
        case 2: picker.selectRow(2, inComponent: 0, animated: true)
            picker.delegate?.pickerView?(picker, didSelectRow: 2, inComponent: 0)
        case 3: picker.selectRow(3, inComponent: 0, animated: true)
            picker.delegate?.pickerView?(picker, didSelectRow: 3, inComponent: 0)
        default:picker.selectRow(0, inComponent: 0, animated: true)
            picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        }
        
    }
    
    
    
}
