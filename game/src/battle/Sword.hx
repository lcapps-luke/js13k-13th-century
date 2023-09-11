package battle;

import resource.Images;

class Sword extends ConeWeapon {
	public function new() {
		super(Images.sword, -5, -50);
		this.range = 100;
	}
}
