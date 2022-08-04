//
//  UIView+Snapshot.swift
//  SnapshotKit
//
//  Created by Quang Nguyen Nhu on 2018/9/9.
//

import UIKit

extension UIView: SnapshotKitProtocol {
    @objc
    public func takeSnapshotOfVisibleContent() -> UIImage? {
        return self.takeSnapshotOfFullContent(for: self.bounds)
    }

    @objc
    public func takeSnapshotOfFullContent() -> UIImage? {
        return self.takeSnapshotOfFullContent(for: self.bounds)
    }

    @objc
    public func asyncTakeSnapshotOfFullContent(_ completion: @escaping ((UIImage?) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            let image = self.takeSnapshotOfFullContent()
            completion(image)
        }
    }

    public func takeSnapshotOfFullContent(for croppingRect: CGRect) -> UIImage? {
        var backgroundColor = self.backgroundColor ?? UIColor.white
        let opaqueCanvas = (self.isOpaque && self.layer.cornerRadius == 0)
        if opaqueCanvas == false {
            backgroundColor = UIColor.white
        }
        let contentSize = CGSize.init(width: floor(croppingRect.size.width), height: floor(croppingRect.size.height))
        UIGraphicsBeginImageContextWithOptions(contentSize, opaqueCanvas, 0)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.saveGState()
        context.clear(croppingRect)
        context.setFillColor(backgroundColor.cgColor)
        context.fill(croppingRect)
        context.translateBy(x: -croppingRect.origin.x, y: -croppingRect.origin.y)
        self.layer.render(in: context)
        context.restoreGState()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}


