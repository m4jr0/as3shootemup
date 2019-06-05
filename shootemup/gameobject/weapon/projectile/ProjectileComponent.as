package shootemup.gameobject.weapon.projectile {
	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import engine.time.TimeManager;
	import shootemup.gameobject.physics.TransformComponent;

	// generic projectile component
	public class ProjectileComponent extends Component {
		// used to update its position over time
		protected var transform_: TransformComponent = null;
		// used to destroy itself after some time
		protected var timeManager_: TimeManager = null;
		// how much damage it deals
		protected var damage_: int = 0;
		// keep track of when the projectile has been generated
		protected var initialTime_: Number = 0;
		// for how much time we want to keep it alive?
		protected var duration_: Number = 0;
		// used for the calculations
		private var deltaTime_: Number = 16.67; // ~60 Hz loop

		protected var velocity_: Object = {
			"x": 0,
			"y": 0
		};

		protected var direction_: Object = {
			"x": 0,
			"y": 0
		};

		public override function initialize(descr: Object = null): void {
			this.type_ = "projectile";
			this.transform_ = this.gameObject_.getComponent("transform") as TransformComponent;

			if (this.transform_ == null) {
				throw new Error("Game object must have a transform component");
			}

			this.timeManager_ = Locator.timeManager();
			this.initialTime_ = this.timeManager_.getRealNow() / 1000;
			this.deltaTime_ = Locator.game().getMsPerUpdate();
		}

		protected function move(): void {}

		public override function fixedUpdate(): void {
			if (this.isToBeDestroyed()) {
				this.gameObject_.destroy();
				return;
			}

			this.move();
		}

		// check whether the projectile needs to be destroyed or not
		protected function isToBeDestroyed(): Boolean {
			var now: Number = this.timeManager_.getRealNow() / 1000;

			return now - this.initialTime_ >= this.duration_;
		}

		public function getDamage(): int {
			return this.damage_;
		}

		public function ProjectileComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
