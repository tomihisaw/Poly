import Foundation

public extension Float {
    public static func random(min: Float, max: Float) -> Float {
        let r32 = Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX)
        return (r32 * (max - min)) + min
    }
    public func square() -> Float {
        return self*self
    }
}
