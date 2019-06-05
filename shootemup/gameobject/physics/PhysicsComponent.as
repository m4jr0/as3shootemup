package shootemup.gameobject.physics {
	import engine.gameobject.Component;
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import engine.utils.Utils;
	import shootemup.gameobject.collision.BoxComponent;
	import shootemup.gameobject.input.InputComponent;
	import shootemup.gameobject.state.PlayerDataComponent;

	// handle player's physics
	public class PhysicsComponent extends Component {
		private var transform_: TransformComponent = null;
		private var data_: PlayerDataComponent = null;
		private var input_: InputComponent = null;
		private var isCollision_: Boolean = false;

		// current velocity
		private var velocity_: Object = {
			"x": 0.0,
			"y": 0.0
		};

		// generated when the player gets too close to the bounds,
		// will push him away 
		private var boundsVelocity_: Object = {
			"x": 0.0,
			"y": 0.0
		};

		private var direction_: Object = {
			"x": 1,
			"y": 1
		};

		private var maxVelocity_: Object = {
			"x": 0.3,
			"y": 0.3
		};

		// some threshold to avoid weird and jittery
		// behaviors when moving
		private var nullVelocity_: Object = {
			"x": 0.04,
			"y": 0.04
		};

		private var acceleration_: Object = {
			"x": 0.1,
			"y": 0.1
		};

		private var deceleration_: Object = {
			"x": 0.05,
			"y": 0.05
		};

		// deceleration specific to the bounds velocity...
		private var boundsDeceleration_: Object = {
			"x": 0.01,
			"y": 0.01
		};

		// ... same with the threshold
		private var nullBoundsVelocity: Object = {
			"x": 0.04,
			"y": 0.04
		};

		// used when computing positions and other physics characteristics
		private var deltaTime_: Number = 16.67; // ~60 Hz loop

		public override function fixedUpdate(): void {
			if (this.isCollision_) {
				// we do not want the player to move when he gets too close to
				// the bounds
				this.velocity_["x"] = this.velocity_["y"] = 0
				this.isCollision_ = false;
			}

			// we get the inputs
			this.handleInputs();
			
			// we clamp the velocity
			this.velocity_["x"] = Utils.sign(this.velocity_["x"]) * Math.min(
				Math.max(Math.abs(this.velocity_["x"]), 0), this.maxVelocity_["x"]
			)

			this.velocity_["y"] = Utils.sign(this.velocity_["y"]) * Math.min(
				Math.max(Math.abs(this.velocity_["y"]), 0), this.maxVelocity_["y"]
			)

			this.transform_.setX(this.transform_.getX() + (this.velocity_["x"] + this.boundsVelocity_["x"]) * this.deltaTime_);
			this.transform_.setY(this.transform_.getY() + (this.velocity_["y"] + this.boundsVelocity_["y"]) * this.deltaTime_);

			// we clamps the bounds velocity as well
			var signBoundsVelocityX = Utils.sign(this.boundsVelocity_["x"])
			var signBoundsVelocityY = Utils.sign(this.boundsVelocity_["y"])

			const absBoundsVelocityX = Math.abs(this.boundsVelocity_["x"])
			const absBoundsVelocityY = Math.abs(this.boundsVelocity_["y"])

			if (absBoundsVelocityX - this.boundsDeceleration_["x"] < this.nullBoundsVelocity["x"]) {
			  this.boundsVelocity_["x"] = 0
			} else {
			  this.boundsVelocity_["x"] += -1 * signBoundsVelocityX * this.boundsDeceleration_["x"]
			}

			if (absBoundsVelocityY - this.boundsDeceleration_["y"] < this.nullBoundsVelocity["y"]) {
			  this.boundsVelocity_["y"] = 0
			} else {
			  this.boundsVelocity_["y"] += -1 * signBoundsVelocityY * this.boundsDeceleration_["y"]
			}
		}

		public function setBoundsVelocityX(x: Number): void {
			this.boundsVelocity_["x"] = x;
		}

		public function setBoundsVelocityY(y: Number): void {
			this.boundsVelocity_["y"] = y;
		}

		public function setVelocityX(x: Number): void {
			this.velocity_["x"] = x;
		}

		public function setVelocityY(y: Number): void {
			this.velocity_["y"] = y;
		}

		public function getVelocity(): Object {
			return this.velocity_;
		}

		public function getMaxVelocity(): Object {
			return this.maxVelocity_;
		}

		public override function onCollision(descr: Object): void {
			if (descr["from"] is BoxComponent || descr["this"] is BoxComponent) {
				this.isCollision_ = true;
			}
		}

		public override function initialize(descr: Object = null): void {
			this.type_ = "physics";

			this.data_ = this.gameObject_.getComponent("data") as PlayerDataComponent;

			if (this.data_ == null) {
				throw new Error("Game object must have a data component");
			}

			this.transform_ = this.gameObject_.getComponent("transform") as TransformComponent;

			if (this.transform_ == null) {
				throw new Error("Game object must have a transform component");
			}

			this.input_ = this.gameObject_.getComponent("input") as InputComponent;

			if (this.input_ == null) {
				throw new Error("Game object must have an input component");
			}

			this.deltaTime_ = Locator.game().getMsPerUpdate();
		}

		private function handleInputs(): void {
			var currentInputs: Object = this.input_.getInputs();

			// thresholds used to avoid weird behaviors when moving
			if (Math.abs(this.velocity_["x"]) <= this.nullVelocity_["x"]) {
				if (!currentInputs["left"] && !currentInputs["right"]) {
					this.direction_["x"] = 0;
					this.velocity_["x"] = 0;
				}
			}

			if (Math.abs(this.velocity_["y"]) <= this.nullVelocity_["y"]) {
				if (!currentInputs["up"] && !currentInputs["down"]) {
					this.direction_["y"] = 0;
					this.velocity_["y"] = 0;
				}
			}

			// generate a direction based on the player's inputs
			if (currentInputs["left"]) {
				this.direction_["x"] = -1;
			}

			if (currentInputs["right"]) {
				this.direction_["x"] = 1;
			}

			if (currentInputs["up"]) {
				this.direction_["y"] = -1;
			}

			if (currentInputs["down"]) {
				this.direction_["y"] = 1;
			}

			// will accelerate or decelerate, depending on the inputs
			if (!currentInputs["left"] && !currentInputs["right"]) {
				this.velocity_["x"] += this.deceleration_["x"] * -this.direction_["x"];
			} else {
				this.velocity_["x"] += this.acceleration_["x"] * this.direction_["x"];
			}

			if (!currentInputs["up"] && !currentInputs["down"]) {
				this.velocity_["y"] += this.deceleration_["y"] * -this.direction_["y"];
			} else {
				this.velocity_["y"] += this.acceleration_["y"] * this.direction_["y"];
			}
		}

		public function PhysicsComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}
