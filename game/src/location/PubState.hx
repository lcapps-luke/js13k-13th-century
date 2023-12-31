package location;

import Types.Location;
import map.Map;
import ui.Button;

class PubState extends State {
	private static inline var MARGIN:Float = 42;
	private static inline var INFO_COST:Int = 5;

	private var l:Location;
	private var options:Array<Button> = [];
	private var info:Array<String> = [];

	public function new(l:Location) {
		super();
		this.l = l;

		var width = 0.0;
		var i = new Button('Information (-$INFO_COST)', 80);
		i.onClick = function() {
			info = Map.revealNeighbors();
			if (info.length == 0) {
				info.push("Learnt nothing new");
			}
			Inventory.pence -= INFO_COST;
			i.enable(false);
			l.info = true;
		}
		i.enable(!l.info && Inventory.pence >= INFO_COST);
		width = i.w;
		options.push(i);

		var g = new Button("Hire Guard", 80);
		g.onClick = function() {
			Main.setState(new GuardState(l));
		}
		width += g.w;
		options.push(g);

		var o = new Button("Leave", 80);
		o.onClick = function() {
			Main.setState(new LocationState(l));
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
		textCenter('${l.name} Public House', 150);

		Main.context.font = "40px serif";
		var yy = 250;
		for (i in info) {
			textCenter(i, yy);
			yy += 50;
		}

		Main.context.fillText('Purse: ${Inventory.pence}', 20, 40);

		for (b in options) {
			b.update(s);
		}
	}
}
