package engine.gameobject {
	import flash.utils.Dictionary;

	import engine.game.Manager;
	import engine.gameobject.GameObject;
	import flash.media.Video;

	public class GameObjectManager extends Manager {
		private var gameObjectDict_: Dictionary = new Dictionary();
		private var playerGameObject_: GameObject = null;
		private var levelGameObject_: GameObject = null;

		public function getGameObject(id: int): GameObject {
			return this.gameObjectDict_[id];
		}

		public function getPlayerGameObject(): GameObject {
			return this.playerGameObject_;
		}

		public function getLevelGameObject(): GameObject {
			return this.levelGameObject_;
		}
		
		// player of the game
		public function addPlayer(gameObject: GameObject): void {
			this.playerGameObject_ = gameObject;
			this.addGameObject(gameObject);
		}

		// level of the game
		public function addLevel(gameObject: GameObject): void {
			this.levelGameObject_ = gameObject;
			this.addGameObject(this.levelGameObject_);
		}

		public function addGameObject(gameObject: GameObject): void {
			this.gameObjectDict_[gameObject.getID()] = gameObject;
		}

		public function removeGameObject(id: int): void {
			delete this.gameObjectDict_[id];
		}

		public function resetGameObjects(): void {
			this.gameObjectDict_ = new Dictionary();
		}
		
		public function getGameObjectDict(): Dictionary {
			return this.gameObjectDict_;
		}

		// rendering loop
		public override function update(): void {
			for each(var gameObject: GameObject in this.gameObjectDict_) {
				gameObject.update();
			}
		}

		// physics loop
		public override function fixedUpdate(): void {
			for each(var gameObject: GameObject in this.gameObjectDict_) {
				gameObject.fixedUpdate();
			}
		}
		
		// destroy all the game objects that it contains
		public function destroyEverything(): void {
			for each(var gameObject: GameObject in this.gameObjectDict_) {
				this.removeGameObject(gameObject.getID());
				gameObject.destroy();
			}
		}

		public function GameObjectManager() {}
	}

}