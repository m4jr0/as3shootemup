package shootemup.gameobject.level {
	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.gameobject.GameObjectManager;
	import engine.locator.Locator;
	import engine.utils.Utils;
	import shootemup.gameobject.level.Factory;

	// class used by the level to generate enemies to take care of the player
	public class EnemyGeneratorComponent extends Component {
		// some variables which will increase gradually to
		// make the game harder over time
		private var defaultMinGenerationInterval_: Number = 0.5;
		private var defaultMaxGenerationInterval_: Number = 1;
		private var minGenerationInterval_: Number = 0;
		private var maxGenerationInterval_: Number = 0;
		private var currentGenerationInterval_: Number = 0;
		private var lastGeneratedTime_: Number = 0;
		private var deltaTime_: Number = 16.67; // ~60 Hz loop
		private var currentEnemiesCount_: uint = 0;
		private var defaultMaxEnemiesCount_: uint = 4;
		private var maxEnemiesCount_: uint = 0;
		private var difficultyLevel_: uint = 1;
		// every "difficultyThreshold_" enemies, increase difficulty
		private var difficultyThreshold_: uint = 5;
		private var enemiesGeneratedCount_: uint = 0;
		// types of enemies that can be spawned at a given time
		private var enemyGeneratorArray_: Array = [Factory.createSmallEnemy];

		private var gameObjectManager_: GameObjectManager = null;

		public function increaseDifficulty(): void {
			++this.maxEnemiesCount_;
			this.minGenerationInterval_ -= 0.05;
			this.maxGenerationInterval_ -= 0.05;
			++this.difficultyLevel_;

			// adding enemy types over type:  the later, the stronger!
			if (this.difficultyLevel_ == 2) {
				this.enemyGeneratorArray_.push(Factory.createMediumEnemy);
			} else if (this.difficultyLevel_ == 4) {
				this.enemyGeneratorArray_.push(Factory.createHeavyEnemy);
			} else  if (this.difficultyLevel_ == 6) {
				this.enemyGeneratorArray_.push(Factory.createBossEnemy);
			}

			trace("Difficulty increased! (" + this.difficultyLevel_ + ")");
		}

		public override function fixedUpdate(): void {
			this.lastGeneratedTime_ += this.deltaTime_ / 1000;

			if (this.lastGeneratedTime_ < this.currentGenerationInterval_) {
				return;
			}

			this.generateEnemy();
		}

		private function generateSpawnInterval(): void {
			this.currentGenerationInterval_ = Utils.getRandomNumber(this.minGenerationInterval_, this.maxGenerationInterval_);
		}

		public override function initialize(descr: Object = null): void {
			super.initialize(descr);

			this.type_ = "enemygenerator";

			this.minGenerationInterval_ = this.defaultMinGenerationInterval_;
			this.maxGenerationInterval_ = this.defaultMaxGenerationInterval_;
			this.maxEnemiesCount_ = this.defaultMaxEnemiesCount_;

			this.deltaTime_ = Locator.game().getMsPerUpdate();
			this.gameObjectManager_ = Locator.gameObjectManager();
		}

		public function increaseEnemiesCount(): void {
			++this.currentEnemiesCount_;
		}

		public function decreaseEnemiesCount(): void {
			--this.currentEnemiesCount_;

			if (this.currentEnemiesCount_ < 0) {
				this.currentEnemiesCount_ = 0;
			}
		}

		public function getRandomEnemy(): GameObject {
			var index: int = Math.floor(Math.random() * this.enemyGeneratorArray_.length);

			return this.enemyGeneratorArray_[index]();
		}

		private function generateEnemy(): void {
			if (this.currentEnemiesCount_ >= this.maxEnemiesCount_) {
				return;
			}

			this.lastGeneratedTime_ = 0;
			this.generateSpawnInterval();

			this.gameObjectManager_.addGameObject(this.getRandomEnemy());

			if (++this.enemiesGeneratedCount_ > this.difficultyThreshold_) {
				this.enemiesGeneratedCount_ = 0;
				this.increaseDifficulty();
			}
		}

		public function EnemyGeneratorComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
