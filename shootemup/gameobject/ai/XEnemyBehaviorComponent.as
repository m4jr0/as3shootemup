package shootemup.gameobject.ai {
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import engine.utils.Utils;
	import shootemup.game.ShootEmUp;

	// specific behavior to move along the x-aligned axis
	public class XEnemyBehaviorComponent extends EnemyBehaviorComponent {
		private var direction_: int = 1;
		private var maxLeft_: Number = 0;
		private var maxRight_: Number = 0;

		protected override function move(): void {
			var currentX: Number = this.transform_.getX();
			var toMove: Number = this.velocity_["x"] * this.deltaTime_;

			if (this.direction_ > 0) {
				if (currentX + toMove > this.maxRight_) {
					this.direction_ = -1;
				}
			} else {
				if (currentX + toMove < this.maxLeft_) {
					this.direction_ = 1;
				}
			}

			this.transform_.setX(currentX + this.direction_ * toMove);
		}

		public override function initialize(descr: Object = null): void {
			super.initialize(descr);

			var maxBounds: Object = (Locator.game() as ShootEmUp).getSpawnZone();
			var left: Number = maxBounds["left"];
			var right: Number = maxBounds["right"];

			var limit1 = Utils.getRandomNumber(left, right);
			var limit2 = Utils.getRandomNumber(left, right);

			if (limit1 < limit2) {
				this.maxLeft_ = limit1;
				this.maxRight_ = limit2;
			} else {
				this.maxLeft_ = limit2;
				this.maxRight_ = limit1;
			}
		}

		public function XEnemyBehaviorComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
