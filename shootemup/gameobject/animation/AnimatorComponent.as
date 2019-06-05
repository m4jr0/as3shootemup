package shootemup.gameobject.animation {
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Rectangle;

	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import engine.utils.Utils;
	import shootemup.gameobject.physics.TransformComponent;

	// component to add/remove/update sprites
	public class AnimatorComponent extends Component {
		private var currentSprite_: MovieClip = null;
		private var transform_: TransformComponent = null;
		private var frame_: MovieClip = null;
		private var currentDebugShape_: Shape = null;
		private var rotation_: Number = 0;

		public override function initialize(descr: Object = null): void {
			this.type_ = "animator";

			this.transform_ = this.gameObject_.getComponent("transform") as TransformComponent;

			if (this.transform_ == null) {
				throw new Error("Game object must have a transform component");
			}

			var defaultSprite = descr["defaultSprite"];

			if (defaultSprite == null) {
				throw new Error("Sprite cannot be null");
			}

			if (descr != null) {
				if (descr["defaultRotation"] != null) {
					this.rotation_ = descr["defaultRotation"];
				}
			}

			this.frame_ = Locator.game().getFrame();
			this.updateSprite(defaultSprite);
		}

		public override function destroy(): void {
			if (this.currentSprite_ != null) {
				try{
					this.frame_.removeChild(this.currentSprite_);					
				} catch (error: Error) {
					trace(error);
				}
			}

			if (this.currentDebugShape_ != null) {
				try {
					this.frame_.removeChild(this.currentDebugShape_);
				} catch (error: Error) {
					trace(error);
				}
				
				this.currentDebugShape_ = null;
			}
		}

		public function updateSprite(newSprite: MovieClip): void {
			if (this.currentSprite_ != null) {
				try {
					this.frame_.removeChild(this.currentSprite_);
				} catch (error: Error) {
					trace(error);
				}
			}
			
			if (this.currentDebugShape_ != null) {
				try {
					this.frame_.removeChild(this.currentDebugShape_);
				} catch (error: Error) {
					trace(error);
				}
				
				this.currentDebugShape_ = null;
			}

			this.currentSprite_ = newSprite;
			this.currentSprite_.rotation = this.rotation_;
			this.currentSprite_.x = this.transform_.getX();
			this.currentSprite_.y = this.transform_.getY();

			if (Locator.game().isDebug()) {
				Utils.addOutline(this.currentSprite_);
			}

			this.frame_.addChild(this.currentSprite_);
		}

		public function getCurrentSprite(): MovieClip {
			return this.currentSprite_;
		}

		public override function update(): void {
			this.currentSprite_.x = this.transform_.getX();
			this.currentSprite_.y = this.transform_.getY();

			if (this.currentDebugShape_ != null) {
				try {
					this.frame_.removeChild(this.currentDebugShape_);
				} catch (error: Error) {
					trace(error);
				}
				
				this.currentDebugShape_ = null;
			}

			if (!Locator.game().isDebug()) {
				return;
			}

			var bounds: Rectangle = this.currentSprite_.getBounds(this.frame_);
			this.currentDebugShape_ = new Shape();

			this.currentDebugShape_.graphics.lineStyle(1.5);
			this.currentDebugShape_.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);

			this.frame_.addChild(this.currentDebugShape_);
		}

		public function AnimatorComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
