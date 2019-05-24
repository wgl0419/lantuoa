//
//  PhotoBrowserImage.swift
//  SexyColor.Swift
//
//  Created by ________ on 2017/9/8.
//  Copyright © 2017年 __________. All rights reserved.
//

import UIKit

class PhotoBrowserImage: UIScrollView {
    
    
    weak var imageDelegate : PhotoBrowserImageDelegate?
    fileprivate var imageView : UIImageView!
    var currentImage : UIImage!
    fileprivate var images : NSMutableArray! = []
    fileprivate var totalTime : CGFloat!
    
    var imageUrl : String! {
        didSet {
            AliOSSClient.shared.download(url: imageUrl, isCache: true) { (data) in
                var defaultImage = UIImage(named: "image_default")
                if data != nil {
                    defaultImage = UIImage(data: data!) ?? defaultImage
                }
                DispatchQueue.main.async(execute: {
                    self.imageView.image = defaultImage
                })
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews() {
        self.delegate = self
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 3.0
        self.backgroundColor = UIColor.black
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .automatic
        }
        
        imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        
        let singleClick = UITapGestureRecognizer(target: self, action: #selector(singleClick(gestureRecognizer:)))
        self.addGestureRecognizer(singleClick)
        
        let doubleClick = UITapGestureRecognizer(target: self, action: #selector(doubleClick(gestureRecognizer:)))
        doubleClick.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleClick)
        
        singleClick.require(toFail: doubleClick)
    }
    
    @objc func singleClick(gestureRecognizer : UITapGestureRecognizer) {
        if imageDelegate != nil {
            if imageDelegate!.responds(to: #selector(PhotoBrowserImageDelegate.singleClickWithPhoto(photo:))) {
                imageDelegate?.singleClickWithPhoto(photo: self)
            }
        }
    }
    
    @objc func doubleClick(gestureRecognizer : UITapGestureRecognizer) {
        if self.zoomScale > 1.0 {
            self.setZoomScale(1.0, animated: true)
        }
        else {
            let touchPoint = gestureRecognizer.location(in: imageView)
            let newZoomScale = self.maximumZoomScale
            let xsize = self.width / newZoomScale
            let ysize = self.height / newZoomScale
            self.zoom(to: CGRect(x: touchPoint.x - xsize / 2, y: touchPoint.y - ysize / 2, width: xsize, height: ysize), animated: true)
        }
    }
    
    func layoutImageView() {
        var imageFrame = CGRect.zero
        currentImage = imageView.image
        let imageRatio = currentImage.size.width / currentImage.size.height
        let photoRatio = self.bounds.size.width / (self.bounds.size.height - SafeH * 2)
        if imageRatio > photoRatio {
            imageFrame.size = CGSize(width: self.bounds.size.width, height: self.bounds.size.width / currentImage.size.width * currentImage.size.height)
            imageFrame.origin.x = 0;
            imageFrame.origin.y = (self.bounds.size.height - imageFrame.size.height) / 2.0;
        }
        else {
            imageFrame.size = CGSize(width: (self.bounds.size.height - SafeH * 2) / currentImage.size.height * currentImage.size.width, height: (self.bounds.size.height - SafeH * 2))
            imageFrame.origin.x = (self.bounds.size.width - imageFrame.size.width)/2.0;
            imageFrame.origin.y = SafeH;
        }
        imageView.frame = imageFrame
    }
}


extension PhotoBrowserImage : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = self.bounds.size.width > self.contentSize.width ?
        (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0
        let offsetY = self.bounds.size.height > self.contentSize.height ? (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
}

@objc
protocol PhotoBrowserImageDelegate : NSObjectProtocol {
    func singleClickWithPhoto(photo : PhotoBrowserImage)
}



