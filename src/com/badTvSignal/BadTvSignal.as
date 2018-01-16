package com.badTvSignal
{
	/**
	 * 
	 * 
	 * 模仿电视被干扰效果  
	 * 使用方法
	 * var badTvSignal:BadTvSignal = new BadTvSignal(mc);
	   addChild(badTvSignal);
	
	   //Start the continue effect.
	   badTvSignal.start();
	
	   //Start the random effect.
	   badTvSignal.startRandom();
	
	   //Stop the random effect.
	   badTvSignal.stop();
	 *
	 *
	 *
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class BadTvSignal extends Sprite
	{
		//Used to keep track if the effect is running or not...  
		public static var isRunning:Boolean;
		//The display object on which the effect is applied.    
		private var _sourceDisplayObject:DisplayObject;
		//The final bitmap, the one on which the effect is applied.  
		private var _finalBitmap:Bitmap;
		//Used as a bitmap data for the final bitmap.             
		private var _finalBitmapData:BitmapData;
		//Use to create the noise sound.                
		private var _sound:Sound;
		//Used to play the noise sound.                
		private var _soundChannel:SoundChannel;
		//Holds a reference to a set of Point instances, used to displace the pixels. 
		private var _rgbPoints:Array;
		//Used as a random numebr to displace the bitmapData pixels.     
		private var _randomNr:Number;
		//Used as an id for the random noise interval.              
		private var _stopNoiseDisplayIntervalId:int;
		//Used as an id for the random noise interval.            
		private var _startNoiseDisplayIntervalId:int;
		//Used as a flag to check if the sound is playing.   
		private var _isSoundPlaying:Boolean;
		
		public function BadTvSignal(sourceDisplayObject:DisplayObject)
		{
			_sourceDisplayObject = sourceDisplayObject;
			setProperties();
			//setupSound();                
		}
		
		//SET PROPERTIES.               
		private function setProperties():void
		{
			_rgbPoints = [new Point(0, 0), new Point(0, 0), new Point(0, 0)];
			_randomNr = 3.1;
		}
		
		//SETUP SOUND.                
		/*private function setupSound():void
		   {
		   _soundChannel = new SoundChannel();
		   _sound = new Noise();
		 } */
		//这些注释掉的类 是用来 播放声音效果的
		/*private function playSound():void
		   {
		   _soundChannel = _sound.play();
		   var st:SoundTransform = new SoundTransform(.5 + Math.random() * .3, -1 + Math.random() * 2 )
		   _soundChannel.soundTransform = st;
		   _isSoundPlaying = true;
		   _soundChannel.addEventListener(Event.SOUND_COMPLETE, loopSound);
		 }*/
		
		/** Loop the sound. */
		private function loopSound(e:Event):void
		{
			if (_soundChannel != null)
			{
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
					//playSound();
			}
		}
		
		/** Stop the sound. */
		private function stopSound():void
		{
			if (_soundChannel != null)
			{
				_soundChannel.stop();
				_isSoundPlaying = false;
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
			}
		}
		
		//START / STOP / RUN EFFECT.   
		public function start():void
		{
			//playSound();                    
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_sourceDisplayObject.visible = false;
			this.visible = true;
		}
		
		public function stop():void
		{
			stopSound();
			clearTimeout(_stopNoiseDisplayIntervalId);
			clearTimeout(_startNoiseDisplayIntervalId);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_sourceDisplayObject.visible = true;
			if (_finalBitmap != null)
				_finalBitmap.bitmapData.dispose();
			this.visible = false;
			isRunning = false;
		}
		
		public function startRandom():void
		{
			clearTimeout(_stopNoiseDisplayIntervalId);
			clearTimeout(_startNoiseDisplayIntervalId);
			_startNoiseDisplayIntervalId = setTimeout(start, randomize(0, 1000));
			_stopNoiseDisplayIntervalId = setTimeout(stopRandomAndRestart, randomize(1000, 1800));
		}
		
		private function stopRandomAndRestart():void
		{
			clearTimeout(_stopNoiseDisplayIntervalId);
			stop();
			startRandom();
		}
		
		private function enterFrameHandler(e:Event):void
		{
			isRunning = true;
			runEffect();
		}
		
		//THIS FUNCTION CREATES THE BAD TV EFFECT.
		
		private function runEffect():void
		{
			var auxImg1:BitmapData;
			var auxImg2:BitmapData;
			var sourceWidth:Number = _sourceDisplayObject.width;
			var sourceHeight:int = _sourceDisplayObject.height;
			if (_finalBitmapData != null)
				_finalBitmapData.dispose();
			_finalBitmapData = new BitmapData(sourceWidth, sourceHeight, false);
			_finalBitmap = new Bitmap(_finalBitmapData);
			addChild(_finalBitmap);
			_finalBitmapData.draw(_sourceDisplayObject);
			auxImg1 = _finalBitmapData.clone();
			auxImg2 = _finalBitmapData.clone();
			for (var i:int = 0; i < 3; i++)
			{
				_rgbPoints[i].x = randomize(-4, 4);
			}
			var displacementFactor:Number = (Math.abs(_rgbPoints[0].x) + Math.abs(_rgbPoints[1].x) + Math.abs(_rgbPoints[2].x) + 8) / 4;
			for (i = sourceHeight; i > 0; i--)
			{
				var displacementX:Number = Math.sin(i / sourceHeight * (Math.random() / 8 + 1) * _randomNr * 3.1 * 2) * _randomNr * displacementFactor * displacementFactor;
				auxImg1.copyPixels(_finalBitmapData, new Rectangle(displacementX, i, sourceWidth - displacementX, 1), new Point(0, i));
			}
			if (displacementFactor > 3.5)
			{
				_randomNr = Math.random() * 2;
			}
			auxImg2.noise(int(Math.random() * 1000));
			var colorNoise:Number = displacementFactor * displacementFactor * displacementFactor;
			auxImg1.merge(auxImg2, auxImg1.rect, new Point(0, 0), colorNoise, colorNoise, colorNoise, 0);
			_finalBitmapData.copyChannel(auxImg1, _finalBitmapData.rect, _rgbPoints[0], BitmapDataChannel.RED, BitmapDataChannel.RED);
			_finalBitmapData.copyChannel(auxImg1, _finalBitmapData.rect, _rgbPoints[1], BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
			_finalBitmapData.copyChannel(auxImg1, _finalBitmapData.rect, _rgbPoints[2], BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
		}
		
		//RETURNS A RAMNDOM NUMBER BETWEEN THE MIN AND MAX VALUES.                
		public function randomize(min:int, max:int):int
		{
			var ran:int = Math.floor(Math.random() * (max - min + 1)) + min;
			return ran;
		}
	
	}
}