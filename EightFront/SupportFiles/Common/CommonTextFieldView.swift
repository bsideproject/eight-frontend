//
//  CommonTextFieldView.swift
//  EightFront
//
//  Created by wargi on 2022/10/09.
//

import Then
import SnapKit
import UIKit
import Combine
//MARK: CommonTextFieldView
final class CommonTextFieldView: UIView {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    var placeholder: String?
    let titleLabel = UILabel().then {
        $0.textColor = Colors.gray005.color
        $0.font = Fonts.Templates.subheader.font
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    let contentTextField = UITextField().then {
        $0.textColor = Colors.gray001.color
        $0.font = Fonts.Templates.subheader.font
        $0.smartDashesType = .no
        $0.smartQuotesType = .no
        $0.spellCheckingType = .no
        $0.autocorrectionType = .no
        $0.smartInsertDeleteType = .no
        $0.returnKeyType = .search
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    lazy var contentTextView = UITextView().then {
        $0.delegate = self
        $0.textColor = Colors.gray005.color
        $0.font = Fonts.Templates.subheader.font
    }
    
    //MARK: - Initializer
    init(isTitleHidden: Bool = false,                 // 타이틀 명
         isTextView: Bool = false,                    // TextView 표시 여부(기본: TextField)
         placeholder: String? = nil,                  // placeholder
         titleWidth: CGFloat = .zero,                 // 타이틀 크기 지정
         contentTrailing: CGFloat = 16.0) {           // text 입력 내용 표시 위치
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        
        makeUI(isTitleHidden: isTitleHidden,
               isTextView: isTextView,
               titleWidth: titleWidth,
               contentTrailing: contentTrailing)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI(isTitleHidden: Bool,
                        isTextView: Bool,
                        titleWidth: CGFloat,
                        contentTrailing: CGFloat) {
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        layer.borderColor = Colors.gray006.color.cgColor
        
        let attrString = NSAttributedString(string: placeholder ?? "",
                                            attributes: [.foregroundColor: Colors.gray005.color,
                                                         .font: Fonts.Pretendard.regular.font(size: 16)])
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(isTitleHidden ? 0 : 16)
            $0.width.equalTo(titleWidth)
        }
        
        if isTextView {
            addSubview(contentTextView)
            contentTextView.text = placeholder
            
            contentTextView.snp.makeConstraints {
                $0.top.right.equalToSuperview().inset(16)
                $0.left.equalToSuperview().offset(10)
                $0.bottom.equalToSuperview()
            }
        } else {
            addSubview(contentTextField)
            contentTextField.attributedPlaceholder = attrString
            
            contentTextField.snp.makeConstraints {
                $0.left.equalTo(titleLabel.snp.right).offset(16)
                $0.right.equalToSuperview().offset(-contentTrailing)
                $0.top.bottom.equalToSuperview()
            }
        }
    }
    
    private func bind() {
        contentTextField
            .controlEventPublisher(for: .editingDidEnd)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.layer.borderColor = Colors.gray006.color.cgColor
            }
            .store(in: &bag)
        
        contentTextField
            .didBeginEditingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.layer.borderColor = Colors.gray001.color.cgColor
            }
            .store(in: &bag)
    }
}

extension CommonTextFieldView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        layer.borderColor = Colors.gray001.color.cgColor
        
        guard textView.text == placeholder else { return }
        
        textView.text = ""
        textView.textColor = Colors.gray001.color
        textView.font = Fonts.Templates.subheader.font
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        layer.borderColor = Colors.gray006.color.cgColor
        
        guard textView.text.isEmpty else { return }
        
        textView.text = placeholder
        textView.textColor = Colors.gray006.color
        textView.font = Fonts.Templates.subheader.font
    }
}
