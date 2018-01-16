package com.pathfinding
{ 
	/**
	 * Represents a specific node evaluated as part of a pathfinding algorithm.
	 */
	public class Node
	{
		public var x:int;
		public var y:int;
		//决定哪些方格会形成路径
		public var f:Number;
		//从起点A沿着已生成的路径到一个给定方格的移动开销。
		public var g:Number;
		//从给定方格到目的方格的估计移动开销
		public var h:Number;
		public var walkable:Boolean = true;
		public var parent:Node;
		public var costMultiplier:Number = 1.0;
		
		public function Node(x:int, y:int)
		{
			this.x = x;
			this.y = y;
		}
	}
}