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
		name = "You";
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
				if (!doAttack(aimDir, chars)) {
					guardTurn = id;
				}
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
		if (!aiming && !Mouse.DOWN) {
			mx = Mouse.X;
			my = Mouse.Y;
		}
		var validMove = true;
		for (c in chars) {
			if (c == this || !c.isAlive()) {
				continue;
			}

			if (LcMath.dist(mx, my, c.x, c.y) < Character.RADIUS * 2) {
				validMove = false;
				break;
			}
		}

		// move line
		Main.context.strokeStyle = "#00f";
		Main.context.lineWidth = 4;
		Main.context.setLineDash([5]);
		Main.context.beginPath();
		Main.context.moveTo(x, y);
		Main.context.lineTo(mx, my);
		Main.context.stroke();
		Main.context.setLineDash([]);

		Main.context.strokeStyle = validMove ? "#ff0" : "#f00";
		Main.context.beginPath();
		Main.context.ellipse(mx, my, Character.RADIUS, Character.RADIUS, 0, 0, Math.PI * 2);
		Main.context.stroke();

		if (aiming) {
			// render weapon aim
			aimDir = LcMath.dir(mx, my, Mouse.X, Mouse.Y);
			weapon.renderAim(mx, my, aimDir);

			for (e in chars) {
				if (e.isAlive() && e.team != team) {
					if (weapon.willHit(mx, my, aimDir, e)) {
						Main.context.strokeStyle = "#ff0";
						Main.context.beginPath();
						Main.context.ellipse(e.x, e.y, Character.RADIUS * 1.2, Character.RADIUS * 1.2, 0, 0, Math.PI * 2);
						Main.context.stroke();
					}
				}
			}
		}

		if (Mouse.DOWN && validMove) {
			aiming = true;
		}
		else if (aiming) {
			moveTurn = id;
			aiming = false;
			// TODO show option - attack, guard, cancel
		}

		return false;
	}
}
