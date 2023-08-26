package map;

import map.Map.Location;
import ui.Button;

class MapStateMenu extends State {
	public static inline var OPT_TRAVEL = 0;
	public static inline var OPT_ENTER = 1;
	public static inline var OPT_RETURN = 2;

	private var l:Location;
	private var d:Int = 0;
	private var t:Int = 0;

	private var options:Array<Button>;

	public function new(l:Location, c:Location->Int->Void) {
		super();
		bg = "#0008";

		this.l = l;

		var r = Map.getRouteTo(l);
		if (r != null) {
			d = Math.ceil(Math.sqrt(Math.pow(r.a.x - r.b.x, 2) + Math.pow(r.a.y - r.b.y, 2)) * Map.PX_TO_MILES);
			t = Math.ceil((this.d / Map.TRAVEL_SPEED) / Map.TRAVEL_HOURS_PER_DAY);
		}

		var tr = new Button("Travel");
		tr.enable(l != Map.currentLocation && r != null);
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
		textCenter(l.name, Main.canvas.height / 4);

		if (d > 0) {
			Main.context.font = "40px serif";
			textCenter('Distance: $d miles', Main.canvas.height / 4 + 100);
			textCenter('Travel Time: $t days', Main.canvas.height / 4 + 150);
		}

		for (b in options) {
			b.update();
		}
	}
}
