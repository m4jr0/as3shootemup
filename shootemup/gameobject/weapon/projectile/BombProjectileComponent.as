package shootemup.gameobject.weapon.projectile {
	import engine.gameobject.GameObject;

	public class BombProjectileComponent extends PlayerProjectileComponent {
		public override function initialize(descr: Object = null): void {
			super.initialize(descr);

			this.damage_ = 100;
			this.duration_ = 0.3;

			this.transform_.setX(this.transform_.getX());
			this.transform_.setY(this.transform_.getY());
		}

		public function BombProjectileComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
