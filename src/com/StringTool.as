package com
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getQualifiedSuperclassName;
	/**
	 * ...  
	 * @author ...
	 */
	public class StringTool 
	{
		
		/**
		 * 获取 一个类的名字   直接传 一个  this 就可以
		 * @param obj
		 * @return 
		 * 
		 */		
		public static  function getClassName(obj:*):String
		{
			var str:String = String(obj).substring(8, String(obj).length - 3);
			trace("获取类名 :",obj,str);
			return str;
		}
		/**
		 * 遍历  object  里面的值
		 */
		public static function getObjParams(obj:Object):void
		{
			var i:int = 0;
			for (var name:String in obj) 
			{
				i++;
				trace(name,"=",obj[name]);
			}
			trace(obj, "共",i,"个属性");
		}
		/**
		 *   返回mc 全局 的坐标区域
		 * @param	mc
		 * @return
		 */
		public static function getRectArea(mc:DisplayObject):String
		{
			var point:Point = mc.localToGlobal(new Point(0, 0));
			return  (point.x+";"+point.y+";"+mc.width+";"+mc.height);
			
		}
		
	}

}