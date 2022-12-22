//
//  MyInfoVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/06.
//

import UIKit

import Combine
import Moya
import KakaoSDKUser
import JWTDecode
import Kingfisher

import AVFoundation
import Photos

protocol UserInfoReloadDelegate: AnyObject {
    func userInfoReload()
}

class MyInfoVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: UserInfoReloadDelegate?
    
    private let authProvider = MoyaProvider<AuthAPI>()
    private let viewModel = MyInfoViewModel()
    
    let photo = UIImagePickerController()
    
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "내 정보 수정"
    }
    
    private let myInfoView = UIView()
    private let profileImageView = UIView().then {
        $0.backgroundColor = Colors.gray007.color
        $0.layer.cornerRadius = 109/2
    }
    
    private let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let editImageView = UIView()
    private let editImage = UIImageView().then {
        let image = Images.Mypage.myInfoEdit.image
        $0.image = image
        $0.layer.cornerRadius = 29/2
    }
    
    private let emailTitleLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = Fonts.Templates.subheader3.font
    }
    
    private let emailLabel = UILabel().then {
        $0.font = Fonts.Templates.body1.font
    }
    
    // 닉네임
    private let nicknameTitleLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = Fonts.Templates.subheader3.font
    }
    
    private var nicknameTextField = CommonTextFieldView(isTitleHidden: true, placeholder: "15자 이내의 닉네임을 입력해주세요.")
    
    private var nicknameDuplicatedLabel = UILabel().then {
        $0.font = Fonts.Templates.caption2.font
    }
    
    private var nicknameCheckButtonView = UIView().then {
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 4
    }
    private var nicknameCheckButtonLabel = UILabel().then {
        $0.text = "확인"
        $0.font = Fonts.Templates.body1.font
        $0.textColor = UIColor.white
    }
    
    // TODO: 비밀번호 변경
    
    private let passwordTitleLabel = UILabel().then {
        $0.text = "비밀번호 변경"
        $0.font = Fonts.Templates.subheader3.font
        $0.isHidden = true
    }
    
    private let passwordChangeButton = UIButton().then {
        $0.setTitle("변경")
        $0.layer.cornerRadius = 4
        $0.isHidden = true
    }
    
    // 현재 비밀번호
    // 새 비밀번호
    // 새 비밀번호 확인
    
    private var editButtonView = UIView().then {
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 4
    }
    private var editButtonLabel = UILabel().then {
        $0.text = "수정하기"
        $0.font = Fonts.Templates.body1.font
        $0.textColor = UIColor.white
    }
    
    private let resignButton = UILabel().then {
        $0.text = "회원탈퇴"
        $0.font = Fonts.Templates.caption1.font
    }
    
    private let resignButtonDivider = UIView().then {
        $0.backgroundColor = Colors.gray006.color
    }
    
    // MARK: - Lift Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.reqeustUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
        
        photo.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - makeUI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(47)
        }
        
        view.addSubview(myInfoView)
        myInfoView.snp.makeConstraints {
            $0.top.equalTo(commonNavigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(178)
            
            myInfoView.addSubview(profileImageView)
            profileImageView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(109)
                
                profileImageView.addSubview(profileImage)
                profileImage.snp.makeConstraints {
                    $0.center.equalToSuperview()
//                    $0.width.equalTo(57)
//                    $0.height.equalTo(68)
                    $0.size.equalTo(60)
                }
                
                profileImageView.addSubview(editImage)
                editImage.snp.makeConstraints {
                    $0.right.equalTo(profileImageView.snp.right).inset(1)
                    $0.bottom.equalTo(profileImageView.snp.bottom).inset(3)
                    $0.size.equalTo(29)
                }
            }
        }
        
        view.addSubview(emailTitleLabel)
        emailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(myInfoView.snp.bottom)
            $0.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(nicknameTitleLabel)
        nicknameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(8+64+16)
            $0.height.equalTo(46)
        }
        
        view.addSubview(nicknameDuplicatedLabel)
        nicknameDuplicatedLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(nicknameCheckButtonView)
        nicknameCheckButtonView.snp.makeConstraints {
            $0.centerY.equalTo(nicknameTextField.snp.centerY)
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(64)
            $0.height.equalTo(46)
            
            nicknameCheckButtonView.addSubview(nicknameCheckButtonLabel)
            nicknameCheckButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        view.addSubview(passwordTitleLabel)
        passwordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(42)
            $0.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(passwordChangeButton)
        passwordChangeButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(42)
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(46)
            $0.width.equalTo(62)
        }
        
        // 수정하기 버튼
        view.addSubview(editButtonView)
        editButtonView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(38)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(58)
            
            editButtonView.addSubview(editButtonLabel)
            editButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        view.addSubview(resignButton)
        resignButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        view.addSubview(resignButtonDivider)
        resignButtonDivider.snp.makeConstraints {
            $0.top.equalTo(resignButton.snp.bottom).offset(1)
            $0.centerX.equalTo(resignButton.snp.centerX)
            $0.height.equalTo(1)
            $0.width.equalTo(resignButton.snp.width)
        }
    }
    
    private func bind() {

        resignButton.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let resignVC = ResignVC()
                self?.navigationController?.pushViewController(resignVC, animated: true)
            }.store(in: &viewModel.bag)
        
        // 닉네임 입력
        nicknameTextField.contentTextField.textPublisher
            .compactMap { $0 }
            .sink { [weak self] in
                self?.viewModel.inputNickname = $0
            }
            .store(in: &viewModel.bag)
        
        viewModel.$isNicknameCheck
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isNicknameCheck in
                if isNicknameCheck {
                    self?.viewModel.isSignUpButtonValid = true
                    self?.nicknameDuplicatedLabel.textColor = .blue
                } else {
                    self?.viewModel.isSignUpButtonValid = false
                    self?.nicknameDuplicatedLabel.textColor = .red
                }
            }.store(in: &viewModel.bag)
        
        // 닉네임 중복 확인 눌렀을 때
        nicknameCheckButtonView.gesture()
            .sink { [weak self] _ in
                self?.viewModel.requestNickNameCheck()
            }.store(in: &viewModel.bag)

        
        viewModel.isNicknameValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.nicknameCheckButtonView.backgroundColor = $0 ? Colors.gray001.color : Colors.gray006.color
                self?.nicknameCheckButtonLabel.textColor = $0 ? Colors.point.color : UIColor.white
            }.store(in: &viewModel.bag)
        
        viewModel.$userEmail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.emailLabel.text = $0
            }.store(in: &viewModel.bag)
        
        viewModel.$profileImage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] imageName in
                if imageName == "" {
                    self?.profileImage.image = Images.dropIcon.image
                } else {
                    let imageURL = URL(string: imageName)
                    self?.profileImage.kf.setImage(with: imageURL)
                }
            }.store(in: &viewModel.bag)
        
        viewModel.$isSignUpButtonValid
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isButtonEnabled in
                self?.editButtonView.backgroundColor = isButtonEnabled ? Colors.gray001.color :Colors.gray006.color
                self?.editButtonLabel.textColor = isButtonEnabled ? Colors.point.color : UIColor.white
            }.store(in: &viewModel.bag)
        
        viewModel.$nicknameDuplicateText
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] label in
                self?.nicknameDuplicatedLabel.text = label
            }.store(in: &viewModel.bag)
        
        // 수정 버튼 눌렀을 때
        editButtonView.gesture()
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.viewModel.requestNicknameChange()
            }.store(in: &viewModel.bag)
        
        // 수정 성공적으로 끝났을 때
        viewModel.$isNickNameChanged
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] in
                if $0 {
                    self?.delegate?.userInfoReload()
                    self?.navigationController?.popViewController(animated: true)
                }
            }.store(in: &viewModel.bag)
        
        commonNavigationView.backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &viewModel.bag)
        
        profileImage.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let profileImageChangeVC = ProfileImageChangeVC()
                self?.navigationController?.pushViewController(profileImageChangeVC, animated: true)
                
//                let alertSheet = UIAlertController(title: "", message: "프로필 변경", preferredStyle: .actionSheet)
//                let customImage = UIAlertAction(title: "사진첩에서 가져오기", style: .default) { [weak self] _ in
//                    PHPhotoLibrary.requestAuthorization { status in
//                        switch status {
//                        case .authorized:
//                            self?.openPhoto()
//                        default:
//                            break
//                        }
//                    }
//
//                }
//                let defaultImage = UIAlertAction(title: "드랍 더 옷 이미지로 변경", style: .default) { _ in
//                    let profileImageChangeVC = ProfileImageChangeVC()
//                    self?.navigationController?.pushViewController(profileImageChangeVC, animated: true)
//                }
//                let cancelAciton = UIAlertAction(title: "취소", style: .cancel)
//                alertSheet.addAction(customImage)
//                alertSheet.addAction(defaultImage)
//                alertSheet.addAction(cancelAciton)
//                self?.present(alertSheet, animated: true)
            }.store(in: &viewModel.bag)
    }
    
    // MARK: - Configure
    
    // MARK: - Actions
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    // MARK: - Functions
    
    func openPhoto(){
        DispatchQueue.main.async {            
            self.photo.sourceType = .photoLibrary // 앨범 지정 실시
            self.photo.allowsEditing = false // 편집을 허용하지 않음
            self.present(self.photo, animated: false, completion: nil)
            // -----------------------------------------
        }
    }
}

extension MyInfoVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage] {
            print(img)
            dismiss(animated: true)
        }
    }
}
