package location;

import Types.Guard;
import Types.Location;
import battle.Character;
import battle.Pike;
import battle.Sword;
import resource.Images;
import ui.Button;

class GuardState extends State {
	private var l:Location;

	private var back = new Button("Back", 60);
	private var opt = new Array<GuardOption>();

	public function new(l:Location) {
		super();
		this.l = l;

		back.onClick = () -> Main.setState(new PubState(l));
		back.x = Main.canvas.width - back.w - 40;
		back.y = Main.canvas.height - back.h - 40;

		for (i in 0...3) {
			var stats = LcMath.makeStats(Math.round(4 + Math.pow(i, 2) * 4));
			var spr = Images.randomMan();
			var name = 'Guard ${i + 1}';

			var guard:Guard = {
				sprite: spr,
				weapon: LcMath.randomWeapon(),
				stats: stats,
				name: name
			};

			var cost = 50 + 100 * i;
			var btn = new Button('Hire (-${cost})');
			btn.enable(cost <= Inventory.pence);
			btn.onClick = function() {
				Inventory.guard = guard;
				Inventory.pence -= cost;
				Main.setState(new PubState(l));
			}

			opt.push({
				guard: guard,
				hire: btn
			});
		}
	}

	override function update(s:Float) {
		super.update(s);
		back.update();

		Main.context.fillText('Purse: ${Inventory.pence}', 40, Main.canvas.height - 70);

		Main.context.font = "80px serif";
		textCenter("Hire Guard", 80);

		Main.context.font = "30px serif";
		textCenter("Guards will join you for your next journey only", 120);

		var yAcc = 200;
		for (g in opt) {
			// image
			var ix = Main.canvas.width * .3 + 30;
			Main.context.drawImage(g.guard.sprite, ix, yAcc);
			g.guard.weapon.draw(ix - Character.SPRITE_OFFSET_X, yAcc - Character.SPRITE_OFFSET_Y);

			// name
			Main.context.fillText(g.guard.name, Main.canvas.width * .3, yAcc + 100);

			// stats
			Main.context.fillText('Health: ${g.guard.stats.health}', Main.canvas.width * .5, yAcc + 20);
			Main.context.fillText('Guard: ${g.guard.stats.guard}', Main.canvas.width * .5, yAcc + 50);
			Main.context.fillText('Speed: ${g.guard.stats.speed}', Main.canvas.width * .5, yAcc + 80);
			Main.context.fillText('Attack: ${g.guard.stats.attack}', Main.canvas.width * .5, yAcc + 110);

			// hire button
			g.hire.x = Main.canvas.width * .7;
			g.hire.y = yAcc + 50 - g.hire.h / 2;
			g.hire.update();

			yAcc += 200;
		}
	}
}

typedef GuardOption = {
	var guard:Guard;
	var hire:Button;
}
