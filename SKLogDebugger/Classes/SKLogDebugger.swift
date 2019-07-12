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
import SwiftyJSON

public class SKLogDebugger {
    public static let shared = SKLogDebugger()
    
    let logsObserver = PublishSubject<(logs: [SKLDLog], omitActions: [String])>()
    var logs: [SKLDLog] = []
    var validOmitActions: [String] = SKLDDefaults.validOmitActions.getStrings()
    var parentViewController: UIViewController?

    fileprivate var omitActions: [String] = []
    fileprivate var menuTrackView: SKLDMenuTrackView?
    fileprivate var listTrackView: SKLDListTrackView?
    
    fileprivate var isShowTrackView = false
    fileprivate let addLogMutex = NSLock()
    fileprivate let disposeBag = DisposeBag()
    
    public func setOmitActions(_ actions: [String]) {
        omitActions = actions.unique()
    }
    
    public func addLog(action: String, data: [String: Any]) {
        addLog(action: action, string: JSON(data).rawString() ?? "")
    }
    
    public func addLog(action: String, string: String) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let `self` = self else { return }
            self.addLogMutex.lock()
            defer { self.addLogMutex.unlock() }
            
            if SKLDDefaults.isDebugMode.getBool() && !self.isShowTrackView {
                self.isShowTrackView = true
                DispatchQueue.main.async {
                    SKLogDebugger.shared.showTrackView()
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.logs.insert(SKLDLog(action: action, string: string), at: 0)
                self.logsObserver.onNext((logs: self.logs, omitActions: self.validOmitActions))
            }
        }
    }
    
    public func openSettingView() {
        let vc = UIStoryboard.instantiate("SKLDSettingViewController") as! SKLDSettingViewController
        vc.omitActions = omitActions
        vc.omitActionsObserver.onNext(omitActions)
        topViewController()?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        hideTrackView()
    }
    
    public func setParentViewController(_ viewController: UIViewController?) {
        parentViewController = viewController
    }
}

extension SKLogDebugger {
    
    func showTrackView() {
        guard SKLDDefaults.isDebugMode.getBool() else { return }
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        if let view = menuTrackView {
            view.removeFromSuperview()
            UIApplication.shared.delegate?.window??.addSubview(view)
        } else {
            let view = SKLDMenuTrackView(frame: CGRect(x: (w/2)-125, y: 20, width: 250, height: 50))
            let gesture = UIPanGestureRecognizer()
            gesture.rx.event.subscribe(onNext: { gesture in
                guard let window = UIApplication.shared.delegate?.window, let w = window else { return }
                let p = gesture.location(in: w)
                switch gesture.state {
                case .changed:
                    view.center.x = p.x
                    view.center.y = p.y
                default:
                    break
                }
            }).disposed(by: view.disposeBag)
            view.addGestureRecognizer(gesture)
            view.realtimeButton.rx.tap.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                if let listTrackView = self.listTrackView {
                    listTrackView.isHidden = !listTrackView.isHidden
                }
            }).disposed(by: view.disposeBag)
            view.logListButton.rx.tap.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.openLogListView()
            }).disposed(by: view.disposeBag)
            view.settingButton.rx.tap.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.openSettingView()
            }).disposed(by: view.disposeBag)
            UIApplication.shared.delegate?.window??.addSubview(view)
            menuTrackView = view
        }
        
        if let view = self.listTrackView {
            view.removeFromSuperview()
            UIApplication.shared.delegate?.window??.addSubview(view)
        } else {
            let view = SKLDListTrackView(frame: CGRect(x: (w/2)-150, y: h-220, width: 300, height: 200))
            let gesture = UIPanGestureRecognizer()
            gesture.rx.event.subscribe(onNext: { gesture in
                guard let window = UIApplication.shared.delegate?.window, let w = window else { return }
                let p = gesture.location(in: w)
                switch gesture.state {
                case .changed:
                    view.center.x = p.x
                    view.center.y = p.y
                default:
                    break
                }
            }).disposed(by: view.disposeBag)
            view.addGestureRecognizer(gesture)
            UIApplication.shared.delegate?.window??.addSubview(view)
            listTrackView = view
        }
    }
    
    func hideTrackView() {
        menuTrackView?.removeFromSuperview()
        listTrackView?.removeFromSuperview()
    }
    
    fileprivate func openLogListView() {
        let vc = UIStoryboard.instantiate("SKLDListViewController") as! SKLDListViewController
        let nvc = UINavigationController(rootViewController: vc)
        topViewController()?.present(nvc, animated: true, completion: nil)
        hideTrackView()
    }
    
    fileprivate func topViewController() -> UIViewController? {
        if let parentViewController = parentViewController {
            return parentViewController
        } else {
            return UIApplication.shared.keyWindow?.rootViewController
        }
    }
}

