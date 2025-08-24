package funkin.mobile.utils;

#if android
import extension.androidtools.os.Build.VERSION;
import extension.androidtools.os.Environment;
import extension.androidtools.Permissions;
import extension.androidtools.Settings;

import lime.system.System;
import lime.app.Application;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

/** 
* @author MaysLastPlay, MarioMaster (MasterX-39)
* @version: 0.2.2
**/

class MobileUtil {
  public static var currentDirectory:String = null;

  /**
   * Get the directory for the application. (External for Android Platform and Internal for iOS Platform.)
   */

  public static function getDirectory():String {
  return '/storage/emulated/0/.CodenameEngine/';
  }

  /**
   * Requests Storage Permissions on Android Platform.
   */
  
    public static function getPermissions():Void
    {
    if(VERSION.SDK_INT >= 33){
	   if (!Environment.isExternalStorageManager()) {
	     Settings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');
	   }
      } else {
      Permissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);
	  }

    try {
      if(!FileSystem.exists(MobileUtil.getDirectory()))
        FileSystem.createDirectory(MobileUtil.getDirectory());
     } catch (e:Dynamic) {
    trace(e);
  if(!FileSystem.exists(MobileUtil.getDirectory())) {
    NativeAPI.showMessageBox("Seems like you didnt enabled permissions requested to run the game.", 'Uncaught Error');
    FileSystem.createDirectory(MobileUtil.getDirectory());
     System.exit(0);
     }
    }
  }

  /**
   * Saves a file to the external storage.
   */

	public static function save(fileName:String = 'Ye', fileExt:String = '.txt', fileData:String = 'Nice try, but you failed, try again!')
	{
	  var savesDir:String = MobileUtil.getDirectory() + 'saves/';

		if (!FileSystem.exists(savesDir))
			FileSystem.createDirectory(savesDir);

		File.saveContent(savesDir + fileName + fileExt, fileData);
	}
}
#end
