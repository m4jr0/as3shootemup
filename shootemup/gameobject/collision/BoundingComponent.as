package shootemup.gameobject.collision {
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.gameobject.GameObjectManager;
	import engine.locator.Locator;
	import shootemup.gameobject.animation.AnimatorComponent;

	// generic bounding component to detect collisions
	// work with the hitTestObject function, which is not the
	// best nor the quickest
	// it should be replaced with a specific collision detection
	// implementation
	public class BoundingComponent extends Component {
		private var animator_: AnimatorComponent = null;
		private var gameObjectManager_: GameObjectManager = null;

		public override function initialize(descr: Object = null): void {
			this.type_ = "bounds";

			this.animator_ = this.gameObject_.getComponent("animator") as AnimatorComponent;

			if (this.animator_ == null) {
				throw new Error("Game object must have an animator component");
			}

			this.gameObjectManager_ = Locator.gameObjectManager();
		}

		public override function fixedUpdate(): void {
			var currentSprite: MovieClip = this.animator_.getCurrentSprite();
			var gameObjectDict: Dictionary = this.gameObjectManager_.getGameObjectDict();

			for each(var gameObject: GameObject in gameObjectDict) {
				if (gameObject == this.gameObject_) {
					continue;
				}

				var otherBounds = gameObject.getComponent("bounds") as BoundingComponent;

				if (otherBounds == null) {
					continue;
				}

				var otherAnimator = gameObject.getComponent("animator") as AnimatorComponent;

				if (otherAnimator == null) {
					continue;
				}

				var otherCurrentSprite = otherAnimator.getCurrentSprite();

				if (otherCurrentSprite == null) {
					continue;
				}

				if (!currentSprite.hitTestObject(otherCurrentSprite)) {
					continue;
				}

				// we tell the game object with which and from which the collision has been detected
				this.gameObject_.onCollision({
					"from": otherBounds,
					"with": this
				})
			}
		}

		public function BoundingComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
