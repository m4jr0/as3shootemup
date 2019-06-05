package shootemup.gameobject.collision {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import engine.game.Game;
	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import shootemup.gameobject.animation.AnimatorComponent;
	import shootemup.gameobject.physics.PhysicsComponent;

	// the sort of bounding box of the frame
	// will prevent the player form getting of the board
	// the AI is already safe-guarded by the movement implementations
	public class BoxComponent extends Component {
		private var bounds_: Rectangle = null;
		private var stage_: Stage = null;
		private var frame_: MovieClip = null;
		private var velocity_: Number = 0.3;
		private var leftMargin_: Number = 0;
		private var rightMargin_: Number = 0;
		private var topMargin_: Number = -20;
		private var bottomMargin_: Number = -40;
		private var playerGameObject_: GameObject = null;
		private var playerAnimator_: AnimatorComponent = null;
		private var playerPhysics_: PhysicsComponent = null;

		public override function initialize(descr: Object = null): void {
			this.type_ = "box";

			var game: Game = Locator.game();

			this.frame_ = game.getFrame();
			this.bounds_ = this.frame_.getBounds(game.getStage());
			this.stage_ = game.getStage();

			this.playerGameObject_ = Locator.gameObjectManager().getPlayerGameObject();
			this.playerAnimator_ = this.playerGameObject_.getComponent("animator") as AnimatorComponent;
			this.playerPhysics_ = this.playerGameObject_.getComponent("physics") as PhysicsComponent;
		}

		public function BoxComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}

		public override function fixedUpdate(): void {
			var bounds: Rectangle = this.playerAnimator_.getCurrentSprite().getBounds(this.stage_);

			this.keepItContained(bounds);
		}

		public function keepItContained(bounds: Rectangle): void {
			var localTopLeft: Point = this.frame_.globalToLocal(new Point(this.bounds_.left, this.bounds_.top));
			var localBottomRight: Point = this.frame_.globalToLocal(new Point(this.bounds_.right, this.bounds_.bottom));
			var isCollision: Boolean = false;

			if (bounds.left - bounds.width / 2 - this.leftMargin_ < this.bounds_.left) {
				this.playerPhysics_.setBoundsVelocityX(this.velocity_);
				isCollision = true;
			}

			if (bounds.right + bounds.width / 2 + this.rightMargin_ > this.bounds_.right) {
				this.playerPhysics_.setBoundsVelocityX(-this.velocity_);
				isCollision = true;
			}

			if (bounds.top - bounds.height / 2 - this.topMargin_ < this.bounds_.top) {
				this.playerPhysics_.setBoundsVelocityY(this.velocity_);
				isCollision = true;
			}

			if (bounds.bottom + bounds.height / 2 + this.bottomMargin_ > this.bounds_.bottom) {
				this.playerPhysics_.setBoundsVelocityY(-this.velocity_);
				isCollision = true;
			}

			if (isCollision) {
				this.playerGameObject_.onCollision({
					"from": this,
					"with": bounds
				});
			}
		}
	}
}
