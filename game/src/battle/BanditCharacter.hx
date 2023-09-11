package battle;

import Types.Stats;
import resource.Images;

class BanditCharacter extends AiCharacter {
	public function new(stats:Stats, weapon:Weapon) {
		super(Character.TEAM_BANDIT, weapon, stats);
		setSprite(Images.randomMan());
	}

	function chooseTarget(chars:Array<Character>):Character {
		return findClosest(this, chars);
	}
}
