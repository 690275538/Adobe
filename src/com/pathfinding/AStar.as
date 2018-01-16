package  com.pathfinding
{
	import flash.utils.getTimer;

	public class AStar
	{
//		private var _open:Array = [];
		private var _open:Binary;
//		private var _closed:Array;
		private var _closed:Array;
		private var _grid:Grid;
		private var _endNode:Node;
		private var _startNode:Node;
		private var _path:Array;
//		private var _heuristic:Function = manhattan;
//		private var _heuristic:Function = euclidian;
		private var _heuristic:Function = diagonal;
		private var _straightCost:Number = 1.0;
		private var _diagCost:Number = Math.SQRT2;
		
		public function AStar()
		{
		}
		
		public function findPath(grid:Grid):Boolean
		{
			_grid = grid;
//			_open = new Array();
			_open = new Binary("f");
			_closed = new Array();
			
			_startNode = _grid.startNode;
			_endNode = _grid.endNode;
			
			_startNode.g = 0;
			_startNode.h = _heuristic(_startNode);
			_startNode.f = _startNode.g + _startNode.h;
			
			return search();
		}
		
		public function search():Boolean
		{
			var startTime:int=getTimer();
			var node:Node = _startNode;
			var sortTime:int = 0;
			var tryCount:int = 0;
			while(node != _endNode)
			{
				tryCount++;
				var startX:int = 0 > node.x - 1 ? 0 : node.x - 1;
				var endX:int = _grid.numCols - 1 < node.x + 1 ? _grid.numCols - 1 : node.x + 1;
				var startY:int = 0 > node.y - 1 ? 0 : node.y - 1;
				var endY:int = _grid.numRows - 1 < node.y + 1 ? _grid.numRows - 1 : node.y + 1;
				
				
				for(var i:int = startX; i <= endX; i++)
				{
					for(var j:int = startY; j <= endY; j++)
					{
						var test:Node = _grid.getNode(i, j);
						if(test == node)
						{
							continue;
						}
						
						if( !test.walkable || !isDiagonalWalkable(node, test) )
						{
							test.costMultiplier = int.MAX_VALUE;
						}
						else
						{
							test.costMultiplier = 1;
						}
							
						var cost:Number = _straightCost;
						
						if(!((node.x == test.x) || (node.y == test.y)))
						{
							cost = _diagCost;
						}
						
						var g:Number = node.g + cost * test.costMultiplier;
						var h:Number = _heuristic(test);
						var f:Number = g + h;
						var isInOpen:Boolean = _open.indexOf(test) != -1;
						if( isInOpen || _closed.indexOf(test) != -1)
						{
							if(test.f > f)
							{
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
								if( isInOpen )
									_open.updateNode( test );
							}
						}
						else
						{
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
//							_open.push(test);
							_open.push( test );
						}
					}
				}
				_closed.push(node);
				if(_open.length == 0)
				{
					trace("no path found");
					
					return false
				}
				var sortStartTime:int = getTimer();
//				_open.sortOn("f", Array.NUMERIC);
				
//				node = _open.shift() as Node;
				node = _open.shift() as Node;
				sortTime += (getTimer() - sortStartTime);
			}
			//trace( "time cost: " + (getTimer() - startTime) + "ms");
			//trace( "sort cost: " + sortTime);
			//trace( "try time: " + tryCount);
			buildPath();
			return true;
		}
		
		private function buildPath():void
		{
			_path = new Array();
			var node:Node = _endNode;
			_path.push(node);
			
			//不包含起始节点
			while(node.parent != _startNode)
			{
				node = node.parent;
				_path.unshift(node);
			}
			//排除无法移动点
			var len:int = _path.length;
			for( var i:int=0; i<len; i++ )
			{
				if( _path[i].walkable == false )
				{
					_path.splice(i, len-i);
					break;
				}
				//由于之前排除了起始点，所以当路径中只有一个元素时候判断该元素与起始点是否是不可穿越关系，若是，则连最后这个元素也给他弹出来~
				else if( len == 1 && !isDiagonalWalkable(_startNode, _endNode) )
				{
					_path.shift();
				}
				//判断后续节点间是否存在不可穿越点，若有，则把此点之后的元素全部拿下
				else if( i < len - 1 && !isDiagonalWalkable(_path[i], _path[i+1]) )
				{
					_path.splice(i+1, len-i-1);
					break;
				}
			}
		}
		
		public function get path():Array
		{
			return _path;
		}

		
		/** 判断两个节点的对角线路线是否可走 */
		private function isDiagonalWalkable( node1:Node, node2:Node ):Boolean
		{
			var nearByNode1:Node = _grid.getNode( node1.x, node2.y );
			var nearByNode2:Node = _grid.getNode( node2.x, node1.y );
			
			if( nearByNode1.walkable && nearByNode2.walkable )return true;
			return false;
		}
		
		private function manhattan(node:Node):Number
		{
			return Math.abs(node.x - _endNode.x) * _straightCost + Math.abs(node.y + _endNode.y) * _straightCost;
		}
		
		private function euclidian(node:Node):Number
		{
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return Math.sqrt(dx * dx + dy * dy) * _straightCost;
		}
		
		private function diagonal(node:Node):Number
		{
			var dx:Number = node.x - _endNode.x < 0 ? _endNode.x - node.x : node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y < 0 ? _endNode.y - node.y : node.y - _endNode.y;
			var diag:Number = dx < dy ? dx : dy;
			var straight:Number = dx + dy;
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}
		
//		public function get visited():Vector.<Node>
//		{
//			return _closed.concat(_open);
//		}
	}
}
