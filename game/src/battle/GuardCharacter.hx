package battle;

import resource.Images;

class GuardCharacter extends AiCharacter {
	override public function new() {
		super(Character.TEAM_PLAYER, Inventory.playerGuard, Inventory.health, Inventory.speed, new WeaponKnife());
		name = "Guard";

		setSprite(Images.randomMan(), -12, -72);
	}

	function chooseTarget(chars:Array<Character>):Character {
		return findClosest(this, chars);
	}
}
