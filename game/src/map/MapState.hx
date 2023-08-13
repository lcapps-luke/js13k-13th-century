package map;

import resource.Images;

class MapState extends State {
	private static inline var ZOOM:Float = 20;

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

		Main.context.restore();
	}

	private function lookAt(x:Float, y:Float) {
		viewX = (Main.canvas.width / 2 - x * ZOOM);
		viewY = (Main.canvas.height / 2 - y * ZOOM);
	}
}
