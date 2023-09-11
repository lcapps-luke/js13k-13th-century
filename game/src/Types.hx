package;

#if !macro
import battle.Weapon;
import js.html.svg.ImageElement;
#end

typedef Location = {
	var name:String;
	var x:Float;
	var y:Float;
	var type:Int;
	var known:Bool;
	var demand:Array<Float>;
	var qty:Array<Int>;
	var high:Int;
	var low:Int;
	var info:Bool;
};

typedef Route = {
	var a:Location;
	var b:Location;
	var danger:Float;
};

typedef Stats = {
	@:native("g")
	var guard:Int;
	@:native("a")
	var attack:Int;
	@:native("h")
	var health:Int;
	@:native("s")
	var speed:Int;
}

#if !macro
typedef Guard = {
	@:native("s")
	var sprite:ImageElement;
	@:native("n")
	var name:String;
	@:native("t")
	var stats:Stats;
	@:native("w")
	var weapon:Weapon;
}
#end
