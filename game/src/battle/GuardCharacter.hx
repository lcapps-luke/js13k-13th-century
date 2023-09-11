package battle;

import Types.Guard;

class GuardCharacter extends AiCharacter {
	override public function new(g:Guard) {
		super(Character.TEAM_PLAYER, g.weapon, g.stats);
		name = g.name;

		setSprite(g.sprite);
	}

	function chooseTarget(chars:Array<Character>):Character {
		return findClosest(this, chars);
	}
}
