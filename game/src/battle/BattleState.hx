package battle;

import map.MapState;
import resource.Images;

class BattleState extends State {
	public static inline var TURN_HUD_WIDTH:Float = 250;
	public static inline var OVER_NOT:Int = 0;
	public static inline var OVER_WIN:Int = 1;
	public static inline var OVER_LOSE:Int = 2;

	private var mapState:MapState;

	private var characters = new Array<Character>();
	private var turn:Int = 0;

	public function new(mapState:MapState) {
		super();
		bg = "#7C4F30";
		this.mapState = mapState;

		// TODO populate chars
		var c:Character = new PlayerCharacter();
		c.x = Main.canvas.width * 0.25;
		c.y = Main.canvas.height * 0.5;
		characters.push(c);

		c = new WolfCharacter();
		c.x = Main.canvas.width * 0.75;
		c.y = Main.canvas.height * 0.5;
		characters.push(c);

		// TODO sort chars
	}

	override function update(s:Float) {
		super.update(s);
		// TODO draw bg
		Main.context.drawImage(Images.road, 0, 0);

		// draw characters
		for (c in characters) {
			if (c.isAlive()) {
				c.update(s);
			}
		}

		// update active character
		if (characters[0].updateTurn(s, turn, characters)) {
			// move to next char if turn complete
			turn++;
			characters.push(characters.shift());

			while (!characters[0].isAlive()) {
				characters.push(characters.shift());
			}

			// TODO check end of battle
			if (isOver() != OVER_NOT) {
				Main.setState(mapState);
			}
		}

		// draw turn order
		var xAcc:Float = 0;
		for (c in characters) {
			if (c.isAlive()) {
				renderCharacterHud(xAcc, c);
				xAcc += TURN_HUD_WIDTH;
			}

			if (xAcc > Main.canvas.width) {
				break;
			}
		}
	}

	function renderCharacterHud(xAcc:Float, c:Character) {
		Main.context.fillStyle = "#fff";
		Main.context.strokeStyle = "#000";

		Main.context.beginPath();
		Main.context.rect(xAcc, 10, TURN_HUD_WIDTH, 100);
		Main.context.fill();
		Main.context.stroke();

		Main.context.font = "30px serif";
		Main.context.fillStyle = "#000";

		// TODO name
		Main.context.fillText(c.name, xAcc + 10, 40, TURN_HUD_WIDTH - 20);

		// health
		var healthStr = [for (i in 0...c.health) "❤"].join("");
		Main.context.fillText(healthStr, xAcc + 10, 70, TURN_HUD_WIDTH - 20);

		// guard
		var gc = (c.guard / c.maxGuard) * (TURN_HUD_WIDTH - 20);
		var gl = (c.lastGuard / c.maxGuard) * (TURN_HUD_WIDTH - 20);

		Main.context.fillStyle = "#F00";
		Main.context.fillRect(xAcc + 10, 80, gl, 20);
		Main.context.fillStyle = "#0F0";
		Main.context.fillRect(xAcc + 10, 80, gc, 20);
	}

	private function isOver() {
		var pc = 0;
		var bc = 0;
		for (c in characters) {
			if (c.isAlive()) {
				if (c.team == Character.TEAM_PLAYER) {
					pc++;
				}
				else {
					bc++;
				}
			}
		}

		if (pc == 0) {
			return OVER_LOSE;
		}
		if (bc == 0) {
			return OVER_WIN;
		}
		return OVER_NOT;
	}
}
