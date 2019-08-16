goog.module("game2019.index");

const math = goog.require("goog.math");
const dom = goog.require("goog.dom");
const { Player } = goog.require("game2019.game");

const player = new Player(
	new math.Vec2(0, 0),
	new math.Vec2(1, 0),
	3
);

const window = dom.getWindow();

const lastTime = window.performance.now();

const stepOver = () => {
	const step = window.performance.now() - lastTime;

	player.move(step / 1000);
	console.log(player);
	window.requestAnimationFrame(stepOver);
}

window.requestAnimationFrame(stepOver);
