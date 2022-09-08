//
//  ReportVC.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import Then
import SnapKit
import UIKit
import Combine
import CoreLocation
import AVFoundation
//MARK: HomeListVC
final class ReportVC: UIViewController {
    //MARK: - Properties
    private let viewModel = ReportViewModel()
    private var isDelete = false
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "지도정보수정"
    }
    private let searchImageView = UIImageView().then {
        $0.image = Images.Report.search.image
    }
    private lazy var addressView = CommonTextFieldView(titleWidth: 56.0,
                                                       contentTrailing: isDelete ? 16.0 : 52.0).then { [weak self] in
        $0.titleLabel.text = "주소"
        $0.contentTextField.isUserInteractionEnabled = false
    }
    private let detailView = CommonTextFieldView(titleWidth: 56.0).then {
        $0.titleLabel.text = "상세주소"
    }
    private let questionLabel = UILabel().then {
        $0.text = "요청 내용"
        $0.font = Fonts.Pretendard.semiBold.font(size: 16)
    }
    private let questionView = CommonTextFieldView(isTitleHidden: true,
                                                   isTextView: true,
                                                   placeholder: "추가 요청사항 혹은 문의사항을 남겨주세요.").then {
        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        $0.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    private let photoLabel = UILabel().then {
        $0.text = "사진 첨부"
        $0.font = Fonts.Pretendard.semiBold.font(size: 16)
    }
    lazy var addPhotoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        AddPhotoCollectionViewCell.register($0)
        PhotoCollectionViewCell.register($0)
    }
    private lazy var agreePhotoView = AgreePhotoView().then { [weak self] in
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.agreePhotoTapped))
        $0.addGestureRecognizer(tapGesture)
    }
    lazy var requestButton = UIButton().then { [weak self] in
        guard let self = self else { return }
        $0.setTitle(self.isDelete ? "삭제 요청하기" : "등록하기")
        $0.setTitleColor(.white)
        $0.titleLabel?.font = Fonts.Pretendard.regular.font(size: 16)
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 4
    }
    
    //MARK: - Life Cycle
    init(isDelete: Bool, location: CLLocation) {
        super.init(nibName: nil, bundle: nil)
        
        self.isDelete = isDelete
        viewModel.requestLocation = location
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(navigationView)
        view.addSubview(addressView)
        view.addSubview(searchImageView)
        view.addSubview(detailView)
        view.addSubview(questionLabel)
        view.addSubview(questionView)
        view.addSubview(photoLabel)
        view.addSubview(addPhotoCollectionView)
        view.addSubview(agreePhotoView)
        view.addSubview(requestButton)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(47)
        }
        addressView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(addressView.snp.centerY)
            $0.right.equalTo(addressView.snp.right).offset(-16)
            $0.size.equalTo(20)
        }
        detailView.snp.makeConstraints {
            $0.top.equalTo(addressView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(detailView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
        }
        questionView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
        }
        photoLabel.snp.makeConstraints {
            $0.top.equalTo(questionView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
        }
        addPhotoCollectionView.snp.makeConstraints {
            $0.top.equalTo(photoLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview()
            $0.height.equalTo(88)
        }
        requestButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(isDelete ? -24 : -38)
            $0.height.equalTo(58)
        }
        agreePhotoView.snp.makeConstraints {
            $0.top.equalTo(addPhotoCollectionView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(requestButton.snp.top).offset(-16)
            $0.height.equalTo(40)
        }
        
        searchImageView.isHidden = isDelete
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    //MARK: - Rx Binding..
    private func bind() {
        if !isDelete {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
            addressView.addGestureRecognizer(tapGesture)
        }
        
        viewModel.$addressString
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.text, on: addressView.contentTextField)
            .store(in: &viewModel.bag)
        navigationView.backButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.bag)
        viewModel
            .output
            .isRequest
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.requestButton.setTitleColor($0 ? Colors.point.color : .white)
                self?.requestButton.backgroundColor = $0 ? Colors.gray002.color : Colors.gray006.color
                self?.requestButton.isUserInteractionEnabled = $0
            }
            .store(in: &viewModel.bag)
        requestButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                let completedVC = ReportCompletedVC(isInsert: !self.isDelete)
                self.navigationController?.pushViewController(completedVC, animated: true)
            }
            .store(in: &viewModel.bag)
        viewModel
            .output
            .updatedImages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.addPhotoCollectionView.reloadData()
            }
            .store(in: &viewModel.bag)
        detailView
            .contentTextField
            .textPublisher
            .compactMap { $0 }
            .map { !$0.isEmpty }
            .sink { [weak self] in
                self?.viewModel.input.isDetailAddress.send($0)
            }
            .store(in: &viewModel.bag)
    }
    
    // set collectionView flow layout
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 88.0, height: 88.0)
        flowLayout.sectionInset = .zero
        return flowLayout
    }
    
    func showCameraAuthAlert() {
        let message = "사진 첨부를 위해 카메라 권한이 필요합니다.\n설정에서 카메라 권한을 허용해 주세요."
        
        let alert = UIAlertController(title: "카메라 권한 필요", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let bundle = Bundle.main.bundleIdentifier,
               let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
                if UIApplication.shared.canOpenURL(settings) {
                    UIApplication.shared.open(settings)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            self?.view.makeToast("카메라 권한을 허용해주세요.")
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc
    private func addressTapped() {
        let searchMapVC = SearchMapVC(requestLocation: viewModel.requestLocation)
        searchMapVC.delegate = self
        navigationController?.pushViewController(searchMapVC, animated: true)
    }
    
    @objc
    private func agreePhotoTapped() {
        agreePhotoView.isSelected.toggle()
        
        viewModel.input.isAgreePhoto.send(agreePhotoView.isSelected)
    }
}

extension ReportVC: SearchMapDelegate {
    func fetch(location: CLLocation?) {
        viewModel.requestLocation = location
    }
}

//MARK: - UICollectionViewDataSource
extension ReportVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.imageCount
        return count == 3 ? 3 : count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = viewModel.imageCount
        guard indexPath.item != count else {
            let addPhotoCell = collectionView.dequeueReusableCell(withType: AddPhotoCollectionViewCell.self, indexPath: indexPath)
            return addPhotoCell
        }
        
        let cell = collectionView.dequeueReusableCell(withType: PhotoCollectionViewCell.self, indexPath: indexPath)
        
        cell.tag = indexPath.item
        cell.delegate = self
        cell.fetchData(viewModel.image(at: indexPath.item))
        
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate
extension ReportVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard viewModel.imageCount == indexPath.item else { return }
        
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .restricted, .denied:
//            showCameraAuthAlert()
//        case .authorized, .notDetermined:
//            ImagePickerManager.shared.openCamera(self) { [weak self] image in
//                self?.viewModel.add(image: image)
//            }
//        default: break
//        }
        ImagePickerManager.shared.pickImageWithAlert(self) { [weak self] image in
            self?.viewModel.add(image: image)
        }
    }
}

//MARK: - PhotoCellDelegate
extension ReportVC: PhotoCellDelegate {
    func removeItemButtonTapped(at index: Int) {
        viewModel.removeImage(at: index)
    }
}
