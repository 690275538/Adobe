﻿package  com.pathfinding
{
	import flash.geom.Point;

	/**
	 * Holds a two-dimensional array of Nodes methods to manipulate them, start node and end node for finding a path.
	 */
	public class Grid
	{
		private var _startNode:Node;
		private var _endNode:Node;
		private var _nodes:Array;
		private var _numCols:int;
		private var _numRows:int;
		
		/**
		 * Constructor.
		 */
		public function Grid(numCols:int=0, numRows:int=0)
		{
			_numCols = numCols;
			_numRows = numRows;
			_nodes = new Array();
			
			for(var i:int = 0; i < _numCols; i++)
			{
				_nodes[i] = new Array();
				for(var j:int = 0; j < _numRows; j++)
				{
					_nodes[i][j] = new Node(i, j);
				}
			}
		}
		
		
		////////////////////////////////////////
		// public methods
		////////////////////////////////////////
		
		/**
		 * Returns the node at the given coords.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function getNode(x:int, y:int):Node
		{
			return _nodes[x][y] as Node;
		}
		
		/**
		 * Sets the node at the given coords as the end node.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function setEndNode(x:int, y:int):void
		{
			_endNode = _nodes[x][y] as Node;
		}
		
		/**
		 * Sets the node at the given coords as the start node.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function setStartNode(x:int, y:int):void
		{
			_startNode = _nodes[x][y] as Node;
		}
		
		/**
		 * Sets the node at the given coords as walkable or not.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function setWalkable(x:int, y:int, value:Boolean):void
		{
			_nodes[x][y].walkable = value;
		}
		
		
		
		/**
		 * 得到一个点下的所有节点 
		 * @param xPos		点的横向位置
		 * @param yPos		点的纵向位置
		 * @param exception	例外格，若其值不为空，则在得到一个点下的所有节点后会排除这些例外格
		 * @return 			共享此点的所有节点
		 * 
		 */		
		public function getNodesUnderPoint( xPos:Number, yPos:Number, exception:Array=null ):Array
		{
			var result:Array = [];
			var xIsInt:Boolean = xPos % 1 == 0;
			var yIsInt:Boolean = yPos % 1 == 0;
			
			//点由四节点共享情况
			if( xIsInt && yIsInt )
			{
				result[0] = getNode( xPos - 1, yPos - 1);
				result[1] = getNode( xPos, yPos - 1);
				result[2] = getNode( xPos - 1, yPos);
				result[3] = getNode( xPos, yPos);
			}
				//点由2节点共享情况
				//点落在两节点左右临边上
			else if( xIsInt && !yIsInt )
			{
				result[0] = getNode( xPos - 1, int(yPos) );
				result[1] = getNode( xPos, int(yPos) );
			}
				//点落在两节点上下临边上
			else if( !xIsInt && yIsInt )
			{
				result[0] = getNode( int(xPos), yPos - 1 );
				result[1] = getNode( int(xPos), yPos );
			}
				//点由一节点独享情况
			else
			{
				result[0] = getNode( int(xPos), int(yPos) );
			}
			
			//在返回结果前检查结果中是否包含例外点，若包含则排除掉
			if( exception && exception.length > 0 )
			{
				for( var i:int=0; i<result.length; i++ )
				{
					if( exception.indexOf(result[i]) != -1 )
					{
						result.splice(i, 1);
						i--;
					}
				}
			}
			
			return result;
		}
		
		/**
		 * 判断两节点之间是否存在障碍物 
		 * 
		 */		
		public function hasBarrier( startX:int, startY:int, endX:int, endY:int ):Boolean
		{
			//如果起点终点是同一个点那傻子都知道它们间是没有障碍物的
			if( startX == endX && startY == endY )return false;
			
			//两节点中心位置
			var point1:Point = new Point( startX + 0.5, startY + 0.5 );
			var point2:Point = new Point( endX + 0.5, endY + 0.5 );
			
			//1.根据起点终点间横纵向距离的大小来判断遍历方向
			var distX:Number = Math.abs(endX - startX);
			var distY:Number = Math.abs(endY - startY);									
			
			/**遍历方向，为true则为横向遍历，否则为纵向遍历*/
			var loopDirection:Boolean = distX > distY ? true : false;
			
			//2.根据起终点连线斜率来判断遍历方向
//			var slope:Number = MathUtil.getSlope(new Point(startX, startY), new Point(endX, endY));
//				trace("slope: " + slope);
//			var loopDirection:Boolean = Math.abs(slope) <= 1 ? true : false;
			
			/**起始点与终点的连线方程*/
			var lineFuction:Function;
			
			/** 循环递增量 */
			var i:Number;
			
			/** 循环起始值 */
			var loopStart:Number;
			
			/** 循环终结值 */
			var loopEnd:Number;
			
			/** 起终点连线所经过的节点 */
			var passedNodeList:Array;
			var passedNode:Node;
			
			//为了运算方便，以下运算全部假设格子尺寸为1，格子坐标就等于它们的行、列号
			if( loopDirection )
			{				
				lineFuction = MathUtil.getLineFunc(point1, point2, 0);
				
				loopStart = Math.min( startX, endX );
				loopEnd = Math.max( startX, endX );
				
				//开始横向遍历起点与终点间的节点看是否存在障碍(不可移动点) 
				for( i=loopStart; i<=loopEnd; i++ )
				{
					//由于线段方程是根据终起点中心点连线算出的，所以对于起始点来说需要根据其中心点
					//位置来算，而对于其他点则根据左上角来算
					if( i==loopStart )i += .5;
					//根据x得到直线上的y值
					var yPos:Number = lineFuction(i);
					
					
					//检查经过的节点是否有障碍物，若有则返回true
					passedNodeList = getNodesUnderPoint( i, yPos );
					for each( passedNode in passedNodeList )
					{
						if( passedNode.walkable == false )return true;
					}
					
					if( i == loopStart + .5 )i -= .5;
				}
			}
			else
			{
				lineFuction = MathUtil.getLineFunc(point1, point2, 1);
				
				loopStart = Math.min( startY, endY );
				loopEnd = Math.max( startY, endY );
				
				//开始纵向遍历起点与终点间的节点看是否存在障碍(不可移动点)
				for( i=loopStart; i<=loopEnd; i++ )
				{
					if( i==loopStart )i += .5;
					//根据y得到直线上的x值
					var xPos:Number = lineFuction(i);
					
					passedNodeList = getNodesUnderPoint( xPos, i );
					
					for each( passedNode in passedNodeList )
					{
						if( passedNode.walkable == false )return true;
					}
					
					if( i == loopStart + .5 )i -= .5;
				}
			}

			return false;			
		}
		
		////////////////////////////////////////
		// getters / setters
		////////////////////////////////////////
		
		/**
		 * Returns the end node.
		 */
		public function get endNode():Node
		{
			return _endNode;
		}
		
		/**
		 * Returns the number of columns in the grid.
		 */
		public function get numCols():int
		{
			return _numCols;
		}
		
		/**
		 * Returns the number of rows in the grid.
		 */
		public function get numRows():int
		{
			return _numRows;
		}
		
		/**
		 * Returns the start node.
		 */
		public function get startNode():Node
		{
			return _startNode;
		}
		
	}
}