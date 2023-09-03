package battle;

class WolfCharacter extends AiCharacter {
	public function new() {
		super(Character.TEAM_BANDIT, 50, 1, 5, new WolfClaws());
		attack = 50;
	}

	function chooseTarget(chars:Array<Character>):Character {
		var c:Character = null;
		var d:Float = 0;

		for (i in chars) {
			if (!i.isAlive() || i.team == team) {
				continue;
			}

			var s = LcMath.dist(x, y, i.x, i.y);
			if (c == null || s < d) {
				c = i;
				d = s;
			}
		}

		return c;
	}
}

class WolfClaws extends ConeWeapon {
	public function new() {
		range = 100;
	}
}
