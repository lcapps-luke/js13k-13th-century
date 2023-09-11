package battle;

import js.html.svg.ImageElement;

abstract class Weapon {
	private var spr:ImageElement;
	private var ox:Float;
	private var oy:Float;

	public var range(default, null):Float;

	public function new(spr:ImageElement, ox:Float, oy:Float) {
		this.spr = spr;
		this.ox = ox;
		this.oy = oy;
	}

	@:native("wh")
	abstract public function willHit(x:Float, y:Float, dir:Float, char:Character):Bool;

	@:native("ra")
	abstract public function renderAim(x:Float, y:Float, dir:Float):Void;

	@:native("dr")
	public function draw(x:Float, y:Float) {
		Main.context.drawImage(spr, x + ox, y + oy);
	}
}
