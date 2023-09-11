package battle;

import Types.Stats;
import js.html.svg.ImageElement;

abstract class Character {
	private static inline var MOVE_SPEED:Float = 300;
	private static inline var WALK_CYCLE_SPEED = 10;
	private static inline var WALK_CYCLE_OFFSET = 5;

	public static inline var GUARD_SLIP_SPEED:Float = .5;
	public static inline var TEAM_PLAYER:Int = 0;
	public static inline var TEAM_BANDIT:Int = 1;
	public static inline var RADIUS:Float = 15;

	public var team(default, null):Int;
	public var speed(default, null):Float;

	public var maxGuard(default, null):Float;
	public var guard(default, null):Float;
	public var lastGuard(default, null):Float;
	public var health(default, null):Int;

	private var guardTurn:Int = -1;
	private var attack:Float;

	private var weapon:Weapon;

	public var x:Float;
	public var y:Float;

	public var name:String = "Unknown";

	private var sprite:ImageElement = null;
	private var offsetX:Float = 0;
	private var offsetY:Float = 0;
	private var walkCycle:Float = 0;
	private var moving:Bool = false;

	public function new(team:Int, weapon:Weapon, stats:Stats) {
		this.team = team;
		this.weapon = weapon;

		this.guard = stats.guard;
		this.health = stats.health;
		this.speed = stats.speed;
		this.attack = stats.attack;

		maxGuard = guard;
		lastGuard = guard;
	}

	public function update(s:Float) {
		var gdif = lastGuard - guard;
		var lgIncr = (gdif > 0 ? -GUARD_SLIP_SPEED : GUARD_SLIP_SPEED) * s;
		lastGuard = Math.abs(gdif) < Math.abs(lgIncr) ? guard : (lastGuard + lgIncr);

		Main.context.fillStyle = "#000";
		Main.context.globalAlpha = 0.5;
		Main.context.beginPath();
		Main.context.ellipse(x, y, RADIUS, RADIUS * .7, 0, 0, Math.PI * 2);
		Main.context.fill();
		Main.context.globalAlpha = 1;

		if (sprite != null) {
			if (moving) {
				walkCycle += WALK_CYCLE_SPEED * s;
			}
			else {
				walkCycle = 0;
			}
			Main.context.drawImage(sprite, x + offsetX, y + offsetY + -Math.abs(Math.sin(walkCycle)) * WALK_CYCLE_OFFSET);
		}
	}

	public function updateTurn(s:Float, id:Int, chars:Array<Character>):Bool {
		if (guardTurn > -1 && id > guardTurn) {
			guard = Math.max(maxGuard, guard + maxGuard / 2);
			guardTurn = -1;
		}

		return true;
	}

	public function hit(atk:Float) {
		if (guard > 0) {
			guard = Math.max(0, guard - atk / 2);
		}
		else {
			health--;
		}
	}

	public inline function isAlive():Bool {
		return health > 0;
	}

	private function doAttack(dir:Float, chars:Array<Character>):Bool {
		var h = false;
		for (c in chars) {
			if (!c.isAlive() || c.team == team) {
				continue;
			}

			if (weapon.willHit(x, y, dir, c)) {
				c.hit(attack);
				h = true;
			}
		}
		return h;
	}

	public function setSprite(spr:ImageElement, ox:Float, oy:Float) {
		this.sprite = spr;
		this.offsetX = ox;
		this.offsetY = oy;
	}
}
