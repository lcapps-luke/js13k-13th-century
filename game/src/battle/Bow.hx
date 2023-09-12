package battle;

import resource.Images;

class Bow extends LineWeapon {
	public function new() {
		super(Images.bow, 4, -50);
		this.range = 600;
	}
}
