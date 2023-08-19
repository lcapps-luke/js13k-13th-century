package map;

import resource.Images;

class MapState extends State {
	private static inline var ZOOM:Float = 25;

	private var viewX:Float = 0;
	private var viewY:Float = 0;

	public function new() {
		super();
		lookAt(30, 270);
		bg = "#0000FF";
	}

	override function update(s:Float) {
		super.update(s);

		Main.context.save();
		Main.context.translate(viewX, viewY);
		Main.context.scale(ZOOM, ZOOM);

		Main.context.drawImage(Images.map, 0, 0);
		Main.context.font = "1px serif";

		for (l in Map.locations) {
			Main.context.fillStyle = l.type == 1 ? "#F00" : "#F0F";
			Main.context.beginPath();
			Main.context.ellipse(l.x, l.y, 1, 1, 0, 0, Math.PI * 2);
			Main.context.fill();

			Main.context.fillStyle = "#000";
			var tw = Main.context.measureText(l.name).width;
			Main.context.fillText(l.name, l.x - tw / 2, l.y - 2);
		}

		Main.context.restore();
	}

	private function lookAt(x:Float, y:Float) {
		viewX = (Main.canvas.width / 2 - x * ZOOM);
		viewY = (Main.canvas.height / 2 - y * ZOOM);
	}
}
