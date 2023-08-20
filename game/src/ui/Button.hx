package ui;

import js.lib.RegExp;

class Button extends Region {
	private static inline var PAD:Float = 10;
	private static inline var TEXT_SIZE:Float = 30;

	private var text:String;
	private var colour:String;

	public function new(text:String, colour:String = "#FFF", enabled:Bool = true) {
		this.text = text;
		this.colour = colour;
		state = enabled ? Region.STATE_NORMAL : Region.STATE_DISABLED;

		Main.context.font = '${TEXT_SIZE}px serif';
		w = PAD * 2 + Main.context.measureText(text).width;
		h = PAD * 2 + TEXT_SIZE;
	}

	override function update() {
		super.update();

		Main.context.globalAlpha = state == Region.STATE_OVER ? 1 : 0.5;
		Main.context.strokeStyle = colour;
		Main.context.lineWidth = PAD / 2;
		Main.context.beginPath();
		Main.context.rect(x, y, w, h);
		Main.context.stroke();

		if (state == Region.STATE_DISABLED) {
			Main.context.beginPath();
			Main.context.moveTo(x, y);
			Main.context.lineTo(x + w, y + h);
			Main.context.stroke();
		}
		else {
			Main.context.globalAlpha = 1;
		}

		Main.context.font = '${TEXT_SIZE}px serif';
		Main.context.fillStyle = colour;
		Main.context.fillText(text, x + PAD, y + PAD + TEXT_SIZE * 0.75);

		Main.context.globalAlpha = 1;
	}
}
