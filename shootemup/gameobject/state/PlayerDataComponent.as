package shootemup.gameobject.state {
	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import shootemup.gameobject.input.InputComponent;
	import shootemup.gameobject.weapon.BulletWeaponComponent;
	import shootemup.gameobject.weapon.PlasmaWeaponComponent;
	import shootemup.gameobject.weapon.PlayerWeaponComponent;

	// keep track of the player's vital variables
	public class PlayerDataComponent extends Component {
		private var lives_: int = 3;
		private var score_: Number = 0;
		private var maxLives_: int = 9;

		private var input_: InputComponent = null;
		// what is the current weapon used?
		//
		// not including the bombs weapon, which is used separatly
		private var currentWeapon_: PlayerWeaponComponent = null;

		public override function fixedUpdate(): void {
			var inputs: Object = this.input_.getInputs();

			if (inputs["bulletWeapon"]) {
				this.switchWeapon(BulletWeaponComponent);
			} else if (inputs["plasmaWeapon"]) {
				this.switchWeapon(PlasmaWeaponComponent);
			}
		}

		protected function switchWeapon(weaponClass: Class): void {
			if (this.currentWeapon_ is weaponClass) {
				return; // nothing to do
			}

			this.gameObject_.removeComponent(this.currentWeapon_.getType());
			this.currentWeapon_ = new weaponClass(this.gameObject_);
			this.gameObject_.addComponent(this.currentWeapon_);
		}

		public override function initialize(descr: Object = null): void {
			this.type_ = "data";
			this.currentWeapon_ = this.gameObject_.getComponent("weapon") as PlayerWeaponComponent;

			if (this.currentWeapon_ == null) {
				throw new Error("Game object must have a weapon component");
			}

			this.input_ = this.gameObject_.getComponent("input") as InputComponent;

			if (this.input_ == null) {
				throw new Error("Game object must have an input component");
			}
		}

		public function addLife(): void {
			this.setLives(this.lives_ + 1);
		}

		public function removeLife(): void {
			this.setLives(this.lives_ - 1);
		}

		public function setLives(lives: int): void {
			this.lives_ = Math.max(0, Math.min(lives, this.maxLives_));
		}

		public function getLives(): int {
			return this.lives_;
		}

		public function increaseScore(toIncrease: Number): void {
			this.setScore(this.score_ + toIncrease);
		}

		public function decreaseScore(toDecrease: Number): void {
			this.setScore(this.score_ - toDecrease);
		}

		public function setScore(score: Number): void {
			this.score_ = score;
		}

		public function getScore(): Number {
			return this.score_;
		}

		public function getCurrentWeapon(): PlayerWeaponComponent {
			return this.currentWeapon_;
		}

		public function PlayerDataComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
