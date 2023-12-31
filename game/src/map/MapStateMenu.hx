package map;

import Types.Location;
import ui.Button;

class MapStateMenu extends State {
	public static inline var OPT_TRAVEL = 0;
	public static inline var OPT_ENTER = 1;
	public static inline var OPT_RETURN = 2;

	private var l:Location;
	private var d:Int = 0;
	private var t:Int = 0;

	private var options:Array<Button>;

	public function new(l:Location, c:MapMenuResult->Void) {
		super();
		bg = "#0008";

		this.l = l;

		var r = Map.getRouteTo(l);
		if (r != null) {
			d = Math.ceil(LcMath.dist(r.a.x, r.a.y, r.b.x, r.b.y) * Map.PX_TO_MILES);
			t = Math.ceil((this.d / Map.TRAVEL_SPEED) / Map.TRAVEL_HOURS_PER_DAY);
		}

		var tr = new Button("Travel", 80);
		tr.enable(l != Map.currentLocation && r != null && Map.currentDay < Map.TOTAL_DAYS);
		tr.onClick = () -> c({
			location: l,
			option: OPT_TRAVEL,
			time: t,
			distance: d
		});

		var en = new Button("Enter", 80);
		en.enable(l == Map.currentLocation);
		en.onClick = () -> c({
			location: l,
			option: OPT_ENTER,
			time: t,
			distance: d
		});

		var ex = new Button("Return", 80);
		ex.onClick = () -> c({
			location: l,
			option: OPT_RETURN,
			time: t,
			distance: d
		});
		options = [tr, en, ex];

		var yacc = Main.height / 2 - 150;
		for (b in options) {
			b.x = Main.width / 2 - b.w / 2;
			b.y = yacc;
			yacc += b.h * 1.5;
		}
	}

	override function update(s:Float) {
		super.update(s);

		Main.context.font = "120px serif";
		Main.context.fillStyle = "#fff";
		textCenter(l.name, 150);

		if (d > 0) {
			Main.context.font = "50px serif";
			textCenter('Distance: $d miles', 250);
			textCenter('Travel Time: $t days', 300);
		}

		for (b in options) {
			b.update(s);
		}
	}
}

typedef MapMenuResult = {
	@:native("l")
	var location:Location;
	@:native("o")
	var option:Int;
	@:native("d")
	var distance:Int;
	@:native("t")
	var time:Int;
}
