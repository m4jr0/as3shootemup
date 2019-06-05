package shootemup.gameobject.weapon {
	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.gameobject.GameObjectManager;
	import engine.locator.Locator;
	import shootemup.gameobject.physics.TransformComponent;

	public class WeaponComponent extends Component {
		protected var transform_: TransformComponent = null;
		protected var gameObjectManager_: GameObjectManager = null;

		// used to align the projectiles to the sprites
		protected var projectileOffsetX_ = 0;
		protected var projectileOffsetY_ = 85;

		public override function initialize(descr: Object = null): void {
			this.type_ = "weapon";

			this.transform_ = this.gameObject_.getComponent("transform") as TransformComponent;

			if (this.transform_ == null) {
				throw new Error("Game object must have a transform component");
			}

			this.gameObjectManager_ = Locator.gameObjectManager();

			if (descr == null) {
				return;
			}

			if (descr["projectileOffsetX"] != null) {
				this.projectileOffsetX_ = descr["projectileOffsetX"];
			}

			if (descr["projectileOffsetY"] != null) {
				this.projectileOffsetY_ = descr["projectileOffsetY"];
			}
		}

		// it will start on the game object that fires the projectile,
		// with some modifications (offsets) if needed to align the sprites
		// accordingly
		protected function getStartingPoint(): Object {
			var x: Number = this.transform_.getX();
			var y: Number = this.transform_.getY();

			return {
				"x": x + this.projectileOffsetX_,
				"y": y + this.projectileOffsetY_
			}
		}

		public function shoot(): void {}

		public function WeaponComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
