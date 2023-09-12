package resource;

import js.Browser;
import js.html.svg.ImageElement;

class Images {
	@:native("m")
	public static var map:ImageElement;

	@:native("r")
	public static var road:ImageElement;

	@:native("n")
	public static var manList:Array<ImageElement> = [];

	@:native("sw")
	public static var sword:ImageElement;
	@:native("pw")
	public static var pike:ImageElement;
	@:native("bw")
	public static var bow:ImageElement;

	@:native("q")
	private static var qty = 0;

	@:native("c")
	private static var callback:Void->Void;

	@:native("hc")
	private static var manHairColours = ["6e5631", "85773b", "91916f", "a08330"];
	@:native("tc")
	private static var tunicColours = ["9d835a", "9e533e", "629d5a", "5a7b9d"];
	@:native("lc")
	private static var leggingColours = ["aea585", "55974b", "4a3f28", "d6c4a3"];
	@:native("ha")
	private static var hatColours = ["55422a", "afafaf", '000" fill-opacity="0'];

	@:native("l")
	public static function load(callback:Void->Void) {
		Images.callback = callback;

		map = loadImage(ResourceBuilder.buildImage("map.svg"));
		road = loadImage(ResourceBuilder.buildImage("road.svg"));
		sword = loadImage(ResourceBuilder.buildImage("sword.svg"));
		pike = loadImage(ResourceBuilder.buildImage("pike.svg"));
		bow = loadImage(ResourceBuilder.buildImage("bow.svg"));

		var manStr = ResourceBuilder.buildImage("man.svg");
		for (h in manHairColours) {
			for (t in tunicColours) {
				for (l in leggingColours) {
					for (a in hatColours) {
						var str = StringTools.replace(manStr, manHairColours[0], h);
						str = StringTools.replace(str, tunicColours[0], t);
						str = StringTools.replace(str, leggingColours[0], l);
						str = StringTools.replace(str, hatColours[0], a);
						manList.push(loadImage(str));
					}
				}
			}
		}
	}

	@:native("i")
	static function loadImage(str:String) {
		qty++;

		var d = "data:image/svg+xml;base64," + Browser.window.btoa(str);
		var i:ImageElement = cast Browser.window.document.createElement("img");
		i.onload = loadCallback;
		i.onerror = function(e) {
			Browser.console.error(e);
		}
		i.setAttribute("src", d);

		return i;
	}

	@:native("ol")
	private static function loadCallback() {
		qty--;
		if (qty == 0) {
			callback();
		}
	}

	public static inline function randomMan() {
		return manList[Math.floor(Math.random() * manList.length)];
	}
}
