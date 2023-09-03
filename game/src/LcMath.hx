package;

class LcMath {
	public static inline function dist(ax:Float, ay:Float, bx:Float, by:Float) {
		return Math.sqrt(Math.pow(bx - ax, 2) + Math.pow(by - ay, 2));
	}

	public static inline function dir(ax:Float, ay:Float, bx:Float, by:Float) {
		return Math.atan2(by - ay, bx - ax);
	}

	public static inline function capAngle(a:Float):Float {
		return a < 0 ? (a + Math.PI * 2) : (a > Math.PI * 2 ? a - Math.PI * 2 : a);
	}
}
