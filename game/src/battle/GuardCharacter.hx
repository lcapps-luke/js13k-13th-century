package battle;

class GuardCharacter extends AiCharacter {
	override public function new() {
		super(Character.TEAM_PLAYER, Inventory.playerGuard, Inventory.health, Inventory.speed, new WeaponKnife());
		name = "Guard";
	}

	function chooseTarget(chars:Array<Character>):Character {
		return findClosest(this, chars);
	}
}
