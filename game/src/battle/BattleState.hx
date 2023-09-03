package battle;

import map.MapState;

class BattleState extends State {
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
		// TODO draw characters
		for (c in characters) {
			if (c.isAlive()) {
				c.update(s);
			}
		}

		// TODO draw turn order

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
