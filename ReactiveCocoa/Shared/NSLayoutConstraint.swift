import ReactiveSwift

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Reactive where Base: NSLayoutConstraint {
	/// Sets the constant.
	public var constant: BindingTarget<CGFloat> {
		return makeBindingTarget { $0.constant = $1 }
	}
}

extension NSLayoutConstraint: DefaultBindingTargetProvider {
	public var defaultBindingTarget: BindingTarget<CGFloat> {
		return reactive.constant
	}
}
