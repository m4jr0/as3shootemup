package shootemup.gameobject.ui {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.system.fscommand;

	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import engine.time.TimeManager;
	import shootemup.game.ShootEmUp;
	import shootemup.gameobject.input.InputComponent;

	// used to display the pause menu
	public class PauseMenuComponent extends Component {
		private var shootEmUp_: ShootEmUp = null;

		private var pauseMenuResumeButton_: SimpleButton = null;
		private var pauseMenuRestartButton_: SimpleButton = null;
		private var pauseMenuQuitButton_: SimpleButton = null;
		private var menuBackground_: MovieClip = null;

		private var input_: InputComponent = null;
		private var timeManager_: TimeManager = null;
		
		private var cooldownTime_: Number = 0.1;
		private var lastPressed_: Number = 0;
		private var isPaused_: Boolean = false;

		public override function update(): void {
			var currentInputs = this.input_.getInputs();
			
			if (!currentInputs["pause"]) {
				return;
			}
			
			var now: Number = this.timeManager_.getRealNow() / 1000;
			
			if (now - this.lastPressed_ < this.cooldownTime_) {
				return;
			}
			
			this.lastPressed_ = now;
			
			if (!this.isPaused_) {
				this.pauseGame();
			} else {
				this.resumeGame(null);
			}
		}

		public override function initialize(descr: Object = null): void {
			if (descr == null) {
				throw new Error("Description for menu component cannot be null");
			}

			this.type_ = "pause";

			if (descr["shootEmUp"] == null) {
				throw new Error("Missing mandatory argument: shoot 'em up game");
			}

			this.shootEmUp_ = descr["shootEmUp"]

			if (descr["pauseMenuResumeButton"] == null) {
				throw new Error("Missing mandatory argument: resume button");
			}

			this.pauseMenuResumeButton_ = descr["pauseMenuResumeButton"];

			if (descr["pauseMenuRestartButton"] == null) {
				throw new Error("Missing mandatory argument: restart button");
			}

			this.pauseMenuRestartButton_ = descr["pauseMenuRestartButton"];

			if (descr["pauseMenuQuitButton"] == null) {
				throw new Error("Missing mandatory argument: quit button");
			}

			this.pauseMenuQuitButton_ = descr["pauseMenuQuitButton"];

			if (descr["menuBackground"] == null) {
				throw new Error("Missing mandatory argument: menu background");
			}

			this.menuBackground_ = descr["menuBackground"];

			this.input_ = Locator.gameObjectManager().getPlayerGameObject().getComponent("input") as InputComponent;

			if (this.input_ == null) {
				throw new Error("Game object must have an input component");
			}

			this.shootEmUp_ = Locator.game() as ShootEmUp;
			this.timeManager_ = Locator.timeManager();

			this.pauseMenuResumeButton_.addEventListener(MouseEvent.CLICK, this.resumeGame);
			this.pauseMenuRestartButton_.addEventListener(MouseEvent.CLICK, this.restartGame);
			this.pauseMenuQuitButton_.addEventListener(MouseEvent.CLICK, this.quitGame);
			
			this.hide();
		}

		public function show(): void {
			this.pauseMenuResumeButton_.visible = true;
			this.pauseMenuRestartButton_.visible = true;
			this.pauseMenuQuitButton_.visible = true;
			this.menuBackground_.visible = true;
		}

		public function hide(): void {
			this.pauseMenuResumeButton_.visible = false;
			this.pauseMenuRestartButton_.visible = false;
			this.pauseMenuQuitButton_.visible = false;
			this.menuBackground_.visible = false;
		}

		private function pauseGame(): void {
			this.show();
			this.isPaused_ = true;
			this.timeManager_.stop();
		}

		private function resumeGame(mouseEvent: MouseEvent): void {
			this.hide();
			this.isPaused_ = false;
			this.timeManager_.resume();
		}

		private function restartGame(mouseEvent: MouseEvent): void {
			this.hide();
			this.isPaused_ = false;
			this.timeManager_.resume();
			this.shootEmUp_.start();
		}

		private function quitGame(mouseEvent: MouseEvent): void {
			fscommand("quit");
		}

		public function PauseMenuComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}