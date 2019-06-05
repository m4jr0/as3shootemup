package shootemup.gameobject.weapon {
	import engine.gameobject.GameObject;
	import shootemup.gameobject.level.Factory;

	public class BulletWeaponComponent extends PlayerWeaponComponent {
		public override function shoot(): void {
			this.gameObjectManager_.addGameObject(Factory.createBulletProjectile(this.getStartingPoint()));
		}

		public override function initialize(descr: Object = null): void {
			super.initialize(descr);
			this.name_ = "bulletweapon";
		}

		public function BulletWeaponComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
