package engine.gameobject {
	import engine.gameobject.Component;
	import engine.locator.Locator;

	public class GameObject {
		// unique ID
		protected static var currentID_: int = -1;

		private var componentObject_: Object = new Object();
		private var id_: int = 0;

		private function generateID(): int {
			return ++GameObject.currentID_;
		}

		public function getID(): int {
			return this.id_;
		}

		// callback called when a collision is detected
		public function onCollision(descr: Object): void {
			for each(var component: Component in this.componentObject_) {
				if (!component.isEnabled()) {
					continue;
				}

				component.onCollision(descr);
			}
		}

		public function getComponent(type: String): Component {
			return this.componentObject_[type];
		}

		public function addComponent(component: Component): void {
			this.componentObject_[component.getType()] = component;
		}

		public function removeComponent(type: String): void {
			delete this.componentObject_[type];
		}

		// rendering loop
		public function update(): void {
			for each(var component: Component in this.componentObject_) {
				if (!component.isEnabled()) {
					continue;
				}

				component.update();
			}
		}

		// physics loop
		public function fixedUpdate(): void {
			for each(var component: Component in this.componentObject_) {
				if (!component.isEnabled()) {
					continue;
				}

				component.fixedUpdate();
			}
		}

		public function GameObject(): void {
			this.id_ = this.generateID();
		}
		
		// called to destroy the game object entirely
		public function destroy(): void {
			for each(var component: Component in this.componentObject_) {
				this.removeComponent(component.getType());
				component.destroy();
			}
			
			Locator.gameObjectManager().removeGameObject(this.id_);
		}
	}

}
