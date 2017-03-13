//
//  ImageCropViewController.swift
//  Graygram-clone-iOS
//
//  Created by aney on 2017. 3. 12..
//  Copyright © 2017년 Taedong Kim. All rights reserved.
//

import UIKit

/// 이미지를 정사각형으로 크롭하는 뷰 컨트롤러
final class ImageCropViewController: UIViewController {
  
  // MARK: Properties
  
  fileprivate let originalImage: UIImage
  
  
  // MARK: UI
  
  fileprivate let scrollView = UIScrollView().then {
    $0.alwaysBounceHorizontal = true
    $0.alwaysBounceVertical = true
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
  }
  fileprivate let imageView = UIImageView()
  
  fileprivate let cropAreaView = UIView().then {
    $0.isUserInteractionEnabled = false
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.layer.borderWidth = 1 / UIScreen.main.scale
  }
  fileprivate let cropAreaTopCoverView = UIView().then {
    $0.isUserInteractionEnabled = false
    $0.backgroundColor = .white
    $0.alpha = 0.9
  }
  fileprivate let cropAreaBottomCoverView = UIView().then {
    $0.isUserInteractionEnabled = false
    $0.backgroundColor = .white
    $0.alpha = 0.9
  }
  
  
  // MARK: Initializing
  
  init(image: UIImage) {
    self.originalImage = image
    super.init(nibName: nil, bundle: nil)
    self.title = "Crop"
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(cancelButtonDidTap)
    )
    
    self.automaticallyAdjustsScrollViewInsets = false
    self.imageView.image = image
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.scrollView.addSubview(self.imageView)
    self.view.addSubview(self.scrollView)
    self.view.addSubview(self.cropAreaTopCoverView)
    self.view.addSubview(self.cropAreaBottomCoverView)
    self.view.addSubview(self.cropAreaView)
    
    self.scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.cropAreaView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(self.cropAreaView.snp.width)
      make.centerY.equalToSuperview()
    }
    self.cropAreaTopCoverView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.bottom.equalTo(self.cropAreaView.snp.top)
    }
    self.cropAreaBottomCoverView.snp.makeConstraints { make in
      make.top.equalTo(self.cropAreaView.snp.bottom)
      make.bottom.left.right.equalToSuperview()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if self.imageView.size == .zero {
      self.initializeContentSizeIfNeeded()
    }
  }
  
  
  // MARK: Scroll View Utils
  
  /// 이미지 뷰 크기와 스크롤 뷰 컨텐츠 크기를 초기화합니다.
  func initializeContentSizeIfNeeded() {
    guard self.imageView.size == .zero else { return }
    
    let imageWidth = self.originalImage.size.width
    let imageHeight = self.originalImage.size.height
    
    if imageWidth > imageHeight {
      self.imageView.height = self.cropAreaView.height
      self.imageView.width = self.cropAreaView.height * imageWidth / imageHeight
    } else if imageWidth < imageHeight {
      self.imageView.width = self.cropAreaView.width
      self.imageView.height = self.cropAreaView.width * imageHeight / imageWidth
    } else {
      self.imageView.size = self.cropAreaView.size
    }
    
    let contentInsetTopBottom = (self.scrollView.height - self.cropAreaView.height) / 2
    self.scrollView.contentInset.top = contentInsetTopBottom
    self.scrollView.contentInset.bottom = contentInsetTopBottom
    self.scrollView.contentSize = self.imageView.size
    self.centerScrollView(animated: false)
  }
  
  func centerScrollView(animated: Bool) {
    let targetContentOffset = CGPoint(
      x: (self.scrollView.contentSize.width - self.scrollView.width) / 2,
      y: (self.scrollView.contentSize.height - self.scrollView.height) / 2
    )
    self.scrollView.setContentOffset(targetContentOffset, animated: animated)
  }
  
  
  // MARK: Actions
  
  func cancelButtonDidTap() {
    _ = self.navigationController?.popViewController(animated: true)
  }
}
