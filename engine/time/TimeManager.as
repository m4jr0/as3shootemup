package engine.time {
	import flash.utils.getTimer;

	import engine.game.Manager;

	public class TimeManager extends Manager {
		private var deltaTime_: uint = 0;
		private var previousTime_: uint = 0;
		private var timeScale_: Number = 1.0;

		public function TimeManager() {}

		// return the real time
		public function getRealNow(): uint {
			return getTimer();
		}

		// return the game time
		public function getNow(): uint {
			var deltaTime: uint = this.getRealNow() - this.previousTime_;
			var timeToAdd: uint = deltaTime * this.timeScale_;

			return this.previousTime_ + timeToAdd;
		}

		// will block any physics update
		public function stop(): void {
			this.timeScale_ = 0.0;
		}

		// will allow any physics update
		public function resume(): void {
			this.timeScale_ = 1.0;
		}

		// change the game speed
		public function setTimeScale(timeScale: Number): void {
			this.timeScale_ = timeScale;
		}

		public function getDeltaTime(): uint {
			return this.deltaTime_;
		}
		
		public function getTimeScale(): Number {
			return this.timeScale_;
		}

		//called by the game engine
		public override function update(): void {
			var currentTime: uint = this.getNow();
			this.deltaTime_ = currentTime - this.previousTime_;
			this.previousTime_ = currentTime;
		}
	}
}