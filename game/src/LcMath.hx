package;

import Types.Stats;
import battle.Bow;
import battle.Pike;
import battle.Sword;
import battle.Weapon;

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

	public static function findNearestPointOnLine(px:Float, py:Float, ax:Float, ay:Float, bx:Float, by:Float) {
		var atob = {x: bx - ax, y: by - ay};
		var atop = {x: px - ax, y: py - ay};
		var len = (atob.x * atob.x) + (atob.y * atob.y);
		var dot = (atop.x * atob.x) + (atop.y * atob.y);
		var t = Math.min(1, Math.max(0, dot / len));

		return {x: ax + (atob.x * t), y: ay + (atob.y * t)};
	}

	public static function makeStats(extra:Int) {
		var res:Stats = {
			guard: 1,
			speed: 1,
			health: 1,
			attack: 1
		}

		for (i in 0...extra) {
			switch (Math.round(Math.random() * 3)) {
				case 0:
					res.guard++;
				case 1:
					res.speed++;
				case 2:
					res.health++;
				case 3:
					res.attack++;
			}
		}

		return res;
	}

	public static function randomWeapon():Weapon {
		var i = Math.floor(Math.random() * 6);
		return switch (i) {
			case 0 | 1 | 2: new Sword();
			case 3 | 4: new Pike();
			default: new Bow();
		}
	}

	public static inline function bound(val:Float, min:Float, max:Float) {
		return Math.min(Math.max(val, min), max);
	}

	public static inline function maxDist(speed:Float) {
		return 200 + speed * 100;
	}

	public static inline function getRandomName() {
		return [
			"Willelmus", "Ricardus", "Iohannes", "Robertus", "Hugo", "Rogerus", "Walterus", "Thomas", "Radulfus", "Galfridus", "Henricus", "Adam", "Petrus",
			"Symon", "Nicholaus", "Alanus", "Stephanus"
		][Math.floor(Math.random() * 17)];
	}
}
