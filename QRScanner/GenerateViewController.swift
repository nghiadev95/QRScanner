//
//  GenerateViewController.swift
//  QRScanner
//
//  Created by Nghia Nguyen on 6/16/18.
//  Copyright © 2018 Nghia Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes_Swift
import CZPicker

class GenerateViewController: UIViewController {
    
    @IBOutlet weak var tfContent: UITextField!
    @IBOutlet weak var btnChangeType: UIButton!
    @IBOutlet weak var imgGenerateResult: UIImageView!
    
    let typesSupported = UtilsFunction.getListObjectTypeSupported()
    var seletectedType = AVMetadataObject.ObjectType.qr
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBtnChangeTypeTitle(title: UtilsFunction.getObjectTypeName(type: seletectedType))
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setBtnChangeTypeTitle(title: String) {
        btnChangeType.setTitle(title, for: .normal)
    }
    
    @IBAction func btnChangeTypePressed(_ sender: Any) {
        guard let picker = CZPickerView(headerTitle: "Type", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm") else {
            return
        }
        picker.delegate = self
        picker.dataSource = self
        picker.needFooterView = false
        picker.show()
    }
    
    @IBAction func btnGeneratePressed(_ sender: Any) {
        guard let input = tfContent.text, !input.isEmpty else {
            return
        }
        let result = RSUnifiedCodeGenerator.shared.generateCode(input, machineReadableCodeObjectType: seletectedType.rawValue)
        if result != nil {
            imgGenerateResult.image = RSAbstractCodeGenerator.resizeImage(result!, targetSize: imgGenerateResult.frame.size, contentMode: .scaleAspectFill)
        }
    }
    
    @IBAction func btnSharePressed(_ sender: Any) {
    
    }
}

extension GenerateViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return typesSupported.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return UtilsFunction.getObjectTypeName(type: typesSupported[row]) 
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        seletectedType = typesSupported[row]
        setBtnChangeTypeTitle(title: UtilsFunction.getObjectTypeName(type: seletectedType))
    }
}
