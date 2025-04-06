package funkin.mobile.utils;

import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import openfl.events.UncaughtErrorEvent;
import openfl.utils.Assets as OpenFlAssets;
import openfl.Lib;
import openfl.system.System;
import flixel.FlxG;
import lime.app.Application;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class MobileCrashHandler {

	public static function checkUncaughtError()
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
	}

	public static function onUncaughtError(e:UncaughtErrorEvent):Void
	{
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();
		dateNow = StringTools.replace(dateNow, " ", "_");
		dateNow = StringTools.replace(dateNow, ":", "'");

		var path:String = "crash/" + "Crash_" + dateNow + ".txt";
		var errMsg:String = "";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += e.error;

   #if sys
		if (!FileSystem.exists(Sys.getCwd() + "crash"))
		FileSystem.createDirectory(Sys.getCwd() + "crash");

		File.saveContent(Sys.getCwd() + path, errMsg + "\n");
		#end

		Application.current.window.alert("Uncaught Error!", errMsg);
		System.exit(0);
	}
}