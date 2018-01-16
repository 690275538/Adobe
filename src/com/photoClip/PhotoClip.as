package com.photoClip
 

{
	import com.greensock.easing.Bounce;
	import com.greensock.TweenLite;
	//import com.rippler.Rippler;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...  图片碎片格子 类    2014.10.12
	 * @author Adobe
	 */
	public class PhotoClip extends Sprite
	{
		/**
		 * 是否按顺序交换位置
		 */
		public var isOrderly:Boolean=true; //
		private var itemVector:Vector.<flash.display.Bitmap>; //图片碎片的存放
		private var itemPoint:Vector.<flash.geom.Point>; //打乱坐标
		private var itemPoint1:Vector.<flash.geom.Point>; //正确坐标
		private const ITEM_DELAY:Number = 0.002;
		private var spr:Sprite;
		private var itemInt:Vector.<int>;  
		
		//每帧循环多少次
		private var _num:int = 100;
		//已经循环的总次数
		private var _totalNum:int;
		//循环的总次数
		private var _allNum:int;
		private var p:Vector.<Point>
		public function PhotoClip(mc:DisplayObject, widNum:uint = 30, heiNum:uint = 30)
		{
			itemVector = new Vector.<Bitmap>();
			itemPoint = new Vector.<Point>();
			itemPoint1 = new Vector.<Point>();
			itemInt = new Vector.<int>(); //随机数
			spr = new Sprite();
			spr.x = mc.x;
			spr.y = mc.y;
			mc.parent.addChild(spr);
			var tempBitData:BitmapData;
			var tempBitmap:Bitmap = new Bitmap(new BitmapData(mc.width, mc.height));
			tempBitmap.bitmapData.draw(mc, new Matrix(mc.scaleX, 0, 0, mc.scaleY));
			tempBitData = tempBitmap.bitmapData;
			//  宽    高
			var wid:uint = mc.width / widNum;
			var hei:uint = mc.height / heiNum;
			var itemShu:uint = 0;
			for (var i:int = 0; i < heiNum; i++)
			{
				for (var j:int = 0; j < widNum; j++)
				{
					var bitmap:Bitmap = new Bitmap(new BitmapData(wid, hei));
					var p:Point = new Point();
					p.x = j * wid;
					p.y = i * hei;
					
					spr.addChildAt(bitmap, 0);
					
					itemVector.push(bitmap);
					itemPoint.push(p);
					itemPoint1.push(p);
					bitmap.bitmapData.copyPixels(tempBitData, new Rectangle(p.x, p.y, wid, hei), new Point(0, 0));
					itemInt.push(itemShu);
					itemShu++;
				}
			}
			mc.parent.removeChild(mc);
		}
		
		/**
		 * //摆放位置
		 * @param	isRight  是否放到正确位置
		 */
		public function put(isRight:Boolean = false):void
		{
			itemPoint.sort(randomFunction);
			if (!isOrderly)
			{
				itemInt.sort(randomFunction); //是否有序 填充
			}
			p = isRight ? itemPoint1 : itemPoint;
			var shu:uint = itemVector.length;
			_allNum = itemVector.length;
			for (var i:int = 0; i < shu; i++)
			{
				var item0:Bitmap = itemVector[itemInt[i]];
				var point0:Point = p[itemInt[i]];
				TweenLite.to(item0, 0.5, {x: point0.x, y: point0.y, delay: i * ITEM_DELAY, ease: Bounce.easeOut});
			}
          
		}
 
		/**
		 * 移动所有的clip  到指定位置
		 * @param	xx
		 * @param	yy
		 */
		public function putAllto(xx:Number,yy:Number):void
		{
			var point2:Point = this.localToGlobal( new Point(xx,yy) );
			for (var i:int = 0; i < itemVector.length; i++)
			{
				TweenLite.to(itemVector[i], 0.5, {x: point2.x, y: point2.y, delay: i * ITEM_DELAY, ease: Bounce.easeOut});
			}
		}
		
		private function randomFunction(n1:*, n2:*):int
		{
			return (Math.random() < 0.5) ? -1 : 1;
		}
	}

}