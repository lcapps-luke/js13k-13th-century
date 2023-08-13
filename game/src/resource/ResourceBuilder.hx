package resource;

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

	#if macro
	private static function cleanDir(dir) {
		for (f in FileSystem.readDirectory(dir)) {
			if (!FileSystem.isDirectory(dir + f)) {
				FileSystem.deleteFile(dir + f);
			}
		}
	}
	#end
}
