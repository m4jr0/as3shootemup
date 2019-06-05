package engine.utils {
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.display.Shape;

	import engine.game.Game;
	import engine.locator.Locator;

	public class Utils {
		public function Utils() {}

		public static function sign(number: Number): int {
			return number < 0 ? -1 : 1;
		}

		public static function addOutline(obj: * , color: uint = 0xff0000, thickness: int = 1.5): void {
			var outline: GlowFilter = new GlowFilter();

			outline.blurX = outline.blurY = thickness;
			outline.color = color;
			outline.quality = BitmapFilterQuality.HIGH;
			outline.strength = 100;

			var filterArray: Array = new Array();
			filterArray.push(outline);

			obj.filters = filterArray;
		}

		public static function getRandomNumber(min: Number, max: Number): Number {
			return (Math.floor(Math.random() * (max - min + 1)) + min);
		}

		public static function getVectorMagnitude(vector: Object): Number {
			var x: Number = vector["x"];
			var y: Number = vector["y"];

			return Math.sqrt(x * x + y * y);
		}

		public static function normalizeVector(vector: Object): Object {
			var vectorLength: Number = Utils.getVectorMagnitude(vector);

			return {
				"x": vector["x"] / vectorLength,
				"y": vector["y"] / vectorLength
			};
		}

		public static function getDirection(point1: Object, point2: Object): Object {
			return Utils.normalizeVector({
				"x": point2["x"] - point1["x"],
				"y": point2["y"] - point1["y"]
			});
		}
	}
}
