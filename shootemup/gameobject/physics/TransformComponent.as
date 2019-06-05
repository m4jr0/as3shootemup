package shootemup.gameobject.physics {
	import engine.gameobject.Component;
	import engine.gameobject.GameObject;

	// class used to keep track of the game object's position
	public class TransformComponent extends Component {
		private var x_: Number = 0;
		private var y_: Number = 0;

		public function setX(x: Number): void {
			this.x_ = x;
		}

		public function setY(y: Number): void {
			this.y_ = y;
		}

		public function getX(): Number {
			return this.x_;
		}

		public function getY(): Number {
			return this.y_;
		}

		public override function initialize(descr: Object = null): void {
			this.type_ = "transform";

			if (descr == null) {
				return;
			}

			this.x_ = descr["x"];
			this.y_ = descr["y"];
		}

		public function TransformComponent(gameObject: GameObject, descr: Object = null) {
			super(gameObject, descr);
		}
	}
}