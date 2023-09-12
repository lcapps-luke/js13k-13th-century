package location;

import Types.Guard;
import Types.Location;
import battle.Character;
import resource.Images;
import ui.Button;

class GuardState extends State {
	private static var cache = new js.lib.Map<String, Array<Guard>>();

	private var l:Location;

	private var back = new Button("Back", 60);
	private var opt = new Array<GuardOption>();

	public function new(l:Location) {
		super();
		this.l = l;

		back.onClick = () -> Main.setState(new PubState(l));
		back.x = Main.width - back.w - 40;
		back.y = Main.height - back.h - 40;

		for (i in getGuards(l.name)) {
			if (Inventory.guard == i) {
				continue;
			}

			var btn = new Button('Hire (-${i.cost})', 80);
			btn.enable(i.cost <= Inventory.pence);
			btn.onClick = function() {
				Inventory.guard = i;
				Inventory.pence -= i.cost;
				Main.setState(new PubState(l));
			}

			opt.push({
				guard: i,
				hire: btn
			});
		}

		if (Inventory.guard != null) {
			opt.push({
				guard: Inventory.guard,
				hire: null
			});
		}
	}

	private inline function getGuards(loc:String) {
		var res = cache.get(loc);
		if (res == null) {
			res = [];

			for (i in 0...3) {
				var stats = LcMath.makeStats(2 * (i + 1));
				var spr = Images.randomMan();
				var name = LcMath.getRandomName();

				res.push({
					sprite: spr,
					weapon: LcMath.randomWeapon(),
					stats: stats,
					name: name,
					cost: 1000 + 2000 * i
				});
			}

			cache.set(loc, res);
		}

		return res;
	}

	override function update(s:Float) {
		super.update(s);
		back.update(s);

		Main.context.fillText('Purse: ${Inventory.pence}', 40, Main.height - 70);

		Main.context.font = "80px serif";
		textCenter("Hire Guard", 80);

		if (Inventory.guard != null) {
			Main.context.font = "40px serif";
			textCenter("You can have only one guard at a time. Hiring another will replace your existing guard.", 130);
		}

		var yAcc = 200;
		for (g in opt) {
			// image
			var ix = 180;
			Main.context.drawImage(g.guard.sprite, ix, yAcc);
			g.guard.weapon.draw(ix - Character.SPRITE_OFFSET_X, yAcc - Character.SPRITE_OFFSET_Y);

			Main.context.font = '60px serif';

			// name
			Main.context.fillText(g.guard.name, ix - 50, yAcc + 100);

			// stats
			Main.context.fillText('Health: ${g.guard.stats.health}', Main.width * .3, yAcc + 40);
			Main.context.fillText('Guard: ${g.guard.stats.guard}', Main.width * .3, yAcc + 100);
			Main.context.fillText('Speed: ${g.guard.stats.speed}', Main.width * .5, yAcc + 40);
			Main.context.fillText('Attack: ${g.guard.stats.attack}', Main.width * .5, yAcc + 100);

			// hire button
			if (g.hire == null) {
				Main.context.fillText("Current Guard", Main.width * .7, yAcc + 50);
			}
			else {
				g.hire.x = Main.width * .7;
				g.hire.y = yAcc + 50 - g.hire.h / 2;
				g.hire.update(s);
			}

			yAcc += 180;
		}
	}
}

typedef GuardOption = {
	var guard:Guard;
	var hire:Button;
}
