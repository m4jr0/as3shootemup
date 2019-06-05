package shootemup.gameobject.weapon.projectile {
	import engine.gameobject.GameObject;

	public class BulletProjectileComponent extends PlayerProjectileComponent {
		public override function initialize(descr: Object = null): void {
			super.initialize(descr);

			this.damage_ = 10;
			this.duration_ = 5;

			this.velocity_ = {
				"x": 0,
				"y": 10
			};

			this.direction_ = {
				"x": 0,
				"y": -1
			};
		}

		protected override function move(): void {
			this.transform_.setX(this.transform_.getX() + this.direction_["x"] * this.velocity_["x"]);
			this.transform_.setY(this.transform_.getY() + this.direction_["y"] * this.velocity_["y"]);
		}

		public function BulletProjectileComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
