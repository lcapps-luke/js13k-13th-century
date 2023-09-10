package battle;

import resource.Images;

class WolfCharacter extends AiCharacter {
	public function new() {
		super(Character.TEAM_BANDIT, 50, 1, 5, new WolfClaws());
		attack = 50;
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
