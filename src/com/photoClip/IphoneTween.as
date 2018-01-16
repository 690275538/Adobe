package  com.photoClip 
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author boycy815
	 */
	public class IphoneTween extends Sprite 
	{
		//一些图片尺寸和位置信息
		private var IMGWIDTH:Number = 243;
		private var IMGHEIGHT:Number = 341;
		private var IMGX:Number = 0;
		private var IMGY:Number = 0;
		//图片边上面的点数（包括两端）？横竖都分一样。段数越多越细腻，越吃资源
		private const SEGMENT:int = 10;
		//点到目标点的距离和延迟时间的系数
		private const DELAY:Number = 1 / 1500;
		static public const TWEENEND:String = "tweenend";
		//点到目标点补间所用时间
		private var TIME:Number = 0.2;
		//位图资源
		private var img:BitmapData;
		//是否已经隐藏图片
		private var ifHide:Boolean = false;
		//是否在播放动画
		private var isTweening:Boolean = false;
		//位图被分成三角形网格之后，记录顶点坐标，不知道这个东西什么用的请参考API的Graphics.drawTriangles方法的第一个参数
		private var vertexes:Vector.<Number> = new Vector.<Number>(SEGMENT * SEGMENT * 2);
		//意义同vertexes，points被缓动，然后把值赋给vertexes进行渲染
		private var points:Vector.<Point> = new Vector.<Point>(SEGMENT * SEGMENT);
		//三角形点目录，请参考API的Graphics.drawTriangles方法的第二个参数
		private var indices:Vector.<int> = new Vector.<int>((SEGMENT - 1) * (SEGMENT - 1) * 6);
		//uv纹理，请参考API的Graphics.drawTriangles方法的第三个参数
		private var uvs:Vector.<Number> = new Vector.<Number>(SEGMENT * SEGMENT * 2);
		//缓动时间轴，用于回放动画
		private var tweens:TimelineLite;
		private var sp:Sprite;
		
		public function IphoneTween(sp:Sprite, time:Number =0.5):void 
		{
			init( sp,time);
		}
		
		private function init(sp:Sprite, time:Number ):void 
		{
			this.sp = sp;
			this.x = sp.x;
			this.y = sp.y;
			sp.visible = false;
			this.IMGWIDTH = sp.width;
			this.IMGHEIGHT = sp.height;
			this.TIME = time;
			
			//var sp:Sprite = new MyPic();//swc里的图片资源
			img = new BitmapData(IMGWIDTH, IMGHEIGHT);
			img.draw(sp,new Matrix(sp.scaleX, 0, 0, sp.scaleY));//存到位图里面
			
			var u:Number = IMGWIDTH / (SEGMENT - 1);//水平相邻点距离
			var v:Number = IMGHEIGHT / (SEGMENT - 1);//竖直相邻点距离
			var s:Number = 1 / (SEGMENT - 1);//水平和竖直相邻点距离占总长的百分比（uv纹理用的）
			var vi:int = 0;
			for (var i:int = 0; i < SEGMENT; i++)
			{
				for (var j:int = 0; j < SEGMENT; j++)
				{
					//计算点的坐标并写入对应的数组位置
					var lp:Point = new Point(j * u + IMGX, i * v + IMGY);
					vertexes[vi] = lp.x;
					uvs[vi++] = j * s;
					vertexes[vi] = lp.y;
					uvs[vi++] = i * s;
					points[i * SEGMENT + j] = lp;
				}
			}
			vi = 0;
			var ii:int = 0;
			for (i = 0; i < SEGMENT - 1; i++)
			{
				for (j = 0; j < SEGMENT - 1; j++)
				{
					//指定三角形各个点和vertexes中点的对应关系
					indices[ii++] = vi;
					indices[ii++] = vi + 1;
					indices[ii++] = vi + SEGMENT + 1;
					indices[ii++] = vi;
					indices[ii++] = vi + SEGMENT;
					indices[ii++] = vi + SEGMENT + 1;
					vi++;
				}
				vi++;
			}
			
 
			
			//第一次绘制
			this.graphics.clear();
			this.graphics.beginBitmapFill(img);
			this.graphics.drawTriangles(vertexes, indices, uvs);
			this.graphics.endFill();
		}
		
		//点击事件
		public function runShow( tx:Number, ty:Number,isReturn:Boolean=true ):void
		{
			var point:Point = new Point( tx, ty );
			var point2:Point = this.globalToLocal( point );
			
			//获取鼠标坐标
			var tweenX:Number = point2.x;
			var tweenY:Number = point2.y;
			var i:int = points.length - 1;//遍历的中间变量
			var dist:Number;//点和目标点的距离
			if (isTweening == true) return;//如果正在播放动画，则点击无效
			this.addEventListener(Event.ENTER_FRAME, frame);//点击后，要执行动画渲染
			this.visible = true;
			//如果图片隐藏状态
			if (ifHide)
			{
				//将隐藏的动画反向播放
				tweens.reverse();
				//设置为不隐藏
				ifHide = false;
				//设置为正在播放
				isTweening = true;
			}
			//如果图片不是隐藏的
			else
			{
				sp.visible = false;
				//创建一个缓动时间轴动画，并在动画播放完后执行tweenOver
				tweens = new TimelineLite( { paused:true, onComplete:tweenOver, onReverseComplete:tweenOver } );
				do
				{
					//计算点到目标点，也就是鼠标点击的点的距离
					dist = Math.sqrt(Math.pow(tweenX - points[i].x, 2) + Math.pow(tweenY - points[i].y, 2));
					//在时间轴上添加对Point数据的缓动，缓动开始时间和点到目标点的距离成正比，这个是效果的关键
					tweens.insert(TweenLite.to(points[i], TIME, { x:tweenX, y:tweenY } ), dist * DELAY);
				}
				while (i--)
				tweens.play();//开始对Point数据进行缓动
				ifHide = true;//设置隐藏
				isTweening = true;//设置正在动画
			}
		}
		
		//动画播放结束调用
		private function tweenOver():void
		{
			isTweening = false;
			this.removeEventListener(Event.ENTER_FRAME, frame);//动画播放完毕 停止渲染
			this.dispatchEvent( new Event( TWEENEND ) );
			//if(ifHide)
			trace(ifHide);
			sp.visible = !ifHide;
		}
		
		//渲染
		private function frame(e:Event):void
		{
			var vi:int = 0;
			var pi:int = 0;
			var i:int = SEGMENT * SEGMENT;
			//把Point的数据写到vertexes中
			while (i--)
			{
				vertexes[vi++] = points[pi].x;
				vertexes[vi++] = points[pi++].y;
			}
			//绘制
			this.graphics.clear();
			this.graphics.beginBitmapFill(img);
			this.graphics.drawTriangles(vertexes, indices, uvs);
			this.graphics.endFill();
		}
		
			/*it = new IphoneTween();
			it.init( img, 1000, 750, 0.5 );
			addChild( it );
			it.scaleX = it.scaleY = img.scaleX;
			it.x = img.x;
			it.y = img.y;
			it.runShow( 800, 1200 );
			img.visible = false;
			it.addEventListener( "tweenEnd", onTweenEnd );
			
			it2 = new IphoneTween();
			it2.init( img2, 1000, 750, 0.5 );
			//addChild( it2 );
			it2.scaleX = it2.scaleY = img2.scaleX;
			it2.x = img2.x;
			it2.y = img2.y;
			it2.runShow( 800, 1200 );
			img2.visible = false;*/

			/*
			 * 
			 * private function onTweenEnd( e:Event ):void
		{
			//
			it2.runShow( 420, 1200 );
			addChild( it2 );
			it.removeEventListener( "tweenEnd", onTweenEnd );
			it2.addEventListener( "tweenEnd", onTweenEnd2);
		//	TweenMax.to( it, 0.5, { x:0, y:0, scaleX:1, scaleY:1 } );
		}
		private function onTweenEnd2( e:Event ):void
		{
			it2.removeEventListener( "tweenEnd", onTweenEnd2);
		}
		*/
	}
	
}