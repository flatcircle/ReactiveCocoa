import ReactiveSwift
import enum Result.NoError

/// Describes a type which declares a default signal, so that it can be used as
/// a source in an unidirectional binding.
///
/// - important: Conforming types may expose more signals.
public protocol DefaultBindingSourceProvider {
	associatedtype Value

	var defaultBindingSource: Signal<Value, NoError> { get }
}

/// Describes a type which declares a default binding target, so that it can be 
/// used as a target in an unidirectional binding.
///
/// - important: Conforming types may expose more binding targets.
public protocol DefaultBindingTargetProvider: BindingTargetProtocol {
	associatedtype Value

	var defaultBindingTarget: BindingTarget<Value> { get }
}

extension DefaultBindingTargetProvider {
	public var lifetime: Lifetime {
		return defaultBindingTarget.lifetime
	}

	public func consume(_ value: Value) {
		defaultBindingTarget.consume(value)
	}

	@discardableResult
	public static func <~ <Source: SignalProtocol>(target: Self, signal: Source) -> Disposable? where Source.Value == Value, Source.Error == NoError {
		return target.defaultBindingTarget <~ signal
	}
}

extension BindingTargetProtocol {
	/// Binds the default signal provided by `provider` to a target, updating the
	/// target's value to the latest value sent by the property.
	///
	/// - note: The binding will automatically terminate when either the target or
	///         the provided signal terminates.
	///
	/// - parameters:
	///   - target: A target to be bond to.
	///   - provider: A provider which provides a signal to bind.
	///
	/// - returns: A disposable that can be used to terminate binding before the
	///            deinitialization of the target or the termination of the
	///            provided signal.
	@discardableResult
	public static func <~ <Provider: DefaultBindingSourceProvider>(target: Self, provider: Provider) -> Disposable? where Provider.Value == Value {
		return target <~ provider.defaultBindingSource
	}
}
