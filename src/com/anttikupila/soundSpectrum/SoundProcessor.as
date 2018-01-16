﻿package com.anttikupila.soundSpectrum {	import flash.media.Sound;	import flash.media.SoundMixer;	import flash.utils.ByteArray;		public class SoundProcessor extends Sound {		public const LEFT:String = "left";		public const RIGHT:String = "right";		public const BOTH:String = "both";		private var ba:ByteArray = new ByteArray();				function SoundProcessor() {		}				private function getSection(bArr:ByteArray, sectionLength:uint = 512):Array {			var soundArray:Array = new Array();			for (var i:uint = 0; i < sectionLength; i++) {				soundArray.push(bArr.readFloat());			}			return soundArray;		}				public function getLeftChannel(fourier:Boolean):Array {			SoundMixer.computeSpectrum(ba, fourier, 0);			return getSection(ba, 256);		}				public function getRightChannel(fourier:Boolean):Array {			SoundMixer.computeSpectrum(ba, fourier, 0);			ba.position = 1024;			return getSection(ba, 256);		}				public function getSoundSpectrum(fourier:Boolean):Array {			SoundMixer.computeSpectrum(ba, fourier, 0);			return getSection(ba, 512);		}				public function getVolume(channel:String = BOTH):Number {			SoundMixer.computeSpectrum(ba, false, 0);			var soundArray:Array = new Array();			switch (channel) {				case LEFT:				soundArray = getLeftChannel(true);				break;				case RIGHT:				soundArray = getRightChannel(true);				break;				case BOTH:				default:				soundArray = getSoundSpectrum(true);				break;			}			var vol:Number = 0;			for (var i:int in soundArray) {				vol += soundArray[i];			}			vol /= i;			return vol*100;		}	}}