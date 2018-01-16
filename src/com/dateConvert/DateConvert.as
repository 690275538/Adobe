/**
 * 时钟显示的转换
* ibio-develop
* 2008-11-20 18:36
*/
package  com.dateConvert {
	
	public class DateConvert {
		
		/**
		 * vtm:video time mark string
		 * @param	sec:uint 秒数
		 * @param	mode:uint 返的类型
		 * 				0 小时 : 分钟 : 秒钟 : 秒钟 . 毫秒
		 * 				1 小时
		 * 				2 分钟
		 * 				3 秒钟
		 * 				4 毫秒
		 * 				5 小时 : 分钟
		 * 				6 分钟 : 秒钟
		 * @return String
		 */
		static public function sec2vtm(seconds:uint, mode:uint = 0):String {
			var milliseconds:Number = (seconds - Math.floor(seconds)) * 1000;
			var d:Date = new Date(0, 0, 0, 0, 0, seconds, milliseconds);
			var currDate:String = "";
			//
			var hour:String =(d.getHours() < 10) ? ('0' + d.getHours()) : String(d.getHours());
			var min:String = (d.getMinutes() < 10) ? ('0' + d.getMinutes()) : String(d.getMinutes());
			var sec:String = (d.getSeconds() < 10) ? ('0' + d.getSeconds()) : String(d.getSeconds());
			var ms:String = (d.getMilliseconds() < 10) ? ('0' + d.getMilliseconds()) : String(d.getMilliseconds());
			switch(mode) {
				case 1:
					currDate = hour;
					break;
				case 2:
					currDate = min;
					break;
				case 3:
					currDate = sec;
					break;
				case 4:
					currDate = ms;
					break;
				case 5:
					currDate = hour + ":" + min;
					break;
				case 6:
					currDate = min + ":" + sec;
					break;
				default:
					currDate = hour + ":" + min + ":" + sec + "." + ms;
			}
			return currDate;
		}
		/**
		 *   事件转换成秒数    格式  39：39：39
		 * @param	vtm   
		 * @return
		 */
		static public function vtm2sec(vtm:String):Number {
			var list:Array;
			var ms:Number = 0;
			var s:Number = 0;
			var m:Number = 0;
			var h:Number = 0;
			
			if (vtm.indexOf(".") != -1) {
				var temp:Array = vtm.split(".", 2);
				list = temp[0].split(':', 3).reverse();
				ms = Number(temp[1]);
			}else {
				list = vtm.split(':', 3).reverse();
			}
			
			for (var i:uint = 0; i < list.length; i++) {
				//秒
				if (i == 0) {
					s = Number(list[i]);
				}
				//分
				if (i == 1) {
					m = Number(list[i]);
				}
				//时
				if (i == 2) {
					h = new Number(list[i]);
				}
			}
			return h * 60 * 60 + m * 60 + s + ms / 1000;
		}
	}
}
	