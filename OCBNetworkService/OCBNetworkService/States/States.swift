//
//  States.swift
//  OCBNetworkService
//
//  Created by Anamika Deb on 4/5/21.
//

import Foundation
import UIKit

protocol DataLoading {
    associatedtype Data
    var state : ViewState<Data>{ get set }
    var loadingView : LoadingView { get }
    var errorView : ErrorView { get }
    
    func update()
}


public class LoadingView: UIView {
    var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            // Fallback on earlier versions
        }
        indicator.color = .white
            
        indicator.startAnimating()
            
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
            
        return indicator
    }()
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.8
        
        // Setting the autoresizing mask to flexible for
        // width and height will ensure the blurEffectView
        // is the same size as its parent view.
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        return blurEffectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        blurEffectView.frame = self.bounds
        self.insertSubview(blurEffectView, at: 0)
        
        loadingActivityIndicator.center = CGPoint(
            x: self.bounds.midX,
            y: self.bounds.midY
        )
        self.round(radius: 10)
        self.addSubview(loadingActivityIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class ErrorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum ViewState<Content> {
    case loading
    case loaded(data: Content)
    case error(message: String)
}

extension UIView{
    func round(radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        if borderWidth > 0.0 {
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor;
        }
    }
    
    func round(radius: CGFloat) {
        self.round(radius: radius, borderColor: UIColor.clear, borderWidth: 0.0)
    }
}

