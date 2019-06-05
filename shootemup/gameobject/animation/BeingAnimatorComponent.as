package shootemup.gameobject.animation {
	import flash.display.MovieClip;
	import flash.display.Shape;

	import engine.gameobject.GameObject;
	import shootemup.gameobject.physics.TransformComponent;

	// animator which is specific for "alive" objects, such as the AI
	// and the player
	public class BeingAnimatorComponent extends AnimatorComponent {
		private var currentSprite_: MovieClip = null;
		private var defaultSprite_: MovieClip = null;
		private var hitSprite_: MovieClip = null;
		private var dieSprite_: MovieClip = null;
		private var transform_: TransformComponent = null;
		private var frame_: MovieClip = null;
		private var currentDebugShape_: Shape = null;
		private var rotation_: Number = 0;

		public function playDefaultAnimation(): void {
			this.updateSprite(this.defaultSprite_);
		}

		public function playHitAnimation(): void {
			if (this.hitSprite_ != null) {
				this.updateSprite(this.hitSprite_);
			} else {
				this.updateSprite(this.currentSprite_);
			}
		}

		public function playDieAnimation(): void {
			if (this.dieSprite_ != null) {
				this.updateSprite(this.dieSprite_);
			} else {
				this.updateSprite(this.currentSprite_);
			}
		}

		public override function initialize(descr: Object = null): void {
			if (descr == null) {
				throw new Error("You must provide a description for a being animator component");
			}

			super.initialize(descr);

			this.defaultSprite_ = descr["defaultSprite"];
			this.hitSprite_ = descr["hitSprite"];
			this.dieSprite_ = descr["dieSprite"];
		}

		public function BeingAnimatorComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
