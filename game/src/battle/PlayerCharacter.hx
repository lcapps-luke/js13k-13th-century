package battle;

import ui.Mouse;

class PlayerCharacter extends Character {
	private var mx:Float;
	private var my:Float;
	private var aiming:Bool = false;
	private var moveTurn = -1;
	private var aimDir:Float = 0;

	override public function new() {
		super(Character.TEAM_PLAYER, Inventory.playerGuard, Inventory.health, Inventory.speed, new WeaponKnife());
	}

	override function update(s:Float) {
		super.update(s);
		// TODO render & animations
	}

	override function updateTurn(s:Float, id:Int, chars:Array<Character>):Bool {
		super.updateTurn(s, id, chars);

		if (moveTurn == id) {
			if (LcMath.dist(x, y, mx, my) < Character.MOVE_SPEED * s) {
				x = mx;
				y = my;
				doAttack(aimDir, chars);
				return true;
			}
			else {
				var dir = Math.atan2(my - y, mx - x);
				x += Math.cos(dir) * (Character.MOVE_SPEED * s);
				y += Math.sin(dir) * (Character.MOVE_SPEED * s);
			}

			return false;
		}

		// TODO controls
		if (!aiming) {
			mx = Mouse.X;
			my = Mouse.Y;
		}

		Main.context.strokeStyle = "#000";
		Main.context.lineWidth = 2;
		Main.context.beginPath();
		Main.context.moveTo(x, y);
		Main.context.lineTo(mx, my);
		Main.context.stroke();

		if (aiming) {
			// TODO render weapon aim
			aimDir = LcMath.dir(mx, my, Mouse.X, Mouse.Y);
			weapon.renderAim(mx, my, aimDir);

			for (e in chars) {
				if (e.isAlive() && e.team != team) {
					if (weapon.willHit(mx, my, aimDir, e)) {
						Main.context.strokeStyle = "#FF0";
						Main.context.beginPath();
						Main.context.ellipse(e.x, e.y, 30, 30, 0, 0, Math.PI * 2);
						Main.context.stroke();
					}
				}
			}
		}

		if (Mouse.DOWN) {
			aiming = true;
		}
		else if (aiming) {
			moveTurn = id;
			aiming = false;
		}

		return false;
	}
}
