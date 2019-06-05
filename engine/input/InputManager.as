package engine.input {
	import engine.game.Manager;

	public class InputManager extends Manager {
		private var keyboardLayout_: String = "us";
		
		public function InputManager() {}
		
		public function getKeyboardLayout(): String {
			return this.keyboardLayout_;
		}			
		
		// useful when dealing with multiple keyboard configurations
		public function setKeyboardLayout(keyboardLayout: String): void {
			if (this.keyboardLayout_ !== "us" && this.keyboardLayout_ !== "fr") {
				throw new Error("Unsupported keyboard layout: " + keyboardLayout);
			}
			
			this.keyboardLayout_ = keyboardLayout;
		}

		public static function getKeyCode(char: String): Number {
			return char.charCodeAt(0);
		}

		public static function getChar(keyCode: uint): String {
			// special cases
			if (keyCode == 32) {
				return "space";
			} else if (keyCode == 27) {
				return "escape"
			}
			
			return String.fromCharCode(keyCode).toLocaleLowerCase();
		}
		
		public override function initialize(): void {
			// this.keyboardLayout_ = "fr";
		}
	}
}