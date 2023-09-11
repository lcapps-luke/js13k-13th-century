package battle;

abstract class AiCharacter extends Character {
	private var tgt:Character = null;
	private var moveToX:Float = -1;
	private var moveToY:Float = -1;

	private var endTurn = -1;

	override function updateTurn(s:Float, id:Int, chars:Array<Character>):Bool {
		super.updateTurn(s, id, chars);

		// choose target
		if (tgt == null) {
			tgt = chooseTarget(chars);
			calculateMoveTarget();
		}

		// move to target
		if (moveToX > 0) {
			if (LcMath.dist(x, y, moveToX, moveToY) < Character.MOVE_SPEED * s) {
				x = moveToX;
				y = moveToY;
				moveToX = -1;
				moving = false;
			}
			else {
				var dir = LcMath.dir(x, y, moveToX, moveToY);
				x += Math.cos(dir) * (Character.MOVE_SPEED * s);
				y += Math.sin(dir) * (Character.MOVE_SPEED * s);
				moving = true;
			}
		}
		else {
			// attack or guard
			if (LcMath.dist(x, y, tgt.x, tgt.y) > weapon.range) {
				// guard
				guardTurn = id;
			}
			else {
				// attack
				doAttack(LcMath.dir(x, y, tgt.x, tgt.y), chars);
			}
			endTurn = id;
			tgt = null;
		}

		return id == endTurn;
	}

	@:native("cht")
	abstract function chooseTarget(chars:Array<Character>):Character;

	@:native("fcl")
	private function findClosest(f:Character, chars:Array<Character>):Character {
		var c:Character = null;
		var d:Float = 0;

		for (i in chars) {
			if (!i.isAlive() || i.team == team) {
				continue;
			}

			var s = LcMath.dist(f.x, f.y, i.x, i.y);
			if (c == null || s < d) {
				c = i;
				d = s;
			}
		}

		return c;
	}

	private inline function calculateMoveTarget() {
		var dir = LcMath.dir(x, y, tgt.x, tgt.y);

		var tgtDist = LcMath.dist(x, y, tgt.x, tgt.y);
		var dist = Math.min(1000, tgtDist - (weapon.range * 0.9)); // TODO max dist based on speed

		moveToX = x + Math.cos(dir) * dist;
		moveToY = y + Math.sin(dir) * dist;
	}
}
