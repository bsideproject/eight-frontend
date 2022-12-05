//
//  ResignVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/19.
//

import UIKit
import JWTDecode
import Moya

class ResignVC: UIViewController {
    private let viewModel = ResignViewModel()
    
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "회원 탈퇴"
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "회원탈퇴 시 \n유의사항을 확인해주세요."
        $0.textColor = Colors.gray001.color
        $0.font = Fonts.Templates.subheader3.font
        $0.numberOfLines = 0
    }
    
    private let textView = UIView().then {
        $0.layer.cornerRadius = 6
        $0.backgroundColor = Colors.gray008.color
    }
    
    private let textStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalCentering
    }
    
    private let textViewLabel1 = UILabel().then {
        let style = NSMutableParagraphStyle()
        let lineheight = 22
        style.minimumLineHeight = CGFloat(lineheight)
        style.maximumLineHeight = CGFloat(lineheight)

        $0.attributedText = NSAttributedString(
          string: "사용하고 계신 아이디는 탈퇴할 경우 재사용 및 복구가 불가능 합니다.",
          attributes: [
            .paragraphStyle: style
          ])
        $0.font = Fonts.Templates.body1.font
        $0.textColor = Colors.gray002.color
        $0.numberOfLines = 0
    }
    
    private let textViewLabel2 = UILabel().then {
        let style = NSMutableParagraphStyle()
        let lineheight = 22
        style.minimumLineHeight = CGFloat(lineheight)
        style.maximumLineHeight = CGFloat(lineheight)

        $0.attributedText = NSAttributedString(
          string: "회원탈퇴 후 개인정보보호법에 의해 3개월동안 회원정보를 별도 보관하며, 3개월 이후 자동삭제됩니다. 보관된 회원 정보는 고객문의 외 다른 용도로 사용되지 않습니다.",
          attributes: [
            .paragraphStyle: style
          ])
        $0.font = Fonts.Templates.body1.font
        $0.textColor = Colors.gray002.color
        $0.numberOfLines = 0
    }
    
    private let textViewLabel3 = UILabel().then {
        let style = NSMutableParagraphStyle()
        let lineheight = 22
        style.minimumLineHeight = CGFloat(lineheight)
        style.maximumLineHeight = CGFloat(lineheight)

        $0.attributedText = NSAttributedString(
          string: "탈퇴 후 등록하셨던 영상, 게시글, 댓글은 자동으로 삭제됩니다.",
          attributes: [
            .paragraphStyle: style
          ])
        $0.font = Fonts.Templates.body1.font
        $0.textColor = Colors.gray002.color
        $0.numberOfLines = 0
    }
    
    private let confirmView = UIView()
    private let confirmCheckBox = UIButton().then {
        $0.setImage(Images.Report.checkboxSelect.image, for: .normal)
        $0.clipsToBounds = true
    }
    
    private let confirmLabel = UILabel().then {
        $0.text = "위 내용을 확인했으며, 탈퇴를 진행합니다."
        $0.font = Fonts.Templates.body1.font
    }

    // 탈퇴 버튼
    private let resignButtonView = UIView().then {
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 6
    }
    
    private let resignButtonLabel = UILabel().then {
        $0.text = "회원탈퇴"
        $0.font = Fonts.Templates.subheader.font
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
    }
    
    func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(commonNavigationView.snp.bottom).offset(26)
            $0.left.equalToSuperview().inset(16)
        }
        
        // 안내 사항
        
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(252)
        }
        
        let textViewLables = [textViewLabel1, textViewLabel2, textViewLabel3]
        textViewLables.forEach {
            textStackView.addArrangedSubview($0)
        }
        
        textView.addSubview(textStackView)
        textStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        // 회원 탈퇴 체크 박스 + 안내 문구
        view.addSubview(confirmView)
        confirmView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(18)
            
            confirmView.addSubview(confirmCheckBox)
            confirmCheckBox.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.size.equalTo(16)
            }
            
            confirmView.addSubview(confirmLabel)
            confirmLabel.snp.makeConstraints {
                $0.left.equalTo(confirmCheckBox.snp.right).offset(8)
                $0.centerY.equalToSuperview()
            }
        }
        
        
        // 회원탈퇴 버튼
        view.addSubview(resignButtonView)
        resignButtonView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(58)
            
            resignButtonView.addSubview(resignButtonLabel)
            resignButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
    }
    
    private func bind() {
        viewModel.$isChecked
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] in
                $0 ? self?.confirmCheckBox.setImage(Images.Report.checkboxSelect.image) : self?.confirmCheckBox.setImage(Images.Report.checkboxNone.image)
                self?.resignButtonView.backgroundColor = $0 ? Colors.gray001.color : Colors.gray006.color
                self?.resignButtonLabel.textColor = $0 ? Colors.point.color : .white
            }.store(in: &viewModel.bag)
        
        confirmView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.isChecked.toggle()
            }.store(in: &viewModel.bag)
        
        resignButtonView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.resign()
            }.store(in: &viewModel.bag)
        
        viewModel.$isResigned
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isResigned in
                if isResigned {
                    let tabbar = MainTabbarController()
                    let navi = CommonNavigationViewController(rootViewController: tabbar)
                    self?.view.window?.rootViewController = navi
                }
            }.store(in: &viewModel.bag)
        
        commonNavigationView.backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &viewModel.bag)
    }
}
