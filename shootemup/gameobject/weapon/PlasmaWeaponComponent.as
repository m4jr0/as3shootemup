package shootemup.gameobject.weapon {
	import engine.gameobject.GameObject;
	import shootemup.gameobject.level.Factory;

	public class PlasmaWeaponComponent extends PlayerWeaponComponent {
		public override function shoot(): void {
			this.gameObjectManager_.addGameObject(Factory.createPlasmaProjectile(this.getStartingPoint()));
		}

		public override function initialize(descr: Object = null): void {
			super.initialize(descr);
			this.cooldownTime_ = 0.5;
			this.projectileOffsetX_ = 7;
			this.name_ = "plasmaweapon";
		}

		public function PlasmaWeaponComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
