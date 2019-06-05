package shootemup.game {
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Rectangle;

	import engine.game.Game;
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import shootemup.gameobject.level.Factory;
	import shootemup.gameobject.state.PlayerDataComponent;
	import shootemup.gameobject.ui.EndingMenuComponent;
	import shootemup.gameobject.ui.MainMenuComponent;

	// specific game engine for our Ankama test
	public class ShootEmUp extends Game {
		// used to drawn the AI bounds when the debug mode is enabled
		private var AIBoundsDebugShape_: Shape = null;
		private var maxEnemies_: uint = 5;

		// x-oriented margin to prevent enemy spawning from being too close to the left/right borders
		private var AIMargin_: Number = 75;

		// zone where the enemies spawn
		private var spawnZone_: Object = {};

		public function getAIMargin(): Number {
			return this.AIMargin_;
		}

		public function getSpawnZone(): Object {
			return this.spawnZone_;
		}

		public override function initialize(): void {
			super.initialize();
			// set where the AI can spawn
			this.spawnZone_ = this.getAIBounds();
		}

		// initialize the level
		public function setUpLevel(): void {
			this.gameObjectManager_.destroyEverything();

			// create the player
			var player: GameObject = Factory.createPlayer();
			// add the player
			this.gameObjectManager_.addPlayer(player);			
			// add the level with some configuration object and the player
			this.gameObjectManager_.addLevel(Factory.createLevel(this.gameData_, player));
		}
		
		// called to display the total score and restart/quit the game
		public function displayEndingLevel(): void {
			this.timeManager_.stop();
			
			var player: GameObject = this.gameObjectManager_.getPlayerGameObject();
			var playerData: PlayerDataComponent = player.getComponent("data") as PlayerDataComponent;				
			var totalScore: Number = playerData.getScore();
			
			this.gameObjectManager_.destroyEverything();	
			
			var endingMenu: GameObject = new GameObject();
			this.gameData_["totalScore"] = totalScore;
			var endingMenuComponent: EndingMenuComponent = new EndingMenuComponent(endingMenu, this.gameData_);
			endingMenu.addComponent(endingMenuComponent);

			this.gameObjectManager_.addGameObject(endingMenu);
			
			endingMenuComponent.show();
		}

		// called at the very beginning to display the main menu which will allow to start/quit the game,
		// set the debug mode and change the keyboard layout configuration
		public function startMainMenu(): void {
			trace('Starting main menu...')
			this.gameObjectManager_.destroyEverything();

			this.gameData_["shootEmUp"] = this;
			var mainMenu: GameObject = new GameObject();
			mainMenu.addComponent(new MainMenuComponent(mainMenu, this.gameData_));

			this.gameObjectManager_.addGameObject(mainMenu);
		}

		// called when starting the game
		public override function start(): void {
			trace('Starting game...')
			this.setUpLevel();
			this.isRunning_ = true;
			this.timeManager_.setTimeScale(1.0);
			this.frame_.removeEventListener(Event.ENTER_FRAME, this.loop);
			this.frame_.addEventListener(Event.ENTER_FRAME, this.loop);
		}

		// return a specific box where the AI is allowed to spawn
		public function getAIBounds(): Object {
			var bounds: Rectangle = this.frame_.getBounds(this.stage_);

			var left: Number = bounds.left - bounds.width / 2 + this.AIMargin_;
			var right: Number = bounds.right - bounds.width / 2 - this.AIMargin_ - this.AIMargin_ / 2;
			var top: Number = bounds.top;
			var bottom: Number = bounds.bottom - bounds.height / 2 - 100;

			if (this.AIBoundsDebugShape_ != null) {
				this.frame_.removeChild(this.AIBoundsDebugShape_);
				this.AIBoundsDebugShape_ = null;
			}

			if (this.isDebug_) {
				this.AIBoundsDebugShape_ = new Shape();
				this.AIBoundsDebugShape_.graphics.lineStyle(1.5);
				this.AIBoundsDebugShape_.graphics.drawRect(left, top, right, bottom);
				this.frame_.addChild(this.AIBoundsDebugShape_);
			}

			return {
				"left": left,
				"right": right,
				"top": top,
				"bottom": bottom
			}
		}

		public function ShootEmUp(descr: Object): void {
			super(descr);
		}
	}
}