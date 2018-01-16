package com.daojishi
{
	 
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Adobe
	 */
	public class DaoJiShi
	{
		
		public static var timeTxt:String = "";
		public static var isOver:Boolean = false;
		private static var totalTime:int;
		private static var crtTime:int;
		public function DaoJiShi()
		{
		    
		}
		
		
		public static function reset():void
		{
			
			crtTime =  getTimer() + 1000 * totalTime;
			
		}
		/**
		 *  倒计时开始
		 * @param	mc  进度条  控制他 scaleX
		 * @param	daoJiShiTxt  显示时间的 txt
		 * @return  返回一个 进度条的坐标 + 进度条的宽度 number
		 */
		public static function start(mc:DisplayObject, daoJiShiTxt:TextField,bar:MovieClip):Number
		{
			
			var passTime:int = crtTime - getTimer();
			//trace(passTime,"------------");
			var seconds:int = passTime / 1000;
			var minutes:int = seconds / 60;
			seconds -= minutes * 60;
			var Milliseconds:int = passTime - seconds * 1000 - minutes * 1000 * 60;
			var str:String = String(minutes + 100).substr(1, 4) + ":" + String(seconds + 100).substr(1, 4) + ":" + String(Milliseconds + 1000).substr(1, 2);
			//说明下substr的用法：比如substr(1,3)意思是从字符串的第2个位置开始显示出3个长度的内容
			timeTxt = str;
			daoJiShiTxt.text = timeTxt;
			//mc为舞台上进度条的实例名称
			mc.scaleX = 1 - (passTime)/( 1000 * totalTime);
			bar.x = mc.width + mc.x;
			if (passTime <= 0)
			{
				
				mc.scaleX = 1;
				timeTxt = "00:00:00";
				daoJiShiTxt.text = timeTxt;
				trace("倒计时结束");
				isOver = true;
			}
			
			return mc.width + mc.x;
		}
	}

}