package map;

import ui.Button;

class GameOverState extends State {
	private var retry = new Button("Retry", 60);

	public function new() {
		super();
		retry.onClick = () -> Main.setState(new MapState());
		retry.x = Main.canvas.width / 2 - retry.w / 2;
		retry.y = Main.canvas.height * 0.75;
	}

	override function update(s:Float) {
		super.update(s);

		retry.update();
		textCenter("Game Over", Main.canvas.height / 2);
	}
}
