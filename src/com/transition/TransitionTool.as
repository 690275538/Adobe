package com.transition
{
	
	
	import fl.transitions.Blinds;
	import fl.transitions.Fade;
	import fl.transitions.Iris;
	import fl.transitions.Photo;
	import fl.transitions.PixelDissolve;
	import fl.transitions.Transition;
	import fl.transitions.TransitionManager;
	import fl.transitions.Wipe;
	import fl.transitions.easing.None;
	import fl.transitions.easing.Strong;
	
	/**
	 * ...
	 * @author Adobe
	 */
	public class TransitionTool
	{
		
		public function TransitionTool()
		{
		
		}
		
		public function showEffect(showMC):void
		{
			var randomNum:Number = Math.floor(Math.random() * 16);
			switch (randomNum)
			{
				case 0: 
					//横向卷帘
					TransitionManager.start(showMC, {type: Blinds, direction: Transition.IN, duration: 2, easing: None.easeNone, numStrips: 10, dimension: 0});
					break;
				case 1: 
					//纵向卷帘
					TransitionManager.start(showMC, {type: Blinds, direction: Transition.IN, duration: 2, easing: None.easeNone, numStrips: 10, dimension: 1});
					break;
				case 2: 
					//淡入效果
					TransitionManager.start(showMC, {type: Fade, direction: Transition.IN, duration: 2, easing: None.easeNone});
					break;
				case 3: 
					//圆形打开
					TransitionManager.start(showMC, {type: Iris, direction: Transition.IN, duration: 2, easing: Strong.easeOut, startPoint: 2, shape: Iris.CIRCLE});
					break;
				case 4: 
					//淡入闪光
					TransitionManager.start(showMC, {type: Photo, direction: Transition.IN, duration: 2, easing: None.easeNone});
					break;
				case 5: 
					//棋盘马赛克
					TransitionManager.start(showMC, {type: PixelDissolve, direction: Transition.IN, duration: 2, easing: None.easeNone, xSections: 10, ySections: 10});
					break;
				case 6: 
					//向右下侧卷帘
					TransitionManager.start(showMC, {type: Wipe, direction: Transition.IN, duration: 2, easing: None.easeNone, startPoint: 1});
					break;
				case 7: 
					//向下卷帘
					TransitionManager.start(showMC, {type: Wipe, direction: Transition.IN, duration: 2, easing: None.easeNone, startPoint: 2});
					break;
				case 8: 
					//向左下侧卷帘
					TransitionManager.start(showMC, {type: Wipe, direction: Transition.IN, duration: 2, easing: None.easeNone, startPoint: 3});
					break;
				case 9: 
					//各种卷帘
					TransitionManager.start(showMC, {type: Wipe, direction: Transition.IN, duration: 2, easing: None.easeNone, startPoint: 4});
					break;
				case 10: 
					TransitionManager.start(showMC, {type: Wipe, direction: Transition.IN, duration: 2, easing: None.easeNone, startPoint: 5});
					break;
				case 11: 
					TransitionManager.start(showMC, {type: Wipe, direction: Transition.IN, duration: 2, easing: None.easeNone, startPoint: 6});
					break;
				case 12: 
					TransitionManager.start(showMC, {type: Wipe, direction: Transition.IN, duration: 2, easing: None.easeNone, startPoint: 7});
					break;
				case 13: 
					TransitionManager.start(showMC, {type: Wipe, direction: Transition.IN, duration: 2, easing: None.easeNone, startPoint: 8});
					break;
				case 14: 
					TransitionManager.start(showMC, {type: Wipe, direction: Transition.IN, duration: 2, easing: None.easeNone, startPoint: 9});
					break;
				default: 
					TransitionManager.start(showMC, {type: Fade, direction: Transition.IN, duration: 2, easing: None.easeNone});
					break;
			}
		}
	
	}

}