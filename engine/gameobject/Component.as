package engine.gameobject {
	import engine.gameobject.GameObject;

	// is contained in a game object
	// it tells what the game object is
	public class Component {
		protected var isEnabled_: Boolean = true;
		protected var gameObject_: GameObject = null;
		protected var name_: String = "generic";
		protected var type_: String = "generic";

		public function Component(gameObject: GameObject, descr: Object = null) {
			this.gameObject_ = gameObject;
			this.initialize(descr);
		}

		public function initialize(descr: Object = null): void {}

		// rendering loop
		public function update(): void {}

		// physics loop
		public function fixedUpdate(): void {}

		// will not be rendered
		public function isEnabled(): Boolean {
			return this.isEnabled_;
		}		

		// callback called when a collision is detected
		public function onCollision(descr: Object): void {}

		public function getName(): String {
			return this.name_;
		}

		// we can have only one type of component in a game object
		public function getType(): String {
			return this.type_;
		}

		public function enable(): void {
			this.isEnabled_ = true;
		}

		public function disable(): void {
			this.isEnabled_ = false;
		}

		public function getGameObject(): GameObject {
			return this.gameObject_;
		}
		
		// called to destroy the component entirely
		public function destroy(): void {}
	}
}
