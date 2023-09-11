package battle;

abstract class Weapon {
	public var range(default, null):Float;

	abstract public function willHit(x:Float, y:Float, dir:Float, char:Character):Bool;

	abstract public function renderAim(x:Float, y:Float, dir:Float):Void;
}
