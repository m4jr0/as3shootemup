package shootemup.gameobject.state {
	import flash.utils.setTimeout;

	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import shootemup.game.ShootEmUp;
	import shootemup.gameobject.ai.EnemyBehaviorComponent;
	import shootemup.gameobject.animation.BeingAnimatorComponent;
	import shootemup.gameobject.physics.PhysicsComponent;
	import shootemup.gameobject.weapon.projectile.EnemyProjectileComponent;

	// keep track of the player's states
	// would be much better to implement a state machine at this point
	public class PlayerStateComponent extends Component {
		private var data_: PlayerDataComponent = null;
		private var animator_: BeingAnimatorComponent = null;
		private var physics_: PhysicsComponent = null;
		private var isInvincible_: Boolean = false;
		private var duration_: Number = 1.5;
		private var lastTime_: Number = 0;
		private var deltaTime_: Number = 0;

		private var alphaLevel_: Number = 0.5;
		private var alphaInterval_: Number = 2;
		private var lastAlphaTime_: Number = 0;
		private var isAlpha_: Boolean = false;

		public override function update(): void {
			if (!this.isInvincible_) {
				return;
			}
			
			// will make the player blink
			if (this.lastAlphaTime_ >= this.alphaInterval_) {
				if (this.isAlpha_) {
					this.animator_.getCurrentSprite().alpha = 1;
					this.isAlpha_ = false;
				} else {
					this.animator_.getCurrentSprite().alpha = 0.5;
					this.isAlpha_ = true;
				}
			}
		}

		public override function fixedUpdate(): void {
			if (!this.isInvincible_) {
				return;
			}

			this.lastTime_ += this.deltaTime_ / 1000;
			this.lastAlphaTime_ += this.deltaTime_ / 1000;

			if (this.lastTime_ > this.duration_) {
				this.makeVulnerable();
			}
		}

		public function makeInvincible(): void {
			this.isInvincible_ = true;
			this.lastTime_ = 0;
			this.lastAlphaTime_ = this.duration_;
			this.isAlpha_ = false;
		}

		public function makeVulnerable(): void {
			this.isInvincible_ = false;
			this.animator_.getCurrentSprite().alpha = 1;
			this.isAlpha_ = false;
		}

		// will check if the player dies... or if at least he loses a life
		public override function onCollision(descr: Object): void {
			if (this.isInvincible_) {
				return;
			}

			var gameObject: GameObject = descr["from"].getGameObject();
			var projectile: EnemyProjectileComponent = gameObject.getComponent("projectile") as EnemyProjectileComponent;
			var enemy: EnemyBehaviorComponent = gameObject.getComponent("behavior") as EnemyBehaviorComponent;

			// the player got a projectile
			if (projectile != null) {
				projectile.getGameObject().destroy();
			// the player did not get a projectile nor an enemy
			} else if (enemy == null) {
				return;
			}

			// we do not want to destroy the enemy, that would be too easy...

			this.data_.removeLife();
			this.makeInvincible();

			if (this.data_.getLives() > 0) {
				return;
			}

			this.die();
		}

		private function die(): void {
			this.gameObject_.removeComponent("input");
			this.gameObject_.removeComponent("physics");
			// we cannot let the player move in that state
			this.physics_.setVelocityX(0);
			this.physics_.setVelocityY(0);
			this.physics_.setBoundsVelocityX(0);
			this.physics_.setBoundsVelocityY(0);
			this.animator_.playDieAnimation();

			// will allow the animation of dying finish entirely before loading
			// the ending menu
			setTimeout((Locator.game() as ShootEmUp).displayEndingLevel, 500);
		}

		public override function initialize(descr: Object = null): void {
			this.data_ = this.gameObject_.getComponent("data") as PlayerDataComponent;

			if (this.data_ == null) {
				throw new Error("Game object must have a data component");
			}

			this.animator_ = this.gameObject_.getComponent("animator") as BeingAnimatorComponent;

			if (this.animator_ == null) {
				throw new Error("Game object must have an animator component");
			}

			this.physics_ = this.gameObject_.getComponent("physics") as PhysicsComponent;

			if (this.physics_ == null) {
				throw new Error("Game object must have a physics component");
			}

			this.deltaTime_ = Locator.game().getMsPerUpdate();
		}

		public function PlayerStateComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
