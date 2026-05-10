//
//  LoadNibContent.swift
//  Sport Mob
//
//  Created by Al3dwy on 07/05/2026.
//

import UIKit

protocol NibLoadable {
    func loadNibContent()
}

extension NibLoadable where Self: UIView {
    func loadNibContent() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
