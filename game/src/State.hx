package;

abstract class State {
	private var bg:String = "#000";

	public function new() {}

	@:native("u")
	public function update(s:Float) {
		Main.context.fillStyle = bg;
		Main.context.fillRect(0, 0, Main.width, Main.height);
	}

	@:native("tc")
	private function textCenter(str:String, y:Float) {
		var w = Main.context.measureText(str).width;
		Main.context.fillText(str, Main.width / 2 - w / 2, y);
	}
}
