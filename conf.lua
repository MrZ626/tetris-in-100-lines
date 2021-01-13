function love.conf(t)
	local W=t.window
	W.title="极简方块"
	W.width,W.height=400,800
	W.resizable=false

	local M=t.modules
	M.audio=false
	M.data=false
	M.image=false
	M.joystick=false
	M.math=false
	M.mouse=false
	M.physics=false
	M.sound=false
	M.thread=false
	M.touch=false
	M.video=false
end
