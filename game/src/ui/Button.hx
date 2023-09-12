package ui;

class Button extends Region {
	private static inline var PAD:Float = 10;
	private static inline var COLOUR = "#fff";

	private var textSize:Float;

	@:native("t")
	private var text:String;

	public function new(text:String, textSize:Float = 30) {
		this.text = text;
		this.textSize = textSize;

		Main.context.font = '${textSize}px serif';
		w = PAD * 2 + Main.context.measureText(text).width;
		h = PAD * 2 + textSize;
	}

	override function update(s:Float) {
		super.update(s);

		Main.context.globalAlpha = state == Region.STATE_OVER ? 1 : 0.5;
		Main.context.strokeStyle = COLOUR;
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

		Main.context.font = '${textSize}px serif';
		Main.context.fillStyle = COLOUR;
		Main.context.fillText(text, x + PAD, y + PAD + textSize * 0.75);

		Main.context.globalAlpha = 1;
	}
}
