package battle;

import Types.Stats;
import resource.Images;

class WolfCharacter extends AiCharacter {
	public function new(stats:Stats) {
		super(Character.TEAM_BANDIT, new WolfClaws(), stats);
		setSprite(Images.randomMan(), -12, -72);
	}

	function chooseTarget(chars:Array<Character>):Character {
		return findClosest(this, chars);
	}
}

class WolfClaws extends ConeWeapon {
	public function new() {
		range = 100;
	}
}
