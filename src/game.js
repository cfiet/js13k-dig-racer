goog.module("game2019.game");

const Vec2 = goog.require("goog.math.Vec2");

class Player {

	constructor(position, speed, hitpoints) {
		/** @type {goog.math.Vec2} */
		this.position = position;

		/** @type {goog.math.Vec2} */
		this.speed = speed;

		/** @type {number} */
		this.hitpoints = hitpoints;
	}

	/**
	 * @param {number} step
	 */
	move(step) {
		this.position.x += this.speed.x * step;
		this.position.y += this.speed.y * step;
	}
}

exports = {
	Player
};
