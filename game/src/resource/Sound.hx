package resource;

class Sound {
	@:native("b")
	public static function blip() {
		ZzFX.zzfx(1, 0, 653, .01, .01, .01, 0, 2, 0, 0, 98, .1, 0, 0, 0, 0, 0, 1, 0, 0);
	}

	@:native("e")
	public static function select() {
		ZzFX.zzfx(1, 0, 495, 0, .1, .1, 1, 1.5, 0, 0, 150, .06, 0, 0, 0, 0, 0, .5, 0, .1);
	}

	@:native("h")
	public static function hit() {
		ZzFX.zzfx(.8, .4, 344, 0, .1, .1, 2, 2, -9, 2, 0, 0, 0, 0, 0, .3, 0, .8, 0, .3);
	}

	@:native("d")
	public static function die() {
		ZzFX.zzfx(.8, .05, 449, 0, .1, .2, 0, 2.7, 0, -7.3, 0, 0, 0, 1.6, 0, .1, 0, .6, 0, 0);
	}

	@:native("s")
	public static function step() {
		ZzFX.zzfx(1, .05, 304, .01, 0, 0, 0, 1.14, 0, .5, -137, .01, 0, 0, 0, 0, .03, .2, .01, .1);
	}

	@:native("f")
	public static function fight() {
		ZzFX.zzfx(.5, 0, 220, .1, .3, .24, 0, .6, 0, 3, -8, 0, .2, 0, 0, 0, 0, .7, .2, 0);
	}
}
