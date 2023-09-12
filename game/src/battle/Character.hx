package battle;

import Types.Stats;
import js.html.svg.ImageElement;
import resource.Sound;

abstract class Character {
	private static inline var MOVE_SPEED:Float = 300;
	private static inline var WALK_CYCLE_SPEED = 10;
	private static inline var WALK_CYCLE_OFFSET = 5;

	public static inline var GUARD_SLIP_SPEED:Float = .5;
	public static inline var TEAM_PLAYER:Int = 0;
	public static inline var TEAM_BANDIT:Int = 1;
	public static inline var RADIUS:Float = 15;
	public static inline var SPRITE_OFFSET_X:Float = -12;
	public static inline var SPRITE_OFFSET_Y:Float = -72;

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

	public var name:String = "";

	private var sprite:ImageElement = null;
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

	@:native("u")
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

		if (moving) {
			walkCycle += WALK_CYCLE_SPEED * s;
			if (walkCycle > Math.PI) {
				walkCycle = 0;
				Sound.step();
			}
		}
		else {
			walkCycle = 0;
		}
		var walkY = -Math.sin(walkCycle) * WALK_CYCLE_OFFSET;
		Main.context.drawImage(sprite, x + SPRITE_OFFSET_X, y + SPRITE_OFFSET_Y + walkY);
		weapon.draw(x, y + walkY);
	}

	@:native("ut")
	public function updateTurn(s:Float, id:Int, chars:Array<Character>):Bool {
		if (guardTurn > -1 && id > guardTurn) {
			guard = Math.min(maxGuard, guard + maxGuard / 4);
			guardTurn = -1;
		}

		return true;
	}

	public function hit(atk:Float) {
		if (guard > 0) {
			guard = Math.max(0, guard - atk);
		}
		else {
			health--;
		}

		if (!isAlive()) {
			Sound.die();
		}
	}

	public inline function isAlive():Bool {
		return health > 0;
	}

	@:native("da")
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

		if (h) {
			Sound.hit();
		}

		return h;
	}

	public inline function setSprite(spr:ImageElement) {
		this.sprite = spr;
	}
}
