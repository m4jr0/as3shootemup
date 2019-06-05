package shootemup.gameobject.input {
	import flash.events.KeyboardEvent;
	import flash.display.Stage;

	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.input.InputManager;
	import engine.locator.Locator;

	// player input component
	public class InputComponent extends Component {
		private var stage_: Stage = null;
		private var inputs_: Object = {};
		private var inputManager_: InputManager = null;
		private var keyMap_: Object = {};

		// we need to handle the two types of keyboards
		//
		// these hashmaps allow us to map actions with keys
		// pretty easily
		public function getQwertyKeyMap(): Object {
			return {
				"w": "up",
				"s": "down",
				"a": "left",
				"d": "right",
				"space": "shoot",
				"1": "bulletWeapon",
				"2": "plasmaWeapon",
				"e": "dropBomb",
				"escape": "pause"
			}
		}

		public function getAzertyKeyMap(): Object {
			return {
				"z": "up",
				"s": "down",
				"q": "left",
				"d": "right",
				"space": "shoot",
				"1": "bulletWeapon",
				"2": "plasmaWeapon",
				"e": "dropBomb",
				"escape": "pause"
			}
		}

		public override function initialize(descr: Object = null): void {
			this.type_ = "input";
			this.stage_ = Locator.game().getStage();
			this.inputManager_ = Locator.inputManager();

			var keyboardLayout: String = this.inputManager_.getKeyboardLayout();

			if (keyboardLayout == "us") {
				this.keyMap_ = this.getQwertyKeyMap();
			} else if (keyboardLayout == "fr") {
				this.keyMap_ = this.getAzertyKeyMap();
			} else {
				throw new Error("Unknown keyboard layout: " + keyboardLayout);
			}

			// is there an input that has been pressed?
			this.inputs_ = {
				"up": false,
				"down": false,
				"left": false,
				"right": false,
				"shoot": false,
				"bulletWeapon": false,
				"plasmaWeapon": false,
				"dropBomb": false,
				"pause": false
			};

			// input listeners, which will fire whenever an event happens
			this.stage_.removeEventListener(KeyboardEvent.KEY_UP, this.removeInput);
			this.stage_.addEventListener(KeyboardEvent.KEY_UP, this.removeInput);

			this.stage_.removeEventListener(KeyboardEvent.KEY_DOWN, this.addInput);
			this.stage_.addEventListener(KeyboardEvent.KEY_DOWN, this.addInput);
		}

		// replace the current detected inputs
		public function setInputs(inputs: Object): void {
			this.inputs_ = inputs;
		}

		// when the player presses a button
		public function addInput(event: KeyboardEvent): void {
			var input = this.keyMap_[InputManager.getChar(event.charCode)];

			if (input == null) {
				return;
			}

			this.inputs_[input] = true;
		}

		// when the player stops pressing a button
		public function removeInput(event: KeyboardEvent): void {
			var input = this.keyMap_[InputManager.getChar(event.charCode)];

			if (input == null) {
				return;
			}

			this.inputs_[input] = false;
		}
		
		public function resetInput(event: KeyboardEvent): void {
			this.inputs_["up"] = false;
			this.inputs_["down"] = false;
			this.inputs_["left"] = false;
			this.inputs_["right"] = false;
			this.inputs_["shoot"] = false;
			this.inputs_["dropBomb"] = false;
			this.inputs_["pause"] = false;
		}

		public function getInputs(): Object {
			return this.inputs_;
		}

		public function InputComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
