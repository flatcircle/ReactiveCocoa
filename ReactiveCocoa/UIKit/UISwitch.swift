import ReactiveSwift
import enum Result.NoError
import UIKit

extension Reactive where Base: UISwitch {
	/// Sets the on-off state of the switch.
	public var isOn: BindingTarget<Bool> {
		return makeBindingTarget { $0.isOn = $1 }
	}

	/// A signal of on-off states in `Bool` emitted by the switch.
	public var isOnValues: Signal<Bool, NoError> {
		return trigger(for: .valueChanged)
			.map { [unowned base = self.base] in base.isOn }
	}
}

extension UISwitch: DefaultBindingSourceProvider {
	public var defaultBindingSource: Signal<Bool, NoError> {
		return reactive.isOnValues
	}
}

extension UISwitch: DefaultBindingTargetProvider {
	public var defaultBindingTarget: BindingTarget<Bool> {
		return reactive.isOn
	}
}
