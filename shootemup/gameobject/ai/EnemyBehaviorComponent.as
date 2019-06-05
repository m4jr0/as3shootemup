package shootemup.gameobject.ai {
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import engine.utils.Utils;
	import shootemup.gameobject.animation.BeingAnimatorComponent;
	import shootemup.gameobject.level.EnemyGeneratorComponent;
	import shootemup.gameobject.level.Factory;
	import shootemup.gameobject.physics.TransformComponent;
	import shootemup.gameobject.state.EnemyDataComponent;
	import shootemup.gameobject.state.PlayerDataComponent;
	import shootemup.gameobject.weapon.EnemyWeaponComponent;
	import shootemup.gameobject.weapon.projectile.BombProjectileComponent;
	import shootemup.gameobject.weapon.projectile.PlayerProjectileComponent;

	// master class of the enemy behavior
	// for specific movements, please have a look on the child classes
	public class EnemyBehaviorComponent extends Component {
		protected var deltaTime_: Number = 16.67; // ~60 Hz loop
		// how frequently it will shoot
		protected var maxShotInterval_: Number = 6;
		protected var minShotInterval_: Number = 4;
		protected var currentShotInterval_: Number = 0;
		protected var lastShotTime_: Number = 0;
		
		// some variables to allow the IA to get to the spawn point
		protected var hasArrived_: Boolean = false;
		protected var spawnPoint_: Object = null;
		protected var spawnDirection_: Object = null;

		// some specific variables for its animations
		protected var dyingAnimationLength_: Number = 2;
		protected var hitAnimationLength_: Number = 1;
		protected var hitAnimationTimeout_: Number = -1;

		// needed components to work with regularly
		protected var transform_: TransformComponent = null;
		protected var data_: EnemyDataComponent = null;
		protected var animator_: BeingAnimatorComponent = null;
		protected var weapon_: EnemyWeaponComponent = null;
		protected var playerData_: PlayerDataComponent = null;

		// informs the enemy generator of its state to keep track of
		// how many enemies there are on the map
		protected var enemyGenerator_: EnemyGeneratorComponent = null;

		// regular velocity
		protected var velocity_: Object = {
			"x": 0.05,
			"y": 0.05
		};

		// velocity to reach the spawn point
		protected var spawnVelocity_: Object = {
			"x": 0.15,
			"y": 0.15
		};

		// to be implented in the children classes
		protected function move(): void {}

		// shoot with pauses between each shot
		protected function shoot(): void {
			this.lastShotTime_ += this.deltaTime_ / 1000;

			if (this.lastShotTime_ < this.currentShotInterval_) {
				return;
			}

			this.lastShotTime_ = 0;
			this.generateShotInterval();
			this.weapon_.shoot();
		}

		// we want to make the shots kind of random
		protected function generateShotInterval(): void {
			this.currentShotInterval_ = Utils.getRandomNumber(this.minShotInterval_, this.maxShotInterval_);
		}

		// allow the AI to reach the spawn point
		public function moveToSpawnPoint(): void {
			var currentX: Number = this.transform_.getX();
			var currentY: Number = this.transform_.getY();

			var toMoveX: Number = this.spawnVelocity_["x"] * this.deltaTime_;
			var toMoveY: Number = this.spawnVelocity_["y"] * this.deltaTime_;

			toMoveX = currentX + this.spawnDirection_["x"] * toMoveX;
			toMoveY = currentY + this.spawnDirection_["y"] * toMoveY;

			this.transform_.setX(toMoveX);
			this.transform_.setY(toMoveY);

			this.hasArrived_ = toMoveY > this.spawnPoint_["y"];
		}

		public override function fixedUpdate(): void {
			if (!this.hasArrived_) {
				this.moveToSpawnPoint();
				return;
			}

			this.move();
			this.shoot();
		}

		public override function destroy(): void {
			this.enemyGenerator_.decreaseEnemiesCount();
		}

		// process default (idle) animation
		public function makeItDefault(): void {
			this.hitAnimationTimeout_ = -1;
			this.animator_.playDefaultAnimation();
		}

		// process hit animation
		public function makeItHit(): void {
			if (this.hitAnimationTimeout_ != -1) {
				clearTimeout(this.hitAnimationTimeout_);
				this.hitAnimationTimeout_ = -1;
			}

			this.animator_.playHitAnimation();
			this.hitAnimationTimeout_ = setTimeout(this.makeItDefault, this.hitAnimationLength_ * 1000);
		}

		// process dying animation animation + kill the beast
		public function makeItDie(): void {
			if (this.hitAnimationTimeout_ != -1) {
				clearTimeout(this.hitAnimationTimeout_);
				this.hitAnimationTimeout_ = -1;
			}

			this.playerData_.increaseScore(this.data_.getReward());
			this.gameObject_.removeComponent("bounds");
			this.animator_.playDieAnimation();
			this.velocity_ = this.spawnVelocity_ = { "x": 0.0, "y": 0.0 };
			setTimeout(this.gameObject_.destroy, this.dyingAnimationLength_ * 1000);
		}

		// called whenever it gets hit by the player's projectiles
		public override function onCollision(descr: Object): void {
			var gameObject: GameObject = descr["from"].getGameObject();
			var projectile: PlayerProjectileComponent = gameObject.getComponent("projectile") as PlayerProjectileComponent;

			if (projectile == null) {
				return;
			}

			// we do not want to destroy the bomb animations as well
			// this kind of projectile will handle its autodestruction itself
			if (!(projectile is BombProjectileComponent)) {
				projectile.getGameObject().destroy();
			}

			this.data_.setLives(this.data_.getLives() - projectile.getDamage());

			if (this.data_.getLives() > 0) {
				this.makeItHit();
			} else {
				this.makeItDie();
			}
		}

		public override function initialize(descr: Object = null): void {
			this.type_ = "behavior";

			this.data_ = this.gameObject_.getComponent("data") as EnemyDataComponent;

			if (this.data_ == null) {
				throw new Error("Game object must have a data component");
			}

			this.transform_ = this.gameObject_.getComponent("transform") as TransformComponent;

			if (this.transform_ == null) {
				throw new Error("Game object must have a transform component");
			}

			this.weapon_ = this.gameObject_.getComponent("weapon") as EnemyWeaponComponent;

			if (this.weapon_ == null) {
				throw new Error("Game object must have a weapon component");
			}

			this.animator_ = this.gameObject_.getComponent("animator") as BeingAnimatorComponent;

			if (this.animator_ == null) {
				throw new Error("Game object must have an animator component");
			}

			this.deltaTime_ = Locator.game().getMsPerUpdate();

			if (descr != null) {
				if (descr["maxShotInterval"] != null) {
					this.maxShotInterval_ = descr["maxShotInterval"];
				}

				if (descr["minShotInterval"] != null) {
					this.minShotInterval_ = descr["minShotInterval"];
				}
			}

			this.lastShotTime_ = this.deltaTime_ / 1000;
			this.generateShotInterval();

			var player: GameObject = Locator.gameObjectManager().getPlayerGameObject();
			this.playerData_ = player.getComponent("data") as PlayerDataComponent;

			if (this.playerData_ == null) {
				throw new Error("Player game object must have a data component");
			}

			var level: GameObject = Locator.gameObjectManager().getLevelGameObject();
			this.enemyGenerator_ = level.getComponent('enemygenerator') as EnemyGeneratorComponent;
			this.enemyGenerator_.increaseEnemiesCount();
			this.spawnPoint_ = Factory.getRandomAISpawn();

			var currentPosition: Object = {
				"x": this.transform_.getX(),
				"y": this.transform_.getY()
			}

			this.spawnDirection_ = Utils.getDirection(currentPosition, this.spawnPoint_);

			if (descr["dyingAnimationLength"] != null) {
				this.dyingAnimationLength_ = descr["dyingAnimationLength"];
			}

			if (descr["hitAnimationLength"] != null) {
				this.hitAnimationLength_ = descr["hitAnimationLength"];
			}
		}

		public function EnemyBehaviorComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
