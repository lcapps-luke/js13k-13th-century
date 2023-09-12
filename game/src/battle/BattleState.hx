package battle;

import map.GameOverState;
import map.MapState;
import resource.Images;
import resource.Sound;

class BattleState extends State {
	public static inline var TURN_HUD_WIDTH:Float = 250;
	public static inline var OVER_NOT:Int = 0;
	public static inline var OVER_WIN:Int = 1;
	public static inline var OVER_LOSE:Int = 2;

	// wealth limit, enemy qty, enemy level
	private static var enemyRanges = [
		[10000, 1, 0],
		[20000, 1, 1],
		[30000, 2, 0],
		[40000, 2, 1],
		[50000, 1, 3],
		[60000, 2, 2],
		[70000, 3, 2],
	];

	private var mapState:MapState;

	private var characters = new Array<Character>();
	private var drawCharacters:Array<Character>;
	private var turn:Int = 0;
	private var idx:Int = 0;

	private var endType:Int = OVER_NOT;
	private var endTimer:Float = 0;

	public function new(mapState:MapState) {
		super();
		Sound.fight();
		bg = "#7C4F30";
		this.mapState = mapState;

		// populate chars
		var c:Character = new PlayerCharacter();
		c.x = Main.width * 0.25;
		c.y = Main.height * 0.25;
		characters.push(c);

		if (Inventory.guard != null) {
			var c:Character = new GuardCharacter(Inventory.guard);
			c.x = Main.width * 0.25;
			c.y = Main.height * 0.75;
			characters.push(c);
		}

		// populate enemies based on wealth
		var eRange = chooseEnemyRange(Inventory.pence + Inventory.getStoreValue());
		var yS = 1 / (eRange[1] + 1);
		for (i in 0...eRange[1]) {
			c = new BanditCharacter(LcMath.makeStats(eRange[2]), LcMath.randomWeapon());
			c.name = 'Bandit ${i + 1}';
			c.x = Main.width * 0.75;
			c.y = Main.height * (yS * (i + 1));
			characters.push(c);
		}

		characters.sort((a, b) -> Math.round(b.speed - a.speed));
		drawCharacters = characters.copy();
	}

	@:native("cer")
	private function chooseEnemyRange(val:Int) {
		for (r in enemyRanges) {
			if (val < r[0]) {
				return r;
			}
		}
		return enemyRanges[enemyRanges.length - 1];
	}

	override function update(s:Float) {
		super.update(s);
		// draw bg
		Main.context.drawImage(Images.road, 0, 0);

		// draw characters
		drawCharacters.sort((a, b) -> Math.round(a.y - b.y));
		for (c in drawCharacters) {
			if (c.isAlive()) {
				c.update(s);
			}
		}

		// check end
		if (endType == OVER_NOT) {
			// update active character
			if (characters[idx].updateTurn(s, turn, characters)) {
				// move to next char if turn complete
				turn++;
				nextCharacterIndex();

				// check end of battle
				endType = isOver();
				if (endType != OVER_NOT) {
					endTimer = 1;
				}
			}
		}
		else {
			endTimer -= s;
			if (endTimer < 0) {
				Main.setState(endType == OVER_WIN ? mapState : new GameOverState());
			}
		}

		// draw turn order
		for (i in 0...characters.length) {
			renderCharacterHud(10 + (TURN_HUD_WIDTH + 10) * i, characters[i], i == idx);
		}
	}

	private inline function nextCharacterIndex() {
		idx++;
		if (idx >= characters.length) {
			idx = 0;
		}
		while (!characters[idx].isAlive()) {
			idx++;
			if (idx >= characters.length) {
				idx = 0;
			}
		}
	}

	private inline function renderCharacterHud(xAcc:Float, c:Character, current:Bool) {
		Main.context.lineWidth = 5;
		Main.context.fillStyle = "#fff";
		Main.context.strokeStyle = current ? "#f00" : "#000";

		Main.context.beginPath();
		Main.context.rect(xAcc, 10, TURN_HUD_WIDTH, 100);
		Main.context.fill();
		Main.context.stroke();

		Main.context.font = "30px serif";
		Main.context.fillStyle = "#000";

		// name
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

		if (!c.isAlive()) {
			Main.context.strokeStyle = "#f00";
			Main.context.moveTo(xAcc, 10);
			Main.context.lineTo(xAcc + TURN_HUD_WIDTH, 110);
			Main.context.stroke();
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
