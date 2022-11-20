//
//  ReportViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/10/10.
//

import UIKit
import Combine
import CoreLocation
import Moya

//MARK: ReportViewModel
final class ReportViewModel {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    var type: ReportType?
    var box: CollectionBox?
    private let clothesProvider = MoyaProvider<BoxesAPI>()
    @Published var addressString: String?
    private var imageList = [UIImage]() {
        didSet {
            output.updatedImages.send(nil)
            input.isIncludePhoto.send(!imageList.isEmpty)
        }
    }
    var requestLocation: CLLocation? {
        didSet {
            LocationManager.shared.addressUpdate(location: requestLocation) { [weak self] address in
                self?.addressString = address
            }
        }
    }
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        input.isAgreePhoto
            .combineLatest(input.isDetailAddress, input.isIncludePhoto)
            .sink { [weak self] in
                self?.output.isRequest.send($0 && $1 && $2)
            }
            .store(in: &bag)
        input.updateReport
            .sink { [weak self] param in
                switch self?.type {
                case .new:
                    self?.request(.newReport(info: param, images: self?.imageList ?? []))
                default:
                    self?.request(.updateReport(id: "\(self?.box?.id ?? 0)", info: param, images: self?.imageList ?? []))
                }
            }
            .store(in: &bag)
        input.deleteReport
            .sink { [weak self] _ in
                self?.request(.deleteReport(id: "\(self?.box?.id ?? 0)"))
            }
            .store(in: &bag)
    }
}

//MARK: - I/O & Error
extension ReportViewModel {
    enum ReportType {
        case new
        case update
        case delete
    }
    
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        var isAgreePhoto = CurrentValueSubject<Bool, Never>.init(false)
        var isDetailAddress = CurrentValueSubject<Bool, Never>.init(false)
        var isIncludePhoto = CurrentValueSubject<Bool, Never>.init(false)
        var updateReport = PassthroughSubject<ReportRequest, Never>()
        var deleteReport = PassthroughSubject<Void?, Never>()
    }
    
    struct Output {
        var isRequest = CurrentValueSubject<Bool, Never>.init(false)
        var updatedImages = CurrentValueSubject<Void?, Never>.init(nil)
        var requestReport = PassthroughSubject<Bool, Never>()
    }
}

//MARK: - Method
extension ReportViewModel {
    // <= 이미지 추가
    func add(image: UIImage) {
        imageList.append(image)
    }
    func image(at index: Int) -> UIImage? {
        return imageList[index]
    }
    
    // 이미지 삭제
    func removeImage(at index: Int) {
        imageList.remove(at: index)
    }
    // => 이미지 총 개수
    var imageCount: Int {
        return imageList.count
    }
    
    func request(_ boxAPI: BoxesAPI) {
        clothesProvider
            .requestPublisher(boxAPI)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    LogUtil.d(error.localizedDescription)
                    self?.output.requestReport.send(false)
                case .finished:
                    LogUtil.d("Successed")
                    self?.output.requestReport.send(true)
                }
            } receiveValue: { _ in }
            .store(in: &bag)
    }
}
