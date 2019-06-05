package engine.render {
	import engine.game.Manager;
	import engine.locator.Locator;

	public class RenderManager extends Manager {
		public function RenderManager() {}

		// called at a variable frame rate by the game engine
		public override function update():void {
			Locator.gameObjectManager().update();
		}
	}
}