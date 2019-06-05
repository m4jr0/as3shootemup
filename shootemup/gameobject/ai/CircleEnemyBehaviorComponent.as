package shootemup.gameobject.ai {
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import engine.utils.Utils;
	import shootemup.game.ShootEmUp;

	// specific behavior to move in circles
	public class CircleEnemyBehaviorComponent extends EnemyBehaviorComponent {
		private var center_: Object = null;
		private var radius_: Number = 0;
		private var currentAngle_: Number = 90;
		private var period_: Number = 1;
		private var minPeriod_: Number = 0.002;
		private var maxPeriod_: Number = 0.006;

		protected override function move(): void {
			var centerX: Number = this.spawnPoint_["x"];
			var centerY: Number = this.spawnPoint_["y"];
			this.currentAngle_ += this.period_ * this.deltaTime_;
			
			var toMoveX: Number = centerX +  Math.cos(this.currentAngle_) * this.radius_;
			var toMoveY: Number = centerY +  Math.sin(this.currentAngle_) * this.radius_;
			
			this.transform_.setX(toMoveX);
			this.transform_.setY(toMoveY);
		}

		public override function initialize(descr: Object = null): void {
			super.initialize(descr);

			// we need to generate a radius which is in the spawning box and at the same time
			// has its center with the same value than the original spawn point
			var maxBounds: Object = (Locator.game() as ShootEmUp).getSpawnZone();
			
			var maxX1: Number = this.spawnPoint_["x"] - maxBounds["left"];
			var maxX2: Number = maxBounds["right"] - this.spawnPoint_["x"];
			var maxY1: Number = this.spawnPoint_["y"] - maxBounds["top"];
			var maxY2: Number = maxBounds["bottom"] - this.spawnPoint_["y"];
			
			var maxRadius: Number = Math.min(maxX1, Math.min(maxX2, Math.min(maxY1, maxY2)));
			
			// we generate the new radius between nothing and the max
			this.radius_ = Utils.getRandomNumber(0, maxRadius);
			this.period_ = Utils.getRandomNumber(this.minPeriod_, this.maxPeriod_);
			this.center_ = this.spawnPoint_;
						
			// we want to move the spawn point upwards to avoid weird behaviors when the AI spawns
			// (it must get to the spawn point first, then move around its center)
			this.spawnPoint_ = {
				"x": this.center_["x"],
				"y": this.center_["y"] - this.radius_
			};

			this.spawnDirection_ = Utils.getDirection({
				"x": this.transform_.getX(),
				"y": this.transform_.getY()
			}, this.spawnPoint_);
		}

		public function CircleEnemyBehaviorComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
