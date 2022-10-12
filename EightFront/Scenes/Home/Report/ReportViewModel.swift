//
//  ReportViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/10/10.
//

import UIKit
import Combine
import CoreLocation

//MARK: ReportViewModel
final class ReportViewModel {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
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
    }
}

//MARK: - I/O & Error
extension ReportViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        var isAgreePhoto = CurrentValueSubject<Bool, Never>.init(false)
        var isDetailAddress = CurrentValueSubject<Bool, Never>.init(false)
        var isIncludePhoto = CurrentValueSubject<Bool, Never>.init(false)
    }
    
    struct Output {
        var isRequest = CurrentValueSubject<Bool, Never>.init(false)
        var updatedImages = CurrentValueSubject<Void?, Never>.init(nil)
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
}
