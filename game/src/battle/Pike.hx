package battle;

import resource.Images;

class Pike extends LineWeapon {
	public function new() {
		super(Images.pike, -20, -50);
		this.range = 150;
	}
}
