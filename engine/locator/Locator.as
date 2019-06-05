package engine.locator {
	import engine.game.Game;
	import engine.gameobject.GameObjectManager;
	import engine.input.InputManager;
	import engine.physics.PhysicsManager;
	import engine.render.RenderManager;
	import engine.time.TimeManager;

	// static class which allows any function to access a game manager directly
	public class Locator {
		private static var physicsManager_ = null;
		private static var renderManager_ = null;
		private static var gameObjectManager_ = null;
		private static var inputManager_ = null;
		private static var timeManager_ = null;
		private static var game_ = null;

		public static function physicsManager(): PhysicsManager {
			return Locator.physicsManager_;
		}

		public static function renderManager(): RenderManager {
			return Locator.renderManager_;
		}

		public static function gameObjectManager(): GameObjectManager {
			return Locator.gameObjectManager_;
		}

		public static function inputManager(): InputManager {
			return Locator.inputManager_;
		}

		public static function timeManager(): TimeManager {
			return Locator.timeManager_;
		}

		public static function game(): Game {
			return Locator.game_;
		}

		public static function initialize(game: Game): void {
			Locator.game_ = game;
		}

		public static function setPhysicsManager(physicsManager: PhysicsManager): void {
			Locator.physicsManager_ = physicsManager;
		}

		public static function setRenderManager(renderManager: RenderManager): void {
			Locator.renderManager_ = renderManager;
		}

		public static function setGameObjectManager(gameObjectManager: GameObjectManager): void {
			Locator.gameObjectManager_ = gameObjectManager;
		}

		public static function setInputManager(inputManager: InputManager): void {
			Locator.inputManager_ = inputManager;
		}

		public static function setTimeManager(timeManager: TimeManager): void {
			Locator.timeManager_ = timeManager;
		}
	}
}