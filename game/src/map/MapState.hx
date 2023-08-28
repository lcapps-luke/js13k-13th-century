package map;

import location.LocationState;
import map.Map;
import resource.Images;
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

	public function new() {
		super();
		bg = "#0000FF";

		locX = Map.currentLocation.x;
		locY = Map.currentLocation.y;
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

			Main.context.fillStyle = "#000";
			var tw = Main.context.measureText(l.name).width;
			Main.context.fillText(l.name, l.x - tw / 2, l.y - 2);

			if (l.high > -1) {
				Main.context.fillText('📈 ${Map.resources[l.high]}', l.x + 2, l.y - 0.5);
			}
			if (l.low > -1) {
				Main.context.fillText('📉 ${Map.resources[l.low]}', l.x + 2, l.y + 1);
			}

			if (canInteract() && Math.sqrt(Math.pow(mx - l.x, 2) + Math.pow(my - l.y, 2)) < 2) {
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
			}
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

	private function onLocationMenuChoice(location:Location, choice:Int) {
		menu = null;

		if (choice == MapStateMenu.OPT_ENTER) {
			Main.setState(new LocationState(location));
		}
		else if (choice == MapStateMenu.OPT_TRAVEL) {
			var r = Map.getRouteTo(location);
			travelTarget = location;
			travelProgress = 0;
			travelSpeed = 15 / Math.sqrt(Math.pow(r.a.x - r.b.x, 2) + Math.pow(r.a.y - r.b.y, 2));
		}
	}

	private inline function lookAt(x:Float, y:Float) {
		viewX = (Main.canvas.width / 2 - x * ZOOM);
		viewY = (Main.canvas.height / 2 - y * ZOOM);
	}
}
