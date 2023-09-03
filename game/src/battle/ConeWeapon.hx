package battle;

class ConeWeapon extends Weapon {
	private var angle:Float = (Math.PI / 180) * 20;

	public function willHit(x:Float, y:Float, dir:Float, char:Character):Bool {
		if (LcMath.dist(x, y, char.x, char.y) > range) {
			return false;
		}

		var angleToChar = LcMath.capAngle(LcMath.dir(x, y, char.x, char.y));

		var from = dir - angle / 2;
		var to = dir + angle / 2;
		var offset:Float = from < 0 ? Math.abs(from) : Math.min(0, (Math.PI * 2) - to);
		var atcOff = LcMath.capAngle(angleToChar + offset);

		return !(atcOff < from + offset || atcOff > to + offset);
	}

	public function renderAim(x:Float, y:Float, dir:Float) {
		Main.context.strokeStyle = "#000";
		Main.context.lineWidth = 2;
		Main.context.beginPath();
		Main.context.ellipse(x, y, range, range, dir, -angle / 2, angle / 2);
		Main.context.stroke();
	}
}
