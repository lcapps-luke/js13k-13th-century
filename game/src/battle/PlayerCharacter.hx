package battle;

import resource.Images;
import ui.Mouse;

class PlayerCharacter extends Character {
	private var mx:Float;
	private var my:Float;
	private var aiming:Bool = false;
	private var moveTurn = -1;
	private var aimDir:Float = 0;

	override public function new() {
		super(Character.TEAM_PLAYER, new Sword(), Inventory.stats);
		name = "You";
		setSprite(Images.manList[0]);
	}

	override function updateTurn(s:Float, id:Int, chars:Array<Character>):Bool {
		super.updateTurn(s, id, chars);
		moving = false;

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
				moving = true;
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
		var maxDist = LcMath.maxDist(speed);
		if (LcMath.dist(x, y, mx, my) > maxDist) {
			validMove = false;
		}

		// move line
		Main.context.strokeStyle = "#00f";
		Main.context.lineWidth = 4;
		Main.context.setLineDash([5]);
		Main.context.beginPath();
		Main.context.moveTo(x, y);
		Main.context.lineTo(mx, my);
		Main.context.stroke();

		Main.context.lineWidth = 2;
		Main.context.beginPath();
		Main.context.ellipse(x, y, maxDist, maxDist, 0, 0, Math.PI * 2);
		Main.context.stroke();

		Main.context.strokeStyle = "#ff0";
		Main.context.beginPath();
		Main.context.ellipse(mx, my, weapon.range, weapon.range, 0, 0, Math.PI * 2);
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
						Main.context.lineWidth = 4;
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
