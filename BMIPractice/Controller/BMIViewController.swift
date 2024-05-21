//
//  BMIViewController.swift
//  BMIPractice
//
//  Created by 유철원 on 5/21/24.
//

import UIKit

class BMIViewController: UIViewController {
    
    
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var pageDescLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var randomCaculateButton: UIButton!
    @IBOutlet weak var caculateButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStaticContents()
        setDynamicContents()
    }
    
    func setStaticContents() {
        setImageConstraints()
        
        setTitleLabelUI(pageTitleLabel, text: "BMI Calculator",
                        bold: true, align: .left, color: .black, lineNumber: 1)
        setTitleLabelUI(pageDescLabel, text: "당신의 BMI지수를 알려드릴게요",
                        bold: false, align: .left, color: .black, lineNumber: 0)
        
        setTextFieldLabelUI(heightLabel, text: "키가 어떻게 되시나요?")
        setTextFieldLabelUI(weightLabel, text: "몸무게는 어떻게 되시나요?")
        
        setTextFieldUI(heightTextField)
        setTextFieldUI(weightTextField)
        
        setButtonUI(randomCaculateButton, text: "랜덤으로 BMI 계산하기", textColor: .red)
        setButtonUI(caculateButton, text: "결과확인", textColor: .white,background: .purple )
        
        setTextFieldViewUI()
        
    }
    
    func setDynamicContents() {
        
    }
    
    func setImageConstraints() {
        
    }

    func setTextFieldsUI() {
        heightTextField.layer.borderWidth = 1
        heightTextField.layer.borderColor = UIColor.black.cgColor
        
        weightTextField.layer.borderWidth = 1
        weightTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    func setTitleLabelUI(_ label: UILabel, text: String, bold: Bool, align: NSTextAlignment, color: UIColor, lineNumber: Int ) {
        label.text
        label.text = text
        label.textAlignment = align
        label.textColor = color
        label.numberOfLines = lineNumber
        if bold {
            label.font = UIFont.boldSystemFont(ofSize: 25)
        }
    }
    
    func setTextFieldLabelUI(_ label: UILabel, text: String) {
        label.text = text
        label.frame.size = CGSize(width: 140, height: heightLabel.frame.height)
    }
    
    func setTextFieldUI(_ textField: UITextField) {
        textField.heightAnchor.constraint(equalToConstant: textField.frame.height * 1.4)
            .isActive = true
        // 미적용
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = textField.frame.height * 0.4
    }
    
    func setButtonUI(_ button: UIButton, text: String, textColor: UIColor) {
        button.configuration = .none
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
    }
    
    func setButtonUI(_ button: UIButton, text: String, textColor: UIColor, background color: UIColor) {
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = color
        button.heightAnchor.constraint(equalToConstant: button.frame.height * 1.4).isActive = true
        button.layer.cornerRadius = button.frame.height * 0.3
    }
    
    func setTextFieldViewUI() {
        let sumHeights = weightLabel.frame.height + weightTextField.frame.height
                        + randomCaculateButton.frame.height
        
        view.viewWithTag(2)?.heightAnchor.constraint(equalToConstant: sumHeights + 2 + 5).isActive = true
    }

    func calculateBMI(height: Double, weight:  Double) -> Double{
        let result = weight/(height * height)
        
        return result.rounded()
    }

    @IBAction func buttonPushUp() {
        
    }

}
