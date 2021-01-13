--数据&初始化
local blocks={
	{{0,1,1},{1,1,0}},
	{{1,1,0},{0,1,1}},
	{{1,1,1},{0,0,1}},
	{{1,1,1},{1,0,0}},
	{{1,1,1},{0,1,0}},
	{{1,1},{1,1}},{{1,1,1,1}}
}
local field={}for i=1,22 do field[i]={0,0,0,0,0,0,0,0,0,0}end
local cb,cx,cy=blocks[math.random(7)],4,19

--检测方块是否有重叠的函数
local function ifoverlap(bk,x,y)
	if x<1 or x+#bk[1]>11 or y<1 then return true end
	for i=1,#bk do for j=1,#bk[1]do
		if field[y+i-1]and bk[i][j]>0 and field[y+i-1][x+j-1]>0 then return true end
	end end
end

--下落函数
local function drop()
	cy=cy-1
	if ifoverlap(cb,cx,cy)then
		--锁定方块
		cy=cy+1
		for i=1,#cb do for j=1,#cb[1]do if cb[i][j]~=0 then
			field[cy+i-1][cx+j-1]=1
		end end end

		--检测消行
		for i=cy+#cb-1,cy,-1 do
			local ct=0
			for j=1,10 do ct=ct+field[i][j]end
			if ct==10 then
				table.remove(field,i)
				table.insert(field,{0,0,0,0,0,0,0,0,0,0})
			end
		end

		--刷新方块
		cb,cx,cy=blocks[math.random(7)],4,19
	end
end

--引擎工作函数
function love.run()
	--初始化计时
	local tm=0

	--引擎工作循环
	return function()
		--引擎事件系统
		love.event.pump()
		for name,k in love.event.poll()do
			if name=="quit"then
				--程序退出
				return true
			elseif name=="keypressed"then--玩家按键
				if k=="left"then--左移
					if not ifoverlap(cb,cx-1,cy)then
						cx=cx-1
					end
				elseif k=="right"then--右移
					if not ifoverlap(cb,cx+1,cy)then
						cx=cx+1
					end
				elseif k=="up"then--旋转
					local m={}
					for y=1,#cb[1]do m[y]={} for x=1,#cb do
						m[y][x]=cb[x][#cb[1]+1-y]
					end end
					if not ifoverlap(m,cx,cy)then cb=m end
				elseif k=="down"then--落到底并锁定
					repeat drop()until cy==19
				end
			end
		end

		--刷新下落计时器，每0.6秒执行一次drop
		if love.timer.getTime()-tm>.6 then
			drop()
			tm=love.timer.getTime()
		end

		--绘制场地
		love.graphics.setColor(0,0,0)
		love.graphics.clear(1,1,1)
		for y=1,20 do for x=1,10 do if field[y][x]==1 then
			love.graphics.rectangle("fill",40*x-39,801-40*y,38,38)
		end end end

		--绘制方块
		love.graphics.setColor(0,0,.8)
		for y=1,#cb do for x=1,#cb[1]do if cb[y][x]==1 then
			love.graphics.rectangle("fill",40*(x+cx-1)-39,801-40*(y+cy-1),38,38)
		end end end

		--将绘制内容输出到屏幕
		love.graphics.present()
	end
end