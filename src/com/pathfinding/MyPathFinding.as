package com.pathfinding
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MyPathFinding extends Sprite
	{
		private var img:Class;
		private var pic:DisplayObject;
		private var _cellSize:int = 20;
		private var _cellSizeW:int = 20;
		private var _cellSizeH:int = 20;
		private var _grid:Grid;
		private var _player:Sprite;
		private var _index:int;
		private var _path:Array;
		private var _moveSpeed:Number = 20;
		private var w:Number;
		private var h:Number;
		
		//分辨率   格子数
		private var hang:int;
		private var lie:int;
		
//		private var mapData:MapData;
		private var sprite:Sprite;
		
		public function MyPathFinding()
		{
//			mapData = MapData.getInstance();
//			hang = mapData.map1.length;
//			lie = mapData.map1[0].length;
			trace(hang, lie);
			sprite = new Sprite();
			addChild(sprite);
			pic = new img();
			sprite.addChild(pic);
			pic.visible = false;
			w = sprite.width;
			h = sprite.height;
			//格子大小
			_cellSizeW = w / lie;
			_cellSizeH = w / hang;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			makePlayer();
			makeGrid();
			stage.addEventListener(MouseEvent.CLICK, onGridClick); //fjn
			//sprite.addEventListener(MouseEvent.MOUSE_DOWN, sprite_mouseDown);
		}
		
		private function sprite_mouseDown(e:MouseEvent):void
		{
			sprite.startDrag();
			sprite.addEventListener(MouseEvent.MOUSE_UP, sprite_mouseUp);
		}
		
		private function sprite_mouseUp(e:MouseEvent):void
		{
			sprite.removeEventListener(MouseEvent.MOUSE_UP, sprite_mouseUp);
			sprite.stopDrag();
		}
		
		/**
		 * Creates the player sprite. Just a circle here.
		 */
		private function makePlayer():void
		{
			_player = new Sprite();
			_player.graphics.beginFill(0xff0000);
			_player.graphics.drawCircle(0, 0, 5);
			_player.graphics.endFill();
			_player.x = Math.random() * 600;
			_player.y = Math.random() * 600;
			addChild(_player);
		}
		
		/**
		 * Creates a grid with a bunch of random unwalkable nodes.
		 */
		private function makeGrid():void
		{
			
			_grid = new Grid(lie, hang);
			trace(_grid.numCols, _grid.numRows);
			for (var j:int = 0; j < _grid.numRows; j++)
			{
				for (var k:int = 0; k < _grid.numCols; k++)
				{
//					if (mapData.map1[j][k] == 1)
					{
						//  x  ， y
						_grid.setWalkable(k, j, false);
					}
				}
			}
			drawGrid();
		}
		
		/**
		 * Draws the given grid, coloring each cell according to its state.
		 */
		private function drawGrid(   ):void
		{
			sprite.graphics.clear();
			for (var i:int = 0; i < _grid.numCols; i++)
			{
				for (var j:int = 0; j < _grid.numRows; j++)
				{
					var node:Node = _grid.getNode(i, j);
					sprite.graphics.lineStyle(0);
					sprite.graphics.beginFill(getColor(node));
					sprite.graphics.drawRect(i * _cellSizeW, j * _cellSizeH, _cellSizeW, _cellSizeH);
				}
			}
		}
		
		/**
		 * Determines the color of a given node based on its state.
		 */
		private function getColor(node:Node):uint
		{
			if (!node.walkable)
				return 0;
			if (node == _grid.startNode)
				return 0xcccccc;
			if (node == _grid.endNode)
				return 0xcccccc;
			return 0xffffff;
		}
		
		/**
		 * Handles the click event on the GridView. Finds the clicked on cell and toggles its walkable state.
		 */
		private function onGridClick(event:MouseEvent):void
		{
			
			//var startPosX:int =Math.floor( (_player.x - sprite.x) / _cellSizeW);
			//var startPosY:int =Math.floor( (_player.y -sprite.y) / _cellSizeH);
			
			var startPosX:int = Math.floor(_player.x / _cellSizeW);
			var startPosY:int = Math.floor(_player.y / _cellSizeH);
			
			var endPosX:int = Math.floor((mouseX - sprite.x) / _cellSizeW);
			var endPosY:int = Math.floor((mouseY - sprite.y) / _cellSizeH);
			
			var hasBarrier:Boolean = _grid.hasBarrier(startPosX, startPosY, endPosX, endPosY);
			if (hasBarrier)
			{
				_grid.setStartNode(startPosX, startPosY);
				_grid.setEndNode(endPosX, endPosY);
				
				//			drawGrid();
				findPath();
			}
			else
			{
				_path = [_grid.getNode(endPosX, endPosY)];
				_index = 0;
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		
		}
		
		/**
		 * Creates an instance of AStar and uses it to find a path.
		 */
		private function findPath():void
		{
			var astar:AStar = new AStar();
			if (astar.findPath(_grid) && astar.path.length > 0)
			{
				_path = astar.path;
				_index = 0;
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		/**
		 * Finds the next node on the path and eases to it.
		 */
		private function onEnterFrame(event:Event):void
		{
			var targetX:Number = _path[_index].x * _cellSizeW + _cellSizeW / 2; //根据节点列号求得屏幕坐标
			var targetY:Number = _path[_index].y * _cellSizeH + _cellSizeH / 2; //根据节点行号求得屏幕坐标
			var dx:Number = targetX - _player.x;
			var dy:Number = targetY - _player.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			
			//到达当前目的地
			if (dist < _moveSpeed)
			{
				_index++;
				//已到最后一个目的地，则停下
				if (_index >= _path.length)
				{
					_player.x = targetX;
					_player.y = targetY;
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					return;
				}
				//未到最后一个目的地，则在index++后重头进行行走逻辑
				else
				{
					onEnterFrame(event);
				}
			}
			//行走
			else
			{
				var angle:Number = Math.atan2(dy, dx);
				var speedX:Number = _moveSpeed * Math.cos(angle);
				var speedY:Number = _moveSpeed * Math.sin(angle);
				_player.x += speedX;
				_player.y += speedY;
			}
		}
	}
}