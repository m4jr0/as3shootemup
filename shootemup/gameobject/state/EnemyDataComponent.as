package shootemup.gameobject.state {
	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import shootemup.gameobject.weapon.EnemyWeaponComponent;

	// keep track of the enemy's variables needed by the player
	public class EnemyDataComponent extends Component {
		private var lives_: int = 15;
		private var reward_: Number = 150;
		private var weapon_: EnemyWeaponComponent = null;

		public override function initialize(descr: Object = null): void {
			this.type_ = "data";

			this.weapon_ = this.gameObject_.getComponent("weapon") as EnemyWeaponComponent;

			if (this.weapon_ == null) {
				throw new Error("Game object must have a weapon component");
			}

			if (descr == null) {
				return;
			}

			this.lives_ = descr["lives"];
			this.reward_ = descr["reward"];
		}

		public function removeLife(): void {
			this.setLives(this.lives_ - 1);
		}

		public function setLives(lives: int): void {
			this.lives_ = lives;
		}

		public function getLives(): int {
			return this.lives_;
		}

		public function getReward(): Number {
			return this.reward_;
		}

		public function EnemyDataComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
