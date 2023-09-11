package map;

import Types.Location;
import battle.BattleState;
import location.LocationState;
import map.Map;
import map.MapStateMenu.MapMenuResult;
import resource.Images;
import ui.Button;
import ui.Mouse;

class MapState extends State {
	private static inline var ZOOM:Float = 25;

	private var viewX:Float = 0;
	private var viewY:Float = 0;

	private var locX:Float = 0;
	private var locY:Float = 0;

	private var menu:MapStateMenu = null;

	@:native("tt")
	private var travelTarget:Location = null;
	@:native("tp")
	private var travelProgress:Float = 0;
	@:native("ts")
	private var travelSpeed:Float = 0;
	@:native("ti")
	private var travelTime:Int = 0;

	private var travelAttack:Float = 0;

	@:native("rb")
	private var reportButton:Button;

	public function new() {
		super();
		bg = "#00F";

		locX = Map.currentLocation.x;
		locY = Map.currentLocation.y;

		reportButton = new Button("Report Earnings", "#fff", true, 80);
		reportButton.x = Main.canvas.width / 2 - reportButton.w / 2;
		reportButton.y = Main.canvas.height * 0.8 - reportButton.h / 2;
		reportButton.onClick = () -> Main.setState(new EndState());
	}

	override function update(s:Float) {
		super.update(s);

		lookAt(locX, locY);

		Main.context.save();
		Main.context.translate(viewX, viewY);
		Main.context.scale(ZOOM, ZOOM);

		Main.context.drawImage(Images.map, 0, 0);
		Main.context.font = "1px serif";
		Main.context.lineWidth = 1;

		for (r in Map.routes) {
			if (!r.a.known || !r.b.known) {
				continue;
			}

			Main.context.strokeStyle = r.a.type + r.b.type < 2 ? "#c73" : "#730";
			Main.context.beginPath();
			Main.context.moveTo(r.a.x, r.a.y);
			Main.context.lineTo(r.b.x, r.b.y);
			Main.context.stroke();
		}

		Main.context.strokeStyle = "#f00";
		Main.context.lineWidth = 0.2;
		Main.context.beginPath();
		Main.context.ellipse(locX, locY, 1.2, 1.2, 0, 0, Math.PI * 2);
		Main.context.stroke();

		var mx = (Mouse.X - viewX) / ZOOM;
		var my = (Mouse.Y - viewY) / ZOOM;

		var selectedLocation:Location = null;
		for (l in Map.locations) {
			if (!l.known) {
				continue;
			}

			Main.context.fillStyle = l.type == Map.TYPE_TOWN ? "#F00" : "#F0F"; // 0123456789abcdef
			Main.context.beginPath();
			Main.context.ellipse(l.x, l.y, 1, 1, 0, 0, Math.PI * 2);
			Main.context.fill();

			Main.context.fillStyle = "#fff";
			Main.context.strokeStyle = "#000";
			var tw = Main.context.measureText(l.name).width;
			Main.fillAndOutlineText(l.name, l.x - tw / 2, l.y - 2);

			if (l.high > -1) {
				Main.context.fillText('📈 ${Map.resources[l.high]}', l.x + 2, l.y - 0.5);
			}
			if (l.low > -1) {
				Main.context.fillText('📉 ${Map.resources[l.low]}', l.x + 2, l.y + 1);
			}

			if (canInteract() && LcMath.dist(mx, my, l.x, l.y) < 2) {
				Main.context.strokeStyle = "#fff";
				Main.context.lineWidth = 0.2;
				Main.context.beginPath();
				Main.context.ellipse(l.x, l.y, 1.2, 1.2, 0, 0, Math.PI * 2);
				Main.context.stroke();

				if (Mouse.CLICK) {
					selectedLocation = l;
				}
			}
		}

		Main.context.restore();

		if (travelTarget != null) {
			travelProgress += travelSpeed * s;

			locX = Map.currentLocation.x + (travelTarget.x - Map.currentLocation.x) * travelProgress;
			locY = Map.currentLocation.y + (travelTarget.y - Map.currentLocation.y) * travelProgress;

			if (travelProgress >= 1) {
				Map.currentLocation = travelTarget;
				Map.reveal(Map.currentLocation, []);
				locX = travelTarget.x;
				locY = travelTarget.y;
				selectedLocation = travelTarget;
				travelTarget = null;
				Map.currentDay += travelTime;
				travelTime = 0;
			}

			if (travelAttack > 0 && travelProgress > travelAttack) {
				Main.setState(new BattleState(this));
				travelAttack = 0;
			}
		}

		var dr = Map.TOTAL_DAYS - (Map.currentDay + Math.floor(travelTime * travelProgress));
		Main.context.font = "40px serif";
		Main.context.fillStyle = "#fff";
		Main.context.strokeStyle = "#000";
		Main.context.lineWidth = 8;
		Main.fillAndOutlineText('Days Remaining: $dr', 30, 60);

		if (dr < 1) {
			Main.context.fillStyle = "#000a";
			Main.context.fillRect(reportButton.x - 20, reportButton.y - 20, reportButton.w + 40, reportButton.h + 40);
			reportButton.update();
		}

		if (selectedLocation != null) {
			menu = new MapStateMenu(selectedLocation, onLocationMenuChoice);
		}

		if (menu != null) {
			menu.update(s);
		}
	}

	private inline function canInteract():Bool {
		return menu == null && travelTarget == null;
	}

	private function onLocationMenuChoice(c:MapMenuResult) {
		menu = null;

		if (c.option == MapStateMenu.OPT_ENTER) {
			Main.setState(new LocationState(c.location));
		}
		else if (c.option == MapStateMenu.OPT_TRAVEL) {
			var r = Map.getRouteTo(c.location);
			travelTarget = c.location;
			travelProgress = 0;

			travelSpeed = 15 / LcMath.dist(r.a.x, r.a.y, r.b.x, r.b.y);
			travelTime = c.time;

			travelAttack = (Math.random() < r.danger) ? (0.25 + Math.random() * .5) : 0;
		}
	}

	private inline function lookAt(x:Float, y:Float) {
		viewX = (Main.canvas.width / 2 - x * ZOOM);
		viewY = (Main.canvas.height / 2 - y * ZOOM);
	}
}
