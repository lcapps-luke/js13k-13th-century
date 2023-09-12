package location;

import Types.Location;
import map.MapState;
import ui.Button;

class LocationState extends State {
	private static inline var MARGIN:Float = 42;

	private var l:Location;
	private var options:Array<Button> = [];

	public function new(location:Location) {
		super();
		this.l = location;

		var width = 0.0;
		var o = new Button("Market", 80);
		o.onClick = function() {
			Main.setState(new MarketState(location));
		}
		width = o.w;
		options.push(o);

		o = new Button("Public House", 80);
		o.onClick = function() {
			Main.setState(new PubState(location));
		}
		width += o.w;
		options.push(o);

		o = new Button("Leave", 80);
		o.onClick = function() {
			Main.setState(new MapState());
		}
		width += o.w;
		options.push(o);

		var xx = Main.width / 2 - (width + (options.length - 1) * MARGIN) / 2;
		for (o in options) {
			o.y = Main.height - o.h - MARGIN;
			o.x = xx;
			xx += o.w + MARGIN;
		}
	}

	override function update(s:Float) {
		super.update(s);

		Main.context.font = "120px serif";
		Main.context.fillStyle = "#fff";
		textCenter(l.name, 150);

		for (b in options) {
			b.update(s);
		}
	}
}
