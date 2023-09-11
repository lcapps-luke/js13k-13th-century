package battle;

class LineWeapon extends Weapon {
	private var width:Float = 5;

	public function willHit(x:Float, y:Float, dir:Float, char:Character):Bool {
		var bx = x + Math.cos(dir) * range;
		var by = y + Math.sin(dir) * range;

		var point = LcMath.findNearestPointOnLine(char.x, char.y, x, y, bx, by);
		return LcMath.dist(char.x, char.y, point.x, point.y) < width;
	}

	public function renderAim(x:Float, y:Float, dir:Float) {
		var bx = x + Math.cos(dir) * range;
		var by = y + Math.sin(dir) * range;

		Main.context.strokeStyle = "#000";
		Main.context.lineWidth = width * 2;
		Main.context.beginPath();
		Main.context.moveTo(x, y);
		Main.context.lineTo(bx, by);
		Main.context.stroke();
	}
}
