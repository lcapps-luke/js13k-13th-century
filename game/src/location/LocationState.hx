package location;

import map.Map.Location;
import map.MapState;
import ui.Button;

class LocationState extends State {
	private static inline var MARGIN:Float = 32;

	private var l:Location;
	private var options:Array<Button> = [];

	public function new(location:Location) {
		super();
		bg = "#000";
		this.l = location;

		var width = 0.0;
		var o = new Button("Market");
		o.onClick = function() {
			Main.setState(new MarketState(location));
		}
		width = o.w;
		options.push(o);

		o = new Button("Leave");
		o.onClick = function() {
			Main.setState(new MapState());
		}
		width += o.w;
		options.push(o);

		var xx = Main.canvas.width / 2 - (width + (options.length - 1) * MARGIN) / 2;
		for (o in options) {
			o.y = Main.canvas.height * 0.75;
			o.x = xx;
			xx += o.w + MARGIN;
		}
	}

	override function update(s:Float) {
		super.update(s);

		Main.context.font = "80px serif";
		Main.context.fillStyle = "#fff";
		textCenter(l.name, Main.canvas.height / 4);

		for (b in options) {
			b.update();
		}
	}
}
