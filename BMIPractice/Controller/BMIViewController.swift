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
    @IBOutlet weak var resetBmiButton: UIButton!
    
    var allBmiCount: Int = UserDefaults.standard.integer(forKey: "bmiHistory")
    var userHistory: [Any] = []
    var nickName: String = ""
    var lastBmiInfo: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if allBmiCount == 0 {
            nickName = "Man_1"
        } else {
            nickName = "Man_\(Int.random(in: 2...10))"
        }
                
        // user의 BMI데이터 내역 조회
        if let history = UserDefaults.standard.array(forKey: "\(nickName)History") {
            userHistory = history
        } else {
            userHistory = []
        }
        
        // 페이지 로드
        setStaticContents()
        setDynamicContents()
    }
    
//    func setErrorPage() {
//        setTitleLabelUI(pageTitleLabel, text: "BMI Calculator",
//                        bold: true, align: .left, color: .black, lineNumber: 1)
//        setTitleLabelUI(pageDescLabel, text: "에러가 발생했습니다. 관리자에게 문의하세요",
//                        bold: true, align: .left, color: .red, lineNumber: 0)
//        view.viewWithTag(1)?.alpha = 0
//        view.viewWithTag(2)?.alpha = 0
//        caculateButton.alpha = 0
//    }
    
    func setStaticContents() {
            
        setTitleLabelUI(pageTitleLabel, text: "BMI Calculator",
                        bold: true, align: .left, color: .black, lineNumber: 1)
        setTitleLabelUI(pageDescLabel, text: "\(nickName)님의 BMI지수를 알려드릴게요",
                        bold: false, align: .left, color: .black, lineNumber: 0)
        
        setTextFieldLabelUI(heightLabel, text: "")
        setTextFieldLabelUI(weightLabel, text: "")
        
        setTextFieldUI(heightTextField, placeholder: "키가 어떻게 되시나요?")
        setTextFieldUI(weightTextField, placeholder: "몸무게는 어떻게 되시나요?")
        
        setButtonUI(randomCaculateButton, text: "랜덤으로 BMI 계산하기", textColor: .purple)
        setButtonUI(caculateButton, text: "결과확인", textColor: .white,background: .purple )
        setButtonUI(resetBmiButton, text: "내역 초기화", textColor: .black, background: .lightGray)
        
        setTextFieldViewUI()
    }
    
    func setDynamicContents() {
        setTabGestureHideKeyboard()
        setButtonPushUpEvent(randomCaculateButton)
        setButtonPushUpEvent(caculateButton)
        setResetEvent(resetBmiButton)
        setTextFieldIsEditEvent(heightTextField)
        setTextFieldIsEditEvent(weightTextField)
    }

    func setTextFieldsUI() {
        heightTextField.layer.borderWidth = 1
        heightTextField.layer.borderColor = UIColor.black.cgColor
        
        weightTextField.layer.borderWidth = 1
        weightTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    func setTitleLabelUI(_ label: UILabel, text: String, bold: Bool, 
                         align: NSTextAlignment, color: UIColor, lineNumber: Int ) {
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
       // label.frame.size = CGSize(width: 140, height: heightLabel.frame.height)
    }
    
    func setTextFieldUI(_ textField: UITextField, placeholder: String) {
        textField.heightAnchor.constraint(equalToConstant: textField.frame.height * 1.4)
            .isActive = true
        textField.borderStyle = .none
//        textField.setPlaceholder(color: .white)
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.black.cgColor
//        textField.layer.cornerRadius = textField.frame.height * 0.4
        
        // 사용자의 기존 이력 있을 시 텍스트 필드의 placeholder로 노출
        guard let lastInex = userHistory.last,
              let lastBmiData = UserDefaults.standard.dictionary(forKey: "\(lastInex)") else {
            return
        }
        
        // 마지막 내역이 삭제처리된 경우 예외처리
        guard let available = lastBmiData["available"] else {
            textField.placeholder = placeholder
            return
        }
        if String(describing: available) == "F" {
            textField.placeholder = placeholder
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let numberFomatter = NumberFormatter()
        numberFomatter.roundingMode = .down // 형식을 버림으로 지정
        numberFomatter.maximumSignificantDigits = 2 //
        
        var lastDateStr = String(describing: lastBmiData["date"] ?? "")
        let now = Date()
        
        print(now)
        print(lastDateStr)
        guard let lastDate = dateFormatter.date(from: lastDateStr) else {
            textField.placeholder = placeholder
            return
        }
        
        let daysAgo = now.timeIntervalSince(lastDate)
        
        var lastbmiStr = ""
        if daysAgo < 60 {
            guard let seconds = numberFomatter.string(for:daysAgo) else {return}
            lastbmiStr = "\(seconds)초 전"
        } else if daysAgo < (60 * 60) {
            guard let minutes = numberFomatter.string(for:daysAgo/60) else {return}
            lastbmiStr = "\(minutes)분 전"
        } else if daysAgo < (60 * 60 * 24) {
            guard let hours = numberFomatter.string(for:daysAgo/60/60) else {return}
            lastbmiStr = "\(hours))시간 전"
        } else {
            guard let days = numberFomatter.string(for:daysAgo/60/60/24) else {return}
            lastbmiStr = "\(days)일 전"
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        lastDateStr = dateFormatter.string(from: lastDate)
        
        lastBmiInfo["BMI"] = String(describing: lastBmiData["BMI"] ?? "0")
        lastBmiInfo["height"] = "\(lastBmiData["height"] ?? "")cm (\(lastbmiStr))"
        lastBmiInfo["weight"] = "\(lastBmiData["weight"] ?? "")kg (\(lastbmiStr))"
            
        switch textField.tag {
        case 0: textField.placeholder = lastBmiInfo["height"]
        case 1: textField.placeholder = lastBmiInfo["weight"]
        default: textField.placeholder = ""
        }
        
        pageDescLabel.text = "\(nickName)님의\n최근 BMI 지수:  \(String(lastBmiInfo["BMI"] ?? "0"))"
        pageDescLabel.font = UIFont.systemFont(ofSize: 20)
             
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
    
    func setResetEvent(_ button: UIButton) {
        button.addTarget(self, action: #selector(resetBmi), for: .touchUpInside)
    }
    
    func setTextFieldIsEditEvent(_ sender: UITextField) {
        sender.delegate = self
    }

    func checkTextInput() -> [String] {
        
        guard let height = heightTextField.text,
              let weight = weightTextField.text else {
            return ["nil","nil"]
        }
        
        if height.count <= 2 || weight.count < 2 {
            return ["nil", "nil"]
        }
        
        if height.allSatisfy({ $0.isNumber }) && weight.allSatisfy({ $0.isNumber }) {
            return [height.replacing(" ", with: ""),
                    weight.replacing(" ", with: "")]
        } else {
           return ["nil","nil"]
        }
    }
    
    func calculateBMI(height: Double, weight:  Double) -> String{
        var bmi: String
        
        let numberFomatter = NumberFormatter()
        numberFomatter.roundingMode = .floor // 형식을 버림으로 지정
        numberFomatter.maximumSignificantDigits = 3 // 자르길 원하는 자릿수
        
        bmi = numberFomatter.string(for: weight/(height * height) * 10000) ?? "0"
        
        return bmi
        
    }
        
    func getBMIData(senderTag: Int) -> [String:String] {
        var bmiData:[String:String] = [:]
        var heightWeight: [String] = []
        
  
        if senderTag == 1 {
            heightWeight.append(String(Double.random(in: 100.0 ... 200.0)))
            heightWeight.append( String(Double.random(in: 20.0 ... 150.0)))
                         
            bmiData["BMI"] = calculateBMI(height: Double(heightWeight[0]) ?? 0,
                               weight: Double(heightWeight[1]) ?? 0)
        } else if senderTag == 0 {
            heightWeight = checkTextInput()
            if heightWeight.first != "nil" && heightWeight.last != "nil" {
                bmiData["BMI"] = calculateBMI(height: Double(heightWeight.first ?? "0") ?? 0,
                                              weight: Double(heightWeight.last ?? "0") ?? 0)
            }
        }
        
        let date = Date()
        let dateFormatter = DateFormatter() // 인스턴스 생성
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if bmiData.keys.contains("BMI") {
            bmiData.updateValue("T", forKey: "available")
            bmiData.updateValue(heightWeight.first ?? "0", forKey: "height")
            bmiData.updateValue(heightWeight.last ?? "0", forKey: "weight")
            bmiData.updateValue(dateFormatter.string(from: date), forKey: "date")
        }
        
        return bmiData
    }
    
    
    @objc func buttonPushUp(_ sender: UIButton) {
        let alertMessage: (String, String)
        
        let bmiData = getBMIData(senderTag: sender.tag)
        
        let BMI = Double(bmiData["BMI"] ?? "0") ?? 0
        
        switch BMI {
        case 0.01...18.5: alertMessage = ("저체중", "BMI 지수 \(BMI)")
        case 18.6...23: alertMessage = ("정상", "BMI 지수 \(BMI)")
        case 23.1...25: alertMessage = ("과체중", "BMI 지수 \(BMI)")
        case 25.1...: alertMessage = ("비만", "BMI 지수, \(BMI)")
        default: alertMessage = ("오류","올바른 키와 몸무게를 입력하세요!")
        }
        
        if alertMessage.0 != "오류" {
            allBmiCount += 1
            let newBmiIndex = allBmiCount
            userHistory.append(newBmiIndex)
            print("누적 BMI 측정 회수: \(newBmiIndex)")
            print("\(nickName)의 측정 내역:\n\(userHistory)")
            print("현재 측정한 BMI기록:\n\(bmiData)")
            
            UserDefaults.standard.set(newBmiIndex, forKey: "bmiHistory")
            UserDefaults.standard.set(userHistory, forKey: "\(nickName)History")
            UserDefaults.standard.set(bmiData, forKey: String(newBmiIndex))
            
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
        let tapGesture = UITapGestureRecognizer(target: self, 
                                                action: #selector(self.hideKeyboard))
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
            weightTextField.placeholder = "몸무게는 어떻게 되시나요?"
            sender.placeholder = lastBmiInfo["height"]
        } else {
            sender.resignFirstResponder()
            sender.placeholder = "키가 어떻게 되시나요?"
            weightTextField.placeholder = lastBmiInfo["weight"]
        }
        
        return true
    }
    
    @objc func resetBmi() {
        guard let lastBmiIndex = userHistory.last,
              let lastBmiData = UserDefaults.standard.dictionary(forKey: "\(lastBmiIndex)")
        else {
            let alert = UIAlertController(title: "오류",
                                          message: "삭제할 측정내역이 없습니다.",
                                          preferredStyle: .alert)
            let cancle = UIAlertAction(title: "확인",
                                       style: .cancel)
            alert.addAction(cancle)
            present(alert, animated: true)
            
            return
        }
        
        guard let available = lastBmiData["available"] else {
            return
        }
        
        if String(describing: available) == "F" {
            let alert = UIAlertController(title: "오류",
                                          message: "삭제할 측정내역이 없습니다.",
                                          preferredStyle: .alert)
            let cancle = UIAlertAction(title: "확인",
                                       style: .cancel)
            alert.addAction(cancle)
            present(alert, animated: true)
            return
        }
        
        var deleteData = lastBmiData
        deleteData.updateValue("F", forKey: "available")
        UserDefaults.standard.set(deleteData, forKey: "\(lastBmiIndex)")
        
        heightTextField.text = ""
        weightTextField.text = ""
        
        let alert = UIAlertController(title: "리셋완료",
                                      message: "가장 최근의 BMI 내역이 삭제되었습니다.",
                                      preferredStyle: .alert)
        let cancle = UIAlertAction(title: "확인",
                                   style: .cancel)
        alert.addAction(cancle)
        present(alert, animated: true)
    }
    
    @IBAction func textFieldClicked(_ sender: UITextField) {
        if sender.tag == 0 {
            sender.placeholder = "키가 어떻게 되시나요?"
            weightTextField.placeholder = lastBmiInfo["weight"]
        } else if sender.tag == 1 {
            sender.placeholder = "몸무게는 어떻게 되시나요?"
            heightTextField.placeholder = lastBmiInfo["height"]
        }
    
    }
}


//extension UITextField {
//    func setPlaceholder(color: UIColor) {
//        guard let string = self.placeholder else {
//            return
//        }
//        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
//    }
//}
