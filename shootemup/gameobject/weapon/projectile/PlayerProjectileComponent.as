package shootemup.gameobject.weapon.projectile {
	import engine.gameobject.GameObject;

	public class PlayerProjectileComponent extends ProjectileComponent {
		public override function initialize(descr: Object = null): void {
			super.initialize(descr);

			this.name_ = "playerprojectile";
		}

		public function PlayerProjectileComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
