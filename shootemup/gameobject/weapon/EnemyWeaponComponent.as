package shootemup.gameobject.weapon {
	import engine.gameobject.GameObject;
	import shootemup.gameobject.level.Factory;
	import shootemup.gameobject.weapon.projectile.ProjectileComponent;

	// only used by the AI minions
	public class EnemyWeaponComponent extends WeaponComponent {
		protected var projectile_: ProjectileComponent = null;

		public override function initialize(descr: Object = null): void {
			super.initialize(descr);

			this.name_ = "enemyweapon";
		}

		public override function shoot(): void {
			this.gameObjectManager_.addGameObject(Factory.createEnemyProjectile(this.getStartingPoint()));
		}

		public function EnemyWeaponComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
