//
//  ReportCompletedVC.swift
//  EightFront
//
//  Created by wargi on 2022/10/10.
//

import Then
import SnapKit
import UIKit
import Combine

//MARK: ReportCompletedVC
final class ReportCompletedVC: UIViewController {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let type: ReportViewModel.ReportType
    let titleLabel = UILabel().then {
        $0.textColor = Colors.gray001.color
        $0.textAlignment = .center
        $0.font = Fonts.Templates.headline.font
    }
    let subTitleLabel = UILabel().then {
        $0.textColor = Colors.gray005.color
        $0.textAlignment = .center
        $0.font = Fonts.Templates.subheader.font
    }
    let completedButton = UIButton().then {
        $0.setImage(Images.Report.checkComplete.image)
        $0.backgroundColor = Colors.gray001.color
        $0.layer.cornerRadius = 39
    }
    let returnButton = UIButton().then {
        $0.setTitle("돌아가기")
        $0.setTitleColor(Colors.point.color)
        $0.titleLabel?.font = Fonts.Templates.subheader.font
        $0.layer.backgroundColor = Colors.gray002.color.cgColor
        $0.layer.cornerRadius = 4
    }
    
    //MARK: - Life Cycle
    init(type: ReportViewModel.ReportType) {
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
        configure()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(returnButton)
        view.addSubview(completedButton)
        
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        completedButton.snp.makeConstraints {
            $0.size.equalTo(78)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-24)
        }
        returnButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(58)
        }
    }
    
    //MARK: - Rx Binding..
    private func bind() {
        returnButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                switch self?.type {
                case .report:
                    if let vc = self?.navigationController?.viewControllers[1] {
                        self?.navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                    self?.navigationController?.popToRootViewController(animated: true)
                default:
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
            .store(in: &bag)
    }
    
    private func configure() {
        switch type {
        case .new:
            titleLabel.text = "신규 등록이 접수됐어요!"
            subTitleLabel.isHidden = true
        case .update:
            titleLabel.text = "수정 요청이 접수됐어요!"
            subTitleLabel.text = "N건 이상 접수된 건은 수정 완료 처리됩니다."
        case .delete:
            titleLabel.text = "삭제 요청이 접수됐어요!"
            subTitleLabel.text = "N건 이상 접수된 건은 삭제 완료 처리됩니다."
        case .report:
            titleLabel.text = "신고 완료 되었어요!"
            subTitleLabel.isHidden = true
        }
    }
}
