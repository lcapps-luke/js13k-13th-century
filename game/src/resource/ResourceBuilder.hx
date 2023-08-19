package resource;

import haxe.DynamicAccess;
import haxe.macro.Expr.ExprOf;
import haxe.macro.Expr;
#if macro
import haxe.Json;
import haxe.macro.Context;
import sys.FileSystem;
import sys.io.File;
#end

class ResourceBuilder {
	private static inline var IMG_PATH = "assets/image";
	private static inline var IMG_MIN_PATH = "build/assets/image/";
	private static var minifiedImages = false;

	macro public static function buildImage(name:String):ExprOf<String> {
		if (!minifiedImages) {
			FileSystem.createDirectory(IMG_MIN_PATH);
			cleanDir(IMG_MIN_PATH);

			Sys.command("svgo", [
				      "-f",              IMG_PATH,
				      "-o",          IMG_MIN_PATH,
				      "-p",                   "1",
				"--enable",         "removeTitle",
				"--enable",          "removeDesc",
				"--enable",   "removeUselessDefs",
				"--enable", "removeEditorsNSData",
				"--enable",       "removeViewBox",
				"--enable", "transformsWithOnePath"
			]);

			minifiedImages = true;
		}

		var imgContent = File.getContent(IMG_MIN_PATH + name);

		return Context.makeExpr(imgContent, Context.currentPos());
	}

	macro public static function buildMap():ExprOf<String> {
		var map = Json.parse(File.getContent("assets/map.json"));

		var locations:Array<Dynamic> = cast map.locations;
		var locationString = locations.map(mapLocation).join("|");

		var routes:Array<Dynamic> = cast map.routes;
		var routeString = routes.map(mapRoute).join("|");

		return Context.makeExpr('$locationString+$routeString', Context.currentPos());
	}

	#if macro
	private static function cleanDir(dir) {
		for (f in FileSystem.readDirectory(dir)) {
			if (!FileSystem.isDirectory(dir + f)) {
				FileSystem.deleteFile(dir + f);
			}
		}
	}

	private static function mapLocation(l:Dynamic):String {
		var data:Array<Dynamic> = [l.name, l.type ? 1 : 0, l.x, l.y];

		var demandMap:DynamicAccess<Float> = cast l.demand;
		for (d in map.Map.resources) {
			data.push(demandMap.get(d));
		}

		return data.join(",");
	}

	private static function mapRoute(l:Dynamic):String {
		return [l.a, l.b, l.danger].join(",");
	}
	#end
}
