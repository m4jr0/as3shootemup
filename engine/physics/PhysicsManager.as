package engine.physics {
	import engine.game.Manager;
	import engine.locator.Locator;

	public class PhysicsManager extends Manager {
		public function PhysicsManager() {}

		// called at a 60 Hz rate (if unchanged) by the game engine
		public override function fixedUpdate(): void {
			Locator.gameObjectManager().fixedUpdate();
		}
	}
}