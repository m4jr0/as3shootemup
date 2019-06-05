package shootemup.gameobject.level {
	import engine.gameobject.GameObject;
	import engine.locator.Locator;
	import engine.utils.Utils;
	import shootemup.game.ShootEmUp;
	import shootemup.gameobject.ai.CircleEnemyBehaviorComponent;
	import shootemup.gameobject.ai.XEnemyBehaviorComponent;
	import shootemup.gameobject.ai.YEnemyBehaviorComponent;
	import shootemup.gameobject.animation.AnimatorComponent;
	import shootemup.gameobject.animation.BeingAnimatorComponent;
	import shootemup.gameobject.collision.BoundingComponent;
	import shootemup.gameobject.collision.BoxComponent;
	import shootemup.gameobject.input.InputComponent;
	import shootemup.gameobject.level.EnemyGeneratorComponent;
	import shootemup.gameobject.physics.PhysicsComponent;
	import shootemup.gameobject.physics.TransformComponent;
	import shootemup.gameobject.state.EnemyDataComponent;
	import shootemup.gameobject.state.PlayerDataComponent;
	import shootemup.gameobject.state.PlayerStateComponent;
	import shootemup.gameobject.ui.HUDComponent;
	import shootemup.gameobject.ui.PauseMenuComponent;
	import shootemup.gameobject.weapon.BombWeaponComponent;
	import shootemup.gameobject.weapon.BulletWeaponComponent;
	import shootemup.gameobject.weapon.EnemyWeaponComponent;
	import shootemup.gameobject.weapon.projectile.BombProjectileComponent;
	import shootemup.gameobject.weapon.projectile.BulletProjectileComponent;
	import shootemup.gameobject.weapon.projectile.EnemyProjectileComponent;
	import shootemup.gameobject.weapon.projectile.PlasmaProjectileComponent;

	// huge class which generates prebuilt game objects
	// should be divided in different classes or, maybe find a way
	// to compress this kind of data to make it easier to manage
	public class Factory {
		// generate a random AI spawn position
		public static function getRandomAISpawn(): Object {
			var bounds: Object = (Locator.game() as ShootEmUp).getSpawnZone();

			var x: Number = Utils.getRandomNumber(bounds["left"], bounds["right"]);
			var y: Number = Utils.getRandomNumber(bounds["bottom"], bounds["top"]);

			return {
				"x": x,
				"y": y
			};
		}

		public static function createLevel(gameData: Object, player: GameObject): GameObject {
			gameData["player"] = player;

			var level: GameObject = new GameObject();

			level.addComponent(new BoxComponent(level));
			level.addComponent(new EnemyGeneratorComponent(level));
			level.addComponent(new HUDComponent(level, gameData));
			level.addComponent(new PauseMenuComponent(level, gameData));

			return level;
		}

		public static function createPlayer(): GameObject {
			var player: GameObject = new GameObject();
			var transformComponent = new TransformComponent(player);

			transformComponent.setX(255);
			transformComponent.setY(500);

			player.addComponent(transformComponent);
			player.addComponent(new InputComponent(player));
			player.addComponent(new BulletWeaponComponent(player));
			player.addComponent(new BombWeaponComponent(player));
			player.addComponent(new PlayerDataComponent(player));
			player.addComponent(new PhysicsComponent(player));

			player.addComponent(new BeingAnimatorComponent(player, {
				"defaultSprite": new PlayerDefault(),
				"dieSprite": new PlayerDead()
			}));

			player.addComponent(new BoundingComponent(player));
			player.addComponent(new PlayerStateComponent(player));

			return player;
		}

		public static function createBulletProjectile(descr: Object): GameObject {
			var projectile: GameObject = new GameObject();

			projectile.addComponent(new TransformComponent(projectile, descr));
			projectile.addComponent(new BulletProjectileComponent(projectile, descr));

			projectile.addComponent(new AnimatorComponent(projectile, {
				"defaultSprite": new BulletProjectile()
			}));

			projectile.addComponent(new BoundingComponent(projectile));

			return projectile;
		}

		public static function createPlasmaProjectile(descr: Object): GameObject {
			var projectile: GameObject = new GameObject();

			projectile.addComponent(new TransformComponent(projectile, descr));
			projectile.addComponent(new PlasmaProjectileComponent(projectile, descr));

			projectile.addComponent(new AnimatorComponent(projectile, {
				"defaultSprite": new plasma(),
				"defaultRotation": 180
			}));

			projectile.addComponent(new BoundingComponent(projectile));

			return projectile;
		}

		public static function createBombProjectile(descr: Object): GameObject {
			var projectile: GameObject = new GameObject();

			projectile.addComponent(new TransformComponent(projectile, descr));
			projectile.addComponent(new BombProjectileComponent(projectile, descr));

			projectile.addComponent(new AnimatorComponent(projectile, {
				"defaultSprite": new BombProjectile()
			}));

			projectile.addComponent(new BoundingComponent(projectile));

			return projectile;
		}

		public static function createSmallEnemy(descr: Object = null): GameObject {
			if (descr == null) {
				descr = {};
			}

			var enemy: GameObject = new GameObject();
			var enemyBehaviorClass: Class = Factory.getRandomBehavior();

			enemy.addComponent(new TransformComponent(enemy, {
				"x": 255,
				"y": -150
			}));

			enemy.addComponent(new EnemyWeaponComponent(enemy));
			enemy.addComponent(new EnemyDataComponent(enemy));

			enemy.addComponent(new BeingAnimatorComponent(enemy, {
				"defaultSprite": new Enemy01Default(),
				"hitSprite": new Enemy01Hit(),
				"dieSprite": new Enemy01Dead(),
				"defaultRotation": 180
			}));

			enemy.addComponent(new enemyBehaviorClass(enemy, {
				"dyingAnimationLength": 0.5,
				"hitAnimationLength": 0.5
			}));

			enemy.addComponent(new BoundingComponent(enemy));

			return enemy;
		}

		public static function createMediumEnemy(descr: Object = null): GameObject {
			if (descr == null) {
				descr = {};
			}

			var enemy: GameObject = new GameObject();
			var enemyBehaviorClass: Class = Factory.getRandomBehavior();

			enemy.addComponent(new TransformComponent(enemy, {
				"x": 255,
				"y": -150
			}));

			enemy.addComponent(new EnemyWeaponComponent(enemy));

			enemy.addComponent(new EnemyDataComponent(enemy, {
				"lives": 30,
				"reward": 300
			}));

			enemy.addComponent(new BeingAnimatorComponent(enemy, {
				"defaultSprite": new Enemy02Default(),
				"hitSprite": new Enemy02Hit(),
				"dieSprite": new Enemy02Dead(),
				"defaultRotation": 180
			}));

			enemy.addComponent(new enemyBehaviorClass(enemy, {
				"dyingAnimationLength": 0.5,
				"hitAnimationLength": 0.5,
				"minShotInterval": 3,
				"maxShotInterval": 4
			}));

			enemy.addComponent(new BoundingComponent(enemy));

			return enemy;
		}

		public static function createHeavyEnemy(descr: Object = null): GameObject {
			if (descr == null) {
				descr = {};
			}

			var enemy: GameObject = new GameObject();
			var enemyBehaviorClass: Class = Factory.getRandomBehavior();

			enemy.addComponent(new TransformComponent(enemy, {
				"x": 255,
				"y": -150
			}));

			enemy.addComponent(new EnemyWeaponComponent(enemy));

			enemy.addComponent(new EnemyDataComponent(enemy, {
				"lives": 50,
				"reward": 900
			}));

			enemy.addComponent(new BeingAnimatorComponent(enemy, {
				"defaultSprite": new Enemy03Default(),
				"hitSprite": new Enemy03Default(),
				"dieSprite": new Enemy03Dead(),
				"defaultRotation": 180
			}));

			enemy.addComponent(new enemyBehaviorClass(enemy, {
				"dyingAnimationLength": 0.5,
				"hitAnimationLength": 0.5,
				"minShotInterval": 2,
				"maxShotInterval": 3
			}));

			enemy.addComponent(new BoundingComponent(enemy));

			return enemy;
		}

		public static function createBossEnemy(descr: Object = null): GameObject {
			if (descr == null) {
				descr = {};
			}

			var enemy: GameObject = new GameObject();
			var enemyBehaviorClass: Class = Factory.getRandomBehavior();

			enemy.addComponent(new TransformComponent(enemy, {
				"x": 255,
				"y": -150
			}));

			enemy.addComponent(new EnemyWeaponComponent(enemy));

			enemy.addComponent(new EnemyDataComponent(enemy, {
				"lives": 80,
				"reward": 2000
			}));

			enemy.addComponent(new BeingAnimatorComponent(enemy, {
				"defaultSprite": new Enemy04Default(),
				"hitSprite": new Enemy04Hit(),
				"dieSprite": new Enemy04Dead(),
				"defaultRotation": 180
			}));

			enemy.addComponent(new enemyBehaviorClass(enemy, {
				"dyingAnimationLength": 0.5,
				"hitAnimationLength": 0.5,
				"minShotInterval": 1,
				"maxShotInterval": 2
			}));

			enemy.addComponent(new BoundingComponent(enemy));

			return enemy;
		}

		public static function createEnemyProjectile(descr: Object): GameObject {
			var projectile: GameObject = new GameObject();

			projectile.addComponent(new TransformComponent(projectile, descr));
			projectile.addComponent(new EnemyProjectileComponent(projectile, descr));

			projectile.addComponent(new AnimatorComponent(projectile, {
				"defaultSprite": new LaserProjectile()
			}));

			projectile.addComponent(new BoundingComponent(projectile));

			return projectile;
		}

		// return a specific behavior for the AI to move on the map
		public static function getRandomBehavior(): Class {
			var behaviorArray: Array = [XEnemyBehaviorComponent, YEnemyBehaviorComponent, CircleEnemyBehaviorComponent];
			var index: int = Math.floor(Math.random() * behaviorArray.length);

			return behaviorArray[index];
		}

		public function Factory() {}
	}
}