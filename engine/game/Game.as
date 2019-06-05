package engine.game {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;

	import engine.gameobject.GameObjectManager;
	import engine.input.InputManager;
	import engine.locator.Locator;
	import engine.physics.PhysicsManager;
	import engine.render.RenderManager;
	import engine.time.TimeManager;

	// main class of the game engine
	public class Game {
		// where the action takes place
		protected var frame_: MovieClip = null;
		protected var stage_: Stage = null;
		// some useful attributes for the game engine configuration
		protected var gameData_: Object = null;

		// game managers
		protected var timeManager_: TimeManager = null;
		protected var renderManager_: RenderManager = null;
		protected var physicsManager_: PhysicsManager = null;
		protected var gameObjectManager_: GameObjectManager = null;
		protected var inputManager_: InputManager = null;

		protected var isRunning_: Boolean = false;
		protected var isDebug_: Boolean = false;
		// the physics loop refresh rate
		protected var msPerUpdate_: Number = 16.67; // ~60 Hz loop

		// how far behind we are when computing the physics after the rendering process
		protected var lag_: Number = 0;
		// how many physics refreshes in one second
		protected var physicsUpdates_: uint = 0;
		// how many rendering refreshes in one second
		protected var renderUpdates_: uint = 0;
		protected var previousPhysicsUpdateTime_: uint = 0;
		protected var previousRenderUpdateTime_: uint = 0;

		public function isRunning(): Boolean {
			return this.isRunning_;
		}

		public function isDebug(): Boolean {
			return this.isDebug_;
		}

		public function setIsDebug(isDebug: Boolean): void {
			this.isDebug_ = isDebug;
		}

		public function getFrame(): MovieClip {
			return this.frame_;
		}

		public function getStage(): Stage {
			return this.stage_;
		}

		public function getMsPerUpdate(): Number {
			return this.msPerUpdate_;
		}

		public function initialize(): void {
			Locator.initialize(this);

			this.timeManager_ = new TimeManager();
			this.renderManager_ = new RenderManager();
			this.physicsManager_ = new PhysicsManager();
			this.gameObjectManager_ = new GameObjectManager();
			this.inputManager_ = new InputManager();

			// the locator keeps track of every manager of the engine
			// to allow their access from anywhere
			Locator.setTimeManager(this.timeManager_);
			Locator.setRenderManager(this.renderManager_);
			Locator.setPhysicsManager(this.physicsManager_);
			Locator.setGameObjectManager(this.gameObjectManager_);
			Locator.setInputManager(this.inputManager_);

			this.timeManager_.initialize();
			this.renderManager_.initialize();
			this.physicsManager_.initialize();
			this.gameObjectManager_.initialize();
			this.inputManager_.initialize();
		}

		public function start(): void {
			trace('Starting game...')
			this.isRunning_ = true;
			this.frame_.addEventListener(Event.ENTER_FRAME, this.loop);
		}

		public function loop(event: Event): void {
			try {
				if (!this.isRunning_) {
					this.frame_.removeEventListener(Event.ENTER_FRAME, this.loop);
					return;
				}

				// we need to update the time
				this.timeManager_.update();

				var deltaTime: uint = this.timeManager_.getDeltaTime();

				// how far behing we are in the physics loop
				this.lag_ += deltaTime;
				this.previousPhysicsUpdateTime_ += deltaTime;
				this.previousRenderUpdateTime_ += deltaTime;

				if (this.previousPhysicsUpdateTime_ > 1000) {
					trace("Physics got updated " + this.physicsUpdates_ + " times");
					this.previousPhysicsUpdateTime_ = 0;
					this.physicsUpdates_ = 0;
				}

				// we update the physics to be back in the future
				while (this.lag_ >= this.msPerUpdate_) {
					this.physicsManager_.fixedUpdate();
					this.lag_ -= this.msPerUpdate_;
					++this.physicsUpdates_;
				}

				if (this.previousRenderUpdateTime_ > 1000) {
					trace("Rendering got updated " + this.renderUpdates_ + " times");
					this.previousRenderUpdateTime_ = 0;
					this.renderUpdates_ = 0;
				}

				// we display the game here
				this.renderManager_.update();
				++this.renderUpdates_;
			} catch (error: Error) {
				trace(error);
			}
		}

		public function Game(descr: Object): void {
			this.frame_ = descr["frame"];
			this.stage_ = descr["stage"];
			this.gameData_ = descr["gameData"];
			this.isDebug_ = descr["isDebug"];
		}
	}
}