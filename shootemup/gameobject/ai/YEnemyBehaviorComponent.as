package shootemup.gameobject.ai {
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import engine.utils.Utils;
	import shootemup.game.ShootEmUp;

	// specific behavior to move along the y-aligned axis
	public class YEnemyBehaviorComponent extends EnemyBehaviorComponent {
		private var direction_: int = 1;
		private var maxTop_: Number = 0;
		private var maxBottom_: Number = 0;

		protected override function move(): void {
			var currentY: Number = this.transform_.getY();
			var toMove: Number = this.velocity_["y"] * this.deltaTime_;

			if (this.direction_ > 0) {
				if (currentY + toMove > this.maxBottom_) {
					this.direction_ = -1;
				}
			} else {
				if (currentY + toMove < this.maxTop_) {
					this.direction_ = 1;
				}
			}

			this.transform_.setY(currentY + this.direction_ * toMove);
		}

		public override function initialize(descr: Object = null): void {
			super.initialize(descr);

			var maxBounds: Object = (Locator.game() as ShootEmUp).getSpawnZone();
			var top: Number = maxBounds["top"];
			var bottom: Number = maxBounds["bottom"];

			var limit1 = Utils.getRandomNumber(top, bottom);
			var limit2 = Utils.getRandomNumber(top, bottom);

			if (limit1 < limit2) {
				this.maxTop_ = limit1;
				this.maxBottom_ = limit2;
			} else {
				this.maxTop_ = limit2;
				this.maxBottom_ = limit1;
			}
		}

		public function YEnemyBehaviorComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
