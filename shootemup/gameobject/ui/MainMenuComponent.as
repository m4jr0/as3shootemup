package shootemup.gameobject.ui {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import 	flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.system.fscommand;

	import engine.input.InputManager;
	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import shootemup.game.ShootEmUp;
	import engine.locator.Locator;

	// used to display the main menu of the game
	public class MainMenuComponent extends Component {
		private var shootEmUp_: ShootEmUp = null;
		private var inputManager_: InputManager = null;

		private var mainMenuPlayButton_: SimpleButton = null;
		private var mainMenuQuitButton_: SimpleButton = null;
		private var mainMenuQwertyKeyMap_: MovieClip = null;
		private var mainMenuAzertyKeyMap_: MovieClip = null;
		private var mainMenuKeyboardLayoutSwitchButton_: SimpleButton = null;
		private var mainMenuKeyboardLayoutLabel_: MovieClip = null;
		private var mainMenuControlsLabel_: TextField = null;
		private var mainMenuIsDebugModeButton_: SimpleButton = null;
		private var mainMenuIsDebugModeText_: TextField = null;
		private var menuBackground_: MovieClip = null;
		
		private var isQwerty_: Boolean = false; // could be more sophisticated			
		private var isDebugMode_: Boolean = false;

		public override function initialize(descr: Object = null): void {
			if (descr == null) {
				throw new Error("Description for menu component cannot be null");
			}

			this.type_ = "ui";

			if (descr["shootEmUp"] == null) {
				throw new Error("Missing mandatory argument: shoot 'em up game");
			}

			this.shootEmUp_ = descr["shootEmUp"]
			this.inputManager_ = Locator.inputManager();

			if (descr["mainMenuPlayButton"] == null) {
				throw new Error("Missing mandatory argument: play button");
			}

			this.mainMenuPlayButton_ = descr["mainMenuPlayButton"];

			if (descr["mainMenuQuitButton"] == null) {
				throw new Error("Missing mandatory argument: quit button");
			}

			this.mainMenuQuitButton_ = descr["mainMenuQuitButton"];
			
			if (descr["mainMenuQwertyKeyMap"] == null) {
				throw new Error("Missing mandatory argument: quit button");
			}

			this.mainMenuQwertyKeyMap_ = descr["mainMenuQwertyKeyMap"];

			if (descr["mainMenuAzertyKeyMap"] == null) {
				throw new Error("Missing mandatory argument: quit button");
			}

			this.mainMenuAzertyKeyMap_ = descr["mainMenuAzertyKeyMap"];

			if (descr["mainMenuKeyboardLayoutSwitchButton"] == null) {
				throw new Error("Missing mandatory argument: quit button");
			}

			this.mainMenuKeyboardLayoutSwitchButton_ = descr["mainMenuKeyboardLayoutSwitchButton"];

			if (descr["mainMenuKeyboardLayoutLabel"] == null) {
				throw new Error("Missing mandatory argument: keyboard layout labels");
			}

			this.mainMenuKeyboardLayoutLabel_ = descr["mainMenuKeyboardLayoutLabel"];

			if (descr["mainMenuControlsLabel"] == null) {
				throw new Error("Missing mandatory argument: controls label");
			}

			this.mainMenuControlsLabel_ = descr["mainMenuControlsLabel"];
								

			if (descr["mainMenuIsDebugModeButton"] == null) {
				throw new Error("Missing mandatory argument: isDebug mode button");
			}

			this.mainMenuIsDebugModeButton_ = descr["mainMenuIsDebugModeButton"];

			if (descr["mainMenuIsDebugModeText"] == null) {
				throw new Error("Missing mandatory argument: isDebug mode text");
			}

			this.mainMenuIsDebugModeText_ = descr["mainMenuIsDebugModeText"];
						
			if (descr["menuBackground"] == null) {
				throw new Error("Missing mandatory argument: menu background");
			}			

			this.menuBackground_ = descr["menuBackground"];

			this.mainMenuPlayButton_.removeEventListener(MouseEvent.CLICK, this.startGame);
			this.mainMenuQuitButton_.removeEventListener(MouseEvent.CLICK, this.quitGame);
			this.mainMenuKeyboardLayoutSwitchButton_.removeEventListener(MouseEvent.CLICK, this.switchLayoutHandler);
			this.mainMenuIsDebugModeButton_.removeEventListener(MouseEvent.CLICK, this.toggleDebugMode);

			this.mainMenuPlayButton_.addEventListener(MouseEvent.CLICK, this.startGame);
			this.mainMenuQuitButton_.addEventListener(MouseEvent.CLICK, this.quitGame);
			this.mainMenuKeyboardLayoutSwitchButton_.addEventListener(MouseEvent.CLICK, this.switchLayoutHandler);
			this.mainMenuIsDebugModeButton_.addEventListener(MouseEvent.CLICK, this.toggleDebugMode);
			
			// initialize ui
			this.switchLayout(this.isQwerty_);
		}
		
		function toggleDebugMode(mouseEvent: MouseEvent): void {
			this.isDebugMode_ = !this.isDebugMode_;
			
			if (this.isDebugMode_) {
				this.mainMenuIsDebugModeText_.text = "ON";
			} else {
				this.mainMenuIsDebugModeText_.text = "OFF";
			}
		}
		
		public function switchLayout(isQwerty: Boolean): void {
			this.isQwerty_ = isQwerty;
			
			if (this.isQwerty_) {
				this.mainMenuQwertyKeyMap_.visible = true;
				this.mainMenuAzertyKeyMap_.visible = false;
			} else {				
				this.mainMenuQwertyKeyMap_.visible = false;
				this.mainMenuAzertyKeyMap_.visible = true;
			}
			
			this.inputManager_.setKeyboardLayout(this.isQwerty_ ? "us" : "fr");
		}
		
		public function switchLayoutHandler(mouseEvent: MouseEvent): void {
			this.switchLayout(!this.isQwerty_);
		}

		public function show(): void {
			this.mainMenuPlayButton_.visible = true;
			this.mainMenuQuitButton_.visible = true;			
			this.mainMenuQwertyKeyMap_.visible = this.isQwerty_;
			this.mainMenuAzertyKeyMap_.visible = !this.isQwerty_;
			this.mainMenuKeyboardLayoutSwitchButton_.visible = this.isQwerty_;
			this.mainMenuKeyboardLayoutLabel_.visible = true;
			this.mainMenuControlsLabel_.visible = true;
			this.menuBackground_.visible = true;
			this.mainMenuIsDebugModeButton_.visible = true;
			this.mainMenuIsDebugModeText_.visible = true;
		}

		public function hide(): void {
			this.mainMenuPlayButton_.visible = false;
			this.mainMenuQuitButton_.visible = false;
			this.mainMenuQwertyKeyMap_.visible = false;
			this.mainMenuAzertyKeyMap_.visible = false;
			this.mainMenuKeyboardLayoutSwitchButton_.visible = false;
			this.mainMenuKeyboardLayoutLabel_.visible = false;
			this.mainMenuControlsLabel_.visible = false;
			this.menuBackground_.visible = false;
			this.mainMenuIsDebugModeButton_.visible = false;
			this.mainMenuIsDebugModeText_.visible = false;
		}

		private function startGame(mouseEvent: MouseEvent): void {
			this.hide();
			this.shootEmUp_.setIsDebug(this.isDebugMode_);
			this.shootEmUp_.start();
		}

		private function quitGame(mouseEvent: MouseEvent): void {
			fscommand("quit");
		}

		public function MainMenuComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}