package battle;

abstract class Character {
	private static inline var MOVE_SPEED:Float = 200;
	public static inline var GUARD_SLIP_SPEED:Float = 100;
	public static inline var TEAM_PLAYER:Int = 0;
	public static inline var TEAM_BANDIT:Int = 1;

	public var team(default, null):Int;
	public var speed(default, null):Float;

	private var maxGuard:Float;
	private var guard:Float;
	private var lastGuard:Float;
	private var health:Int;
	private var guardTurn:Int = -1;
	private var attack:Float = 100;

	private var weapon:Weapon;

	public var x:Float;
	public var y:Float;

	public function new(team:Int, guard:Float, health:Int, speed:Float, weapon:Weapon) {
		this.team = team;
		maxGuard = guard;
		this.guard = guard;
		lastGuard = guard;
		this.health = health;
		this.speed = speed;
		this.weapon = weapon;
	}

	public function update(s:Float) {
		var gdif = guard - lastGuard;
		var lgIncr = (gdif > 0 ? -GUARD_SLIP_SPEED : GUARD_SLIP_SPEED) * s;
		lastGuard = Math.abs(gdif) < Math.abs(lgIncr) ? guard : (lastGuard + lgIncr);

		Main.context.fillStyle = "#000";
		Main.context.beginPath();
		Main.context.ellipse(x, y, 25, 25, 0, 0, Math.PI * 2);
		Main.context.fill();
	}

	public function updateTurn(s:Float, id:Int, chars:Array<Character>):Bool {
		if (guardTurn > -1 && id > guardTurn) {
			guard = Math.max(maxGuard, guard + maxGuard / 2);
			guardTurn = -1;
		}

		return true;
	}

	public function hit(dmg:Float) {
		if (guard > 0) {
			guard -= dmg;
		}
		else {
			health--;
		}
	}

	public inline function isAlive():Bool {
		return health > 0;
	}

	private function doAttack(dir:Float, chars:Array<Character>) {
		for (c in chars) {
			if (!c.isAlive() || c.team == team) {
				continue;
			}

			if (weapon.willHit(x, y, dir, c)) {
				c.hit(attack);
			}
		}
	}
}
