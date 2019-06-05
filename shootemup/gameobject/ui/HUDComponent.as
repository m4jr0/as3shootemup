package shootemup.gameobject.ui {
	import flash.display.MovieClip;
	import flash.text.TextField;

	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.utils.Utils;
	import shootemup.gameobject.physics.PhysicsComponent;
	import shootemup.gameobject.state.PlayerDataComponent;
	import shootemup.gameobject.weapon.BombWeaponComponent;
	import shootemup.gameobject.weapon.PlayerWeaponComponent;

	// used to keep the player's HUD updated
	public class HUDComponent extends Component {
		private var livesText_: TextField = null;
		private var scoreText_: TextField = null;
		private var bombsText_: TextField = null;

		private var bulletWeaponIcon_: MovieClip = null;
		private var plasmaWeaponIcon_: MovieClip = null;
		private var velocityGaugeIcon_: MovieClip = null;

		private var player_: GameObject = null
		private var data_: PlayerDataComponent = null;
		private var physics_: PhysicsComponent = null;
		private var bombWeapon_: BombWeaponComponent = null;

		private var lastWeaponName_: String = null;
		private var maxVelocity_: Number = 1;

		public override function update(): void {
			this.updateUI();
		}

		public override function initialize(descr: Object = null): void {
			if (descr == null) {
				throw new Error("Description for HUD component cannot be null");
			}

			this.type_ = "hud";

			this.player_ = descr["player"];

			this.data_ = this.player_.getComponent("data") as PlayerDataComponent;

			if (this.data_ == null) {
				throw new Error("Game object must have a data component");
			}

			this.physics_ = this.player_.getComponent("physics") as PhysicsComponent;

			if (this.physics_ == null) {
				throw new Error("Game object must have a physics component");
			}

			this.bombWeapon_ = this.player_.getComponent("bomb") as BombWeaponComponent;

			if (this.bombWeapon_ == null) {
				throw new Error("Game object must have a bomb weapon component");
			}

			this.maxVelocity_ = Utils.getVectorMagnitude(this.physics_.getMaxVelocity());

			this.livesText_ = descr["livesContainer"].livesText;
			this.scoreText_ = descr["scoreContainer"].scoreText;
			this.bombsText_ = descr["bombsContainer"].bombsText;
			this.bulletWeaponIcon_ = descr["bulletWeaponIcon"];
			this.plasmaWeaponIcon_ = descr["plasmaWeaponIcon"];
			this.velocityGaugeIcon_ = descr["velocityGaugeIcon"];

			// initialize UI
			this.resetWeapon();
			this.updateUI();
		}

		public function updateUI(): void {
			this.setLives();
			this.setScore();
			this.setBombs();
			this.setCurrentWeapon();
			this.setCurrentVelocity();
		}

		private function setLives(): void {
			this.livesText_.text = this.data_.getLives().toString(10);
		}

		private function setScore(): void {
			this.scoreText_.text = this.data_.getScore().toString(10);
		}

		private function setBombs(): void {
			this.bombsText_.text = this.bombWeapon_.getBombsLeft().toString(10);
		}

		private function setCurrentWeapon(): void {
			var currentWeapon: PlayerWeaponComponent = this.data_.getCurrentWeapon();

			if (currentWeapon == null) {
				this.resetWeapon();
				return;
			}

			var currentWeaponName: String = currentWeapon.getName();

			if (currentWeaponName == this.lastWeaponName_) {
				return;
			}

			this.lastWeaponName_ = currentWeaponName;

			if (currentWeaponName == "bulletweapon") {
				this.selectWeapon(this.bulletWeaponIcon_);
				this.plasmaWeaponIcon_.filters = new Array();
			} else if (currentWeaponName == "plasmaweapon") {
				this.selectWeapon(this.plasmaWeaponIcon_);
				this.bulletWeaponIcon_.filters = new Array();
			} else {
				this.resetWeapon();
			}
		}

		private function selectWeapon(weapon: MovieClip):void {
			Utils.addOutline(weapon, 0x190000, 2);
		}

		private function resetWeapon(): void {
			this.bulletWeaponIcon_.filters = new Array();
			this.plasmaWeaponIcon_.filters = new Array();
		}

		public function setCurrentVelocity(): void {
			var currentVelocity: Number = Utils.getVectorMagnitude(this.physics_.getVelocity());
			var ratio: Number = currentVelocity / this.maxVelocity_;
			this.velocityGaugeIcon_.scale
			this.velocityGaugeIcon_.scaleY = 1 - ratio;
		}

		public function HUDComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
