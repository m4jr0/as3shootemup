package shootemup.gameobject.ui {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.system.fscommand;

	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import shootemup.game.ShootEmUp;

	// used when displaying the ending menu
	public class EndingMenuComponent extends Component {
		private var shootEmUp_: ShootEmUp = null;

		private var endingMenuRestartButton_: SimpleButton = null;
		private var endingMenuQuitButton_: SimpleButton = null;
		private var endingMenuTotalScoreLabel_: MovieClip = null;
		private var endingMenuTotalScoreContainer_: MovieClip = null;
		private var menuBackground_: MovieClip = null;

		public override function initialize(descr: Object = null): void {
			if (descr == null) {
				throw new Error("Description for menu component cannot be null");
			}

			this.type_ = "ending";

			if (descr["shootEmUp"] == null) {
				throw new Error("Missing mandatory argument: shoot 'em up game");
			}

			this.shootEmUp_ = descr["shootEmUp"]

			if (descr["endingMenuRestartButton"] == null) {
				throw new Error("Missing mandatory argument: restart button");
			}

			this.endingMenuRestartButton_ = descr["endingMenuRestartButton"];

			if (descr["endingMenuQuitButton"] == null) {
				throw new Error("Missing mandatory argument: quit button");
			}

			this.endingMenuQuitButton_ = descr["endingMenuQuitButton"];

			if (descr["endingMenuTotalScoreLabel"] == null) {
				throw new Error("Missing mandatory argument: total score label");
			}

			this.endingMenuTotalScoreLabel_ = descr["endingMenuTotalScoreLabel"];

			if (descr["endingMenuTotalScoreContainer"] == null) {
				throw new Error("Missing mandatory argument: total score");
			}

			this.endingMenuTotalScoreContainer_ = descr["endingMenuTotalScoreContainer"];
			this.endingMenuTotalScoreContainer_.endingMenuTotalScoreText.text = descr["totalScore"].toString(10);

			if (descr["menuBackground"] == null) {
				throw new Error("Missing mandatory argument: menu background");
			}

			this.menuBackground_ = descr["menuBackground"];

			this.endingMenuRestartButton_.addEventListener(MouseEvent.CLICK, this.restartGame);
			this.endingMenuQuitButton_.addEventListener(MouseEvent.CLICK, this.quitGame);
		}

		public function show(): void {
			this.endingMenuRestartButton_.visible = true;
			this.endingMenuQuitButton_.visible = true;
			this.menuBackground_.visible = true;
			this.endingMenuTotalScoreLabel_.visible = true;
			this.endingMenuTotalScoreContainer_.visible = true;
		}

		public function hide(): void {
			this.endingMenuRestartButton_.visible = false;
			this.endingMenuQuitButton_.visible = false;
			this.menuBackground_.visible = false;
			this.endingMenuTotalScoreLabel_.visible = false;
			this.endingMenuTotalScoreContainer_.visible = false;
		}

		private function restartGame(mouseEvent: MouseEvent): void {
			this.hide();
			this.shootEmUp_.start();
		}

		private function quitGame(mouseEvent: MouseEvent): void {
			fscommand("quit");
		}

		public function updateUI(): void {}

		public function EndingMenuComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}