package shootemup.gameobject.weapon {
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import shootemup.gameobject.input.InputComponent;
	import shootemup.gameobject.level.Factory;
	import shootemup.gameobject.weapon.projectile.ProjectileComponent;

	// generic player weapon component
	public class PlayerWeaponComponent extends WeaponComponent {
		protected var projectile_: ProjectileComponent = null;
		protected var input_: InputComponent = null;
		protected var cooldownTime_: Number = 0.2;
		protected var lastShotTime_: Number = 0;
		protected var deltaTime_: Number = 0;

		public override function fixedUpdate(): void {
			this.handleInputs();
		}

		protected function handleInputs(): void {
			this.lastShotTime_ += this.deltaTime_ / 1000;

			// avoid spamming, but still allows continuous firing
			if (this.lastShotTime_ < this.cooldownTime_) {
				return;
			}

			var currentInputs: Object = this.input_.getInputs();

			if (currentInputs["shoot"]) {
				this.lastShotTime_ = 0;
				this.shoot();
			}
		}

		public override function initialize(descr: Object = null): void {
			super.initialize(descr);

			this.name_ = "playerweapon";

			this.input_ = this.gameObject_.getComponent("input") as InputComponent;

			if (this.input_ == null) {
				throw new Error("Game object must have an input component");
			}

			this.deltaTime_ = Locator.game().getMsPerUpdate();

			this.projectileOffsetX_ = 0;
			this.projectileOffsetY_ = -33;
			// allow the player to fire immediately
			this.lastShotTime_ = this.cooldownTime_;
		}

		public override function shoot(): void {
			this.gameObjectManager_.addGameObject(Factory.createEnemyProjectile(this.getStartingPoint()));
		}

		public function PlayerWeaponComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
