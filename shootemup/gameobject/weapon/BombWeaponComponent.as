package shootemup.gameobject.weapon {
	import engine.gameobject.GameObject;
	import shootemup.gameobject.level.Factory;

	// very specific weapon: it is worn separatly from the other player's weapons (bullets, plasma)
	public class BombWeaponComponent extends PlayerWeaponComponent {
		// it also has some ammo compared to the two others
		protected var bombsLeft_: uint = 0;
		// ... and a maximum number, just in case
		private var maxBombs_: int = 9;

		public override function shoot(): void {
			this.gameObjectManager_.addGameObject(Factory.createBombProjectile(this.getStartingPoint()));
			this.removeBomb();
		}

		protected override function handleInputs(): void {
			this.lastShotTime_ += this.deltaTime_ / 1000;

			if (this.lastShotTime_ < this.cooldownTime_) {
				return;
			}

			var currentInputs: Object = this.input_.getInputs();

			if (currentInputs["dropBomb"] && this.bombsLeft_ > 0) {
				this.lastShotTime_ = 0;
				this.shoot();
			}
		}

		public override function initialize(descr: Object = null): void {
			super.initialize(descr);

			this.type_ = "bomb";
			this.name_ = "bombweapon";

			this.cooldownTime_ = 1;
			this.projectileOffsetX_ = 0;
			this.projectileOffsetY_ = -100;

			this.bombsLeft_ = this.maxBombs_;

			// allow the player to fire immediately
			this.lastShotTime_ = this.cooldownTime_;
		}

		public function addBomb(): void {
			this.setBombs(this.bombsLeft_ + 1);
		}

		public function removeBomb(): void {
			this.setBombs(this.bombsLeft_ - 1);
		}

		public function setBombs(bombs: Number): void {
			this.bombsLeft_ = Math.max(0, Math.min(bombs, this.maxBombs_));
		}

		public function getBombsLeft(): uint {
			return this.bombsLeft_;
		}

		public function BombWeaponComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
