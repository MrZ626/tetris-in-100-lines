blocks={{{0,1,1},{1,1,0}},{{1,1,0},{0,1,1}},{{1,1,1},{0,0,1}},{{1,1,1},{1,0,0}},{{1,1,1},{0,1,0}},{{1,1},{1,1}},{{1,1,1,1}}}
field={}for i=1,22 do field[i]={0,0,0,0,0,0,0,0,0,0}end
cb,cx,cy=blocks[math.random(7)],4,19--数据&初始化
function ifoverlap(bk,x,y)--检测重叠函数
	if x<1 or x+#bk[1]>11 or y<1 then return true end
	for i=1,#bk do for j=1,#bk[1]do
		if field[y+i-1]and bk[i][j]>0 and field[y+i-1][x+j-1]>0 then return true end
	end end
end
function drop()--下落过程函数
	cy=cy-1
	if ifoverlap(cb,cx,cy)then
		cy=cy+1
		for i=1,#cb do for j=1,#cb[1]do if cb[i][j]~=0 then
			field[cy+i-1][cx+j-1]=1
		end end end
		for i=cy+#cb-1,cy,-1 do
			local ct=0
			for j=1,10 do ct=ct+field[i][j]end
			if ct==10 then table.remove(field,i)table.insert(field,{0,0,0,0,0,0,0,0,0,0})end
		end
		cb,cx,cy=blocks[math.random(7)],4,19
	end
end
function love.keypressed(i)--按键事件函数
	if i=="left"then if not ifoverlap(cb,cx-1,cy)then cx=cx-1 end
	elseif i=="right"then if not ifoverlap(cb,cx+1,cy)then cx=cx+1 end
	elseif i=="up"then
		local m={}
		for i=1,#cb[1]do m[i]={} for j=1,#cb do
			m[i][j]=cb[j][#cb[1]+1-i]
		end end
		if not ifoverlap(m,cx,cy)then cb=m end
	elseif i=="down"then repeat drop()until cy==19
	end
end
function love.run()--引擎工作函数
	flag=love.timer.getTime()--初始化计时
	love.graphics.setColor(255,0,0)--设置红色画笔
	return function()--引擎工作循环
		love.event.pump()--引擎事件系统
		for name,a,b,c,d,e,f in love.event.poll()do
			if name=="quit"then return 0 end
			love.handlers[name](a,b,c,d,e,f)
		end
		if love.timer.getTime()-flag>.6 then--下落计时器
			drop()
			flag=love.timer.getTime()
		end
		love.graphics.clear(255,255,255)--绘图
		for j=1,20 do for i=1,10 do if field[j][i]==1 then
			love.graphics.rectangle("fill",40*i-39,801-40*j,38,38)
		end end end
		for j=1,#cb do for i=1,#cb[1]do if cb[j][i]==1 then
			love.graphics.rectangle("fill",40*(i+cx-1)-39,801-40*(j+cy-1),38,38)
		end end end
		love.graphics.present()
	end
end