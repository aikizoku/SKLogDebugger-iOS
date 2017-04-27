//
//  SKLogDebugger.swift
//  SKLogDebuggerDemo
//
//  Created by yukithehero on 2017/04/20.
//  Copyright © 2017年 yukithehero. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public class SKLogDebugger {
    public static let shared = SKLogDebugger()
    
    var logs = Variable<[SKLDLog]>([])
    var validOmitActions = Variable<[String]>(SKLDDefaults.validOmitActions.getStrings())
    fileprivate var omitActions: [String] = []
    fileprivate var menuTrackView: SKLDMenuTrackView?
    fileprivate var listTrackView: SKLDListTrackView?
    
    fileprivate let disposeBag = DisposeBag()
    
    public func setOmitActions(_ actions: [String]) {
        omitActions = actions.unique()
    }
    
    public func addLog(action: String, data: [String: Any]) {
        if SKLDDefaults.isDebugMode.getBool() && menuTrackView == nil {
            SKLogDebugger.shared.showTrackView()
        }
        var logs = self.logs.value
        logs.insert(SKLDLog(action: action, data: data), at: 0)
        self.logs.value = logs
    }
    
    public func openSettingView() {
        let vc = UIStoryboard.instantiate("SKLDSettingViewController") as! SKLDSettingViewController
        vc.omitActions.value = omitActions
        topViewController()?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}

extension SKLogDebugger {
    
    func showTrackView() {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        if let view = menuTrackView {
            view.removeFromSuperview()
            UIApplication.shared.delegate?.window??.addSubview(view)
        } else {
            let view = SKLDMenuTrackView(frame: CGRect(x: (w/2)-100, y: 20, width: 200, height: 50))
            let gesture = UIPanGestureRecognizer()
            gesture.rx.event.subscribe(onNext: { [weak self] gesture in
                guard let `self` = self, let window = UIApplication.shared.delegate?.window, let w = window else { return }
                let p = gesture.location(in: w)
                switch gesture.state {
                case .changed:
                    view.center.x = p.x
                    view.center.y = p.y
                default:
                    break
                }
            }).addDisposableTo(view.disposeBag)
            view.addGestureRecognizer(gesture)
            view.liveButton.rx.tap.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                if let listTrackView = self.listTrackView {
                    listTrackView.isHidden = !listTrackView.isHidden
                }
            }).addDisposableTo(view.disposeBag)
            view.listButton.rx.tap.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.openListView()
            }).addDisposableTo(view.disposeBag)
            UIApplication.shared.delegate?.window??.addSubview(view)
            menuTrackView = view
        }
        
        if let view = self.listTrackView {
            view.removeFromSuperview()
            UIApplication.shared.delegate?.window??.addSubview(view)
        } else {
            let view = SKLDListTrackView(frame: CGRect(x: (w/2)-150, y: h-220, width: 300, height: 200))
            let gesture = UIPanGestureRecognizer()
            gesture.rx.event.subscribe(onNext: { [weak self] gesture in
                guard let `self` = self, let window = UIApplication.shared.delegate?.window, let w = window else { return }
                let p = gesture.location(in: w)
                switch gesture.state {
                case .changed:
                    view.center.x = p.x
                    view.center.y = p.y
                default:
                    break
                }
            }).addDisposableTo(view.disposeBag)
            view.addGestureRecognizer(gesture)
            UIApplication.shared.delegate?.window??.addSubview(view)
            listTrackView = view
        }
    }
    
    func hideTrackView() {
        menuTrackView?.removeFromSuperview()
        listTrackView?.removeFromSuperview()
    }
    
    fileprivate func openListView() {
        let vc = UIStoryboard.instantiate("SKLDListViewController") as! SKLDListViewController
        let nvc = UINavigationController(rootViewController: vc)
        topViewController()?.present(nvc, animated: true, completion: nil)
        hideTrackView()
    }
    
    fileprivate func topViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
}

