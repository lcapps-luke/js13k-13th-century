package map;

import map.Map.Location;
import ui.Button;

class MapStateMenu extends State {
	public static inline var OPT_TRAVEL = 0;
	public static inline var OPT_ENTER = 1;
	public static inline var OPT_RETURN = 2;

	private var l:Location;
	private var d:Int;
	private var t:Int;

	private var options:Array<Button>;

	public function new(l:Location, c:Location->Int->Void) {
		super();
		bg = "#0008";

		this.l = l;
		this.d = 0; // distance?
		this.t = 0; // time?

		var tr = new Button("Travel");
		tr.enable(l != Map.currentLocation);
		tr.onClick = () -> c(l, OPT_TRAVEL);

		var en = new Button("Enter");
		en.enable(l == Map.currentLocation);
		en.onClick = () -> c(l, OPT_ENTER);

		var ex = new Button("Return");
		ex.onClick = () -> c(l, OPT_RETURN);
		options = [tr, en, ex];

		var yacc = Main.canvas.height / 2;
		for (b in options) {
			b.x = Main.canvas.width / 2 - b.w / 2;
			b.y = yacc;
			yacc += b.h * 1.5;
		}
	}

	override function update(s:Float) {
		super.update(s);

		Main.context.font = "80px serif";
		Main.context.fillStyle = "#fff";
		var tw = Main.context.measureText(l.name).width;
		Main.context.fillText(l.name, Main.canvas.width / 2 - tw / 2, Main.canvas.height / 4);

		for (b in options) {
			b.update();
		}
	}
}
