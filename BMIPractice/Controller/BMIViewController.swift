//
//  BMIViewController.swift
//  BMIPractice
//
//  Created by 유철원 on 5/21/24.
//

import UIKit

class BMIViewController: UIViewController, UITextFieldDelegate {
    
    
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
        heightTextField.delegate = self
        weightTextField.delegate = self
        
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
        setTabGestureHideKeyboard()
        setButtonPushUpEvent(randomCaculateButton)
        setButtonPushUpEvent(caculateButton)
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
        button.tag = 1
    }
    
    func setButtonUI(_ button: UIButton, text: String, textColor: UIColor, background color: UIColor) {
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = color
        button.heightAnchor.constraint(equalToConstant: button.frame.height * 1.4).isActive = true
        button.layer.cornerRadius = button.frame.height * 0.3
        button.addTarget(self, action: #selector(buttonPushUp), for: .touchUpInside)
        button.tag = 0
    }
    
    func setTextFieldViewUI() {
        let sumHeights = weightLabel.frame.height + weightTextField.frame.height
                        + randomCaculateButton.frame.height
        
        view.viewWithTag(2)?.heightAnchor.constraint(equalToConstant: sumHeights + 2 + 5).isActive = true
    }
    
    func setButtonPushUpEvent(_ button: UIButton) {
        button.addTarget(self, action: #selector(buttonPushUp), for: .touchUpInside)
    }
    

    func checkTextInput() -> (String, String) {
        var height: String = ""
        var weight: String = ""
    
        height = heightTextField.text ?? ""
        weight = weightTextField.text ?? ""
        
    
        if height.allSatisfy({ $0.isNumber }) && weight.allSatisfy({ $0.isNumber }) {
            height = height.replacing(" ", with: "")
            weight = weight.replacing(" ", with: "")
        } else {
            height = "nil"
            weight = "nil"
        }
    
        return (height, weight)
    }
    
    func calculateBMI(height: Double, weight:  Double) -> Double{
        var bmi = weight/(height * height) * 10000
        
        let numberFomatter = NumberFormatter()
        numberFomatter.roundingMode = .floor // 형식을 버림으로 지정
        numberFomatter.maximumSignificantDigits = 3  // 자르길 원하는 자릿수
        
        bmi = Double(numberFomatter.string(for: bmi) ?? "0") ?? 0
        
        return bmi
        
    }
        
    func getBMI(senderTag: Int) -> Double {
        var bmi: Double = 0
        
        if senderTag == 1 {
            bmi = calculateBMI(height: Double.random(in: 100.0 ... 200.0),
                              weight: Double.random(in: 20.0 ... 150.0))
        } else if senderTag == 0 {
            var heightWeight = checkTextInput()
            if heightWeight.0 != "nil" && heightWeight.1 != "nil" {
                bmi = calculateBMI(height: Double(heightWeight.0) ?? 0,
                                   weight: Double(heightWeight.1) ?? 0)
            }
        }
        
        return bmi
    }

    @objc func buttonPushUp(_ sender: UIButton) {
        let alertMessage: (String, String)
        let BMI = getBMI(senderTag: sender.tag)
        
        print(BMI)
        
        switch BMI {
        case 0.1...18.5: alertMessage = ("저체중", "BMI 지수 \(BMI)")
        case 18.6...23: alertMessage = ("정상", "BMI 지수 \(BMI)")
        case 23.1...25: alertMessage = ("과체중", "BMI 지수 \(BMI)")
        case 25.1...: alertMessage = ("비만", "BMI 지수, \(BMI)")
        default: alertMessage = ("오류","올바른 키와 몸무게를 입력하세요!")
        }
        
        let alert = UIAlertController(title: alertMessage.0,
                                      message: alertMessage.1,
                                      preferredStyle: .alert)
        let cancle = UIAlertAction(title: "확인",
                                   style: .cancel)
        
        alert.addAction(cancle)
        
        present(alert, animated: true)
    }
    
    
    func setTabGestureHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
    
    
    func textFieldShouldReturn(_ sender: UITextField) -> Bool {
        if sender == heightTextField {
            weightTextField.becomeFirstResponder()
        } else {
            sender.resignFirstResponder()
        }
        
        return true
    }
        

            
}
