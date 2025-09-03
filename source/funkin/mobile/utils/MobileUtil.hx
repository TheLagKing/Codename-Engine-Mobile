package funkin.mobile.utils;

#if android
import extension.androidtools.os.Build.VERSION;
import extension.androidtools.os.Environment;
import extension.androidtools.Permissions;
import extension.androidtools.Settings;
#end

import lime.system.System;
import lime.app.Application;
import openfl.Assets;
import haxe.io.Bytes;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

/** 
* @Authors MaysLastPlay, MarioMaster (MasterX-39), Dechis (dx7405)
* @version: 0.3.0
**/

class MobileUtil {
  public static var currentDirectory:String = null;
  private static var useAlternativePath:Bool = false;

  /**
   * Get the directory for the application. (External for Android Platform and Internal for iOS Platform.)
   * Now with automatic fallback to Android/media path if permissions fail.
   */
  public static function getDirectory():String {
    #if android
    var preferredPath = "/storage/emulated/0/.CodenameEngineLegacy/";
    var fallbackPath = "/storage/emulated/0/Android/media/com.yoshman29.codenameenginelegacy/";

    if (useAlternativePath) return fallbackPath;

    try {
        if (!FileSystem.exists(preferredPath)) {
            FileSystem.createDirectory(preferredPath);
        }
		
        var testFile = preferredPath + ".permission_test";
        File.saveContent(testFile, "test");
        FileSystem.deleteFile(testFile);

        return preferredPath;

    } catch (e:Dynamic) {
        useAlternativePath = true;
        return fallbackPath;
    }

    #elseif ios
    return System.documentsDirectory;
    #else
    return "";
    #end
}

  /**
   * Requests Storage Permissions on Android Platform.
   */
  public static function getPermissions():Void {
    try {
        #if android
        if (VERSION.SDK_INT >= 30) {
            if (!Environment.isExternalStorageManager()) {
                Settings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');
            }
        }
        else if (VERSION.SDK_INT == 29) {
            try {
                if (!Environment.isExternalStorageManager()) {
                    Settings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');
                }
            } catch (e1:Dynamic) {
                trace('Fallback 1 failed: $e1');
            }

            try {
                Permissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);
            } catch (e2:Dynamic) {
                trace('Fallback 2 failed: $e2');
            }

            try {
                if (!FileSystem.exists(MobileUtil.getDirectory())) {
                    FileSystem.createDirectory(MobileUtil.getDirectory());
                }
            } catch (e3:Dynamic) {
                trace('Fallback 3 failed: $e3');
            }
        }
        else {
            Permissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);
        }
        #end

        var targetDir = MobileUtil.getDirectory();
        if (!FileSystem.exists(targetDir)) {
            try {
                FileSystem.createDirectory(targetDir);
                trace('Successfully created directory: $targetDir');
            } catch (e:Dynamic) {
                trace('Failed to create directory $targetDir: $e');
            }
        }
    } catch (e:Dynamic) {
        trace('Error on creating directory: $e');
        var finalDir = MobileUtil.getDirectory();
        if (!FileSystem.exists(finalDir)) {
            try {
                FileSystem.createDirectory(finalDir);
            } catch (e2:Dynamic) {
                NativeAPI.showMessageBox(
                    'Uncaught Error',
                    "It seems you did not enable the required permissions to run the game. " +
                    "Please enable them and add files to ${finalDir}. Press OK to close the game."
                );
                System.exit(0);
            }
        }
    }
  }

  /**
   * Saves a file to the external storage.
   */
  public static function save(fileName:String = 'Ye', fileExt:String = '.txt', fileData:String = 'Nice try, but you failed, try again!') {
    var savesDir:String = MobileUtil.getDirectory() + 'saves/';

    if (!FileSystem.exists(savesDir))
      FileSystem.createDirectory(savesDir);

    File.saveContent(savesDir + fileName + fileExt, fileData);
  }

  /**
   * Copies recursively the assets folder from the APK to external directory
   * @param sourcePath Path to the assets folder inside APK (usually "assets/")
   * @param targetPath Destination path (optional, uses getDirectory() + "assets/" if not specified)
   */
  public static function copyAssetsFromAPK(sourcePath:String = "assets/", targetPath:String = null):Void {
    #if mobile
    if (targetPath == null) {
        targetPath = getDirectory() + "assets/";
    }
    
    try {
        if (!FileSystem.exists(targetPath)) {
            FileSystem.createDirectory(targetPath);
        }

        copyAssetsRecursively(sourcePath, targetPath);
        
        trace('Assets successfully copied to: $targetPath');
    } catch (e:Dynamic) {
        trace('Error copying assets: $e');
        NativeAPI.showMessageBox('Error', 'Error copying game files. Check storage permissions or re-open the game to see what happens.');
    }
    #end
  }

  public static function copyModsFromAPK(sourcePath:String = "mods/", targetPath:String = null):Void {
    #if mobile
    if (targetPath == null) {
        targetPath = getDirectory() + "mods/";
    }
    
    try {
        if (!FileSystem.exists(targetPath)) {
            FileSystem.createDirectory(targetPath);
        }

        copyAssetsRecursively(sourcePath, targetPath);
        
        trace('Mods successfully copied to: $targetPath');
    } catch (e:Dynamic) {
        trace('Error copying mods: $e');
        NativeAPI.showMessageBox('Error', 'Error copying game files. Check storage permissions or re-open the game to see what happens.');
    }
    #end
	}

  /**
   * Helper function to copy assets recursively
   */
  private static function copyAssetsRecursively(sourcePath:String, targetPath:String):Void {
    #if mobile
    try {
        var cleanSourcePath = sourcePath;
        if (StringTools.endsWith(cleanSourcePath, "/")) {
            cleanSourcePath = cleanSourcePath.substring(0, cleanSourcePath.length - 1);
        }
        
        var assetList:Array<String> = Assets.list();
        
        for (assetPath in assetList) {
            if (StringTools.startsWith(assetPath, cleanSourcePath)) {
                var relativePath = assetPath;
                
                if (StringTools.startsWith(relativePath, "assets/")) {
                    relativePath = relativePath.substring(7);
                }
                
                if (relativePath == "") continue;
                
                var fullTargetPath = targetPath + relativePath;
                
                var targetDir = haxe.io.Path.directory(fullTargetPath);
                if (targetDir != "" && !FileSystem.exists(targetDir)) {
                    createDirectoryRecursive(targetDir);
                }
                
                try {
                    if (Assets.exists(assetPath)) {
                        var fileData:Bytes = Assets.getBytes(assetPath);
                        if (fileData != null) {
                            File.saveBytes(fullTargetPath, fileData);
                            trace('Copied: $assetPath -> $fullTargetPath');
                        } else {
                            var textData = Assets.getText(assetPath);
                            if (textData != null) {
                                File.saveContent(fullTargetPath, textData);
                                trace('Copied (text): $assetPath -> $fullTargetPath');
                            }
                        }
                    }
                } catch (e:Dynamic) {
                    trace('Error copying file $assetPath: $e');
                }
            }
        }
    } catch (e:Dynamic) {
        trace('Error in recursive copy: $e');
        throw e;
    }
    #end
  }

  /**
   * Creates directories recursively
   */
  private static function createDirectoryRecursive(path:String):Void {
    #if mobile
    if (FileSystem.exists(path)) return;
    
    var pathParts = path.split("/");
    var currentPath = "";
    
    for (part in pathParts) {
        if (part == "") continue;
        currentPath += "/" + part;
        
        if (!FileSystem.exists(currentPath)) {
            try {
                FileSystem.createDirectory(currentPath);
            } catch (e:Dynamic) {
                trace('Error creating directory $currentPath: $e');
            }
        }
    }
    #end
  }

  /**
   * Copies assets with progress (advanced version)
   * @param sourcePath Path to assets folder inside APK
   * @param targetPath Destination path
   * @param onProgress Optional callback for progress (current file, current count, total files)
   * @param onComplete Optional callback when finished
   */
  public static function copyAssetsWithProgress(sourcePath:String = "assets/", targetPath:String = null, 
                                              onProgress:String->Int->Int->Void = null, onComplete:Void->Void = null):Void {
    #if mobile
    if (targetPath == null) {
        targetPath = getDirectory() + "assets/";
    }
    
    try {
        if (!FileSystem.exists(targetPath)) {
            FileSystem.createDirectory(targetPath);
        }
        
        var totalFiles = countAssetsFiles(sourcePath);
        var currentFile = 0;
        
        trace('Starting copy of $totalFiles files...');
        
        var cleanSourcePath = sourcePath;
        if (StringTools.endsWith(cleanSourcePath, "/")) {
            cleanSourcePath = cleanSourcePath.substring(0, cleanSourcePath.length - 1);
        }
        
        var assetList:Array<String> = Assets.list();
        
        for (assetPath in assetList) {
            if (StringTools.startsWith(assetPath, cleanSourcePath)) {
                var relativePath = assetPath;
                
                if (StringTools.startsWith(relativePath, "assets/")) {
                    relativePath = relativePath.substring(7);
                }
                
                if (relativePath == "") continue;
                
                var fullTargetPath = targetPath + relativePath;
                
                var targetDir = haxe.io.Path.directory(fullTargetPath);
                if (targetDir != "" && !FileSystem.exists(targetDir)) {
                    createDirectoryRecursive(targetDir);
                }
                
                try {
                    if (Assets.exists(assetPath)) {
                        var fileData:Bytes = Assets.getBytes(assetPath);
                        if (fileData != null) {
                            File.saveBytes(fullTargetPath, fileData);
                        } else {
                            var textData = Assets.getText(assetPath);
                            if (textData != null) {
                                File.saveContent(fullTargetPath, textData);
                            }
                        }
                        
                        currentFile++;
                        
                        if (onProgress != null) {
                            onProgress(relativePath, currentFile, totalFiles);
                        }
                        
                        trace('[$currentFile/$totalFiles] Copied: $relativePath');
                    }
                    
                } catch (e:Dynamic) {
                    trace('Error copying $assetPath: $e');
                }
            }
        }
        
        trace('Copy completed! $currentFile files copied.');
        
        if (onComplete != null) {
            onComplete();
        }
        
    } catch (e:Dynamic) {
        trace('Error copying assets: $e');
        NativeAPI.showMessageBox('Error', 'Error copying game files. Check storage permissions or re-open the game to see what happens.');
    }
    #end
  }

  /**
   * Counts total number of asset files for progress
   */
  private static function countAssetsFiles(sourcePath:String):Int {
    #if mobile
    var count = 0;
    var cleanSourcePath = sourcePath;
    if (StringTools.endsWith(cleanSourcePath, "/")) {
        cleanSourcePath = cleanSourcePath.substring(0, cleanSourcePath.length - 1);
    }
    var assetList:Array<String> = Assets.list();
    
    for (assetPath in assetList) {
        if (StringTools.startsWith(assetPath, cleanSourcePath)) {
            var relativePath = assetPath;
            
            if (StringTools.startsWith(relativePath, "assets/")) {
                relativePath = relativePath.substring(7);
            }
            
            if (relativePath != "") {
                count++;
            }
        }
    }
    
    return count;
    #else
    return 0;
    #end
  }

  /**
   * Checks if assets have already been copied
   */
  public static function areAssetsCopied(sourcePath:String = "assets/", targetPath:String = null):Bool {
    #if mobile
    if (targetPath == null) {
        targetPath = getDirectory() + "assets/";
    }
    
    if (!FileSystem.exists(targetPath)) {
        return false;
    }
    
    var sourceCount = countAssetsFiles(sourcePath);
    var targetCount = countFilesInDirectory(targetPath);
    
    return sourceCount > 0 && sourceCount == targetCount;
    #else
    return false;
    #end
  }

  public static function areModsCopied(sourcePath:String = "mods/", targetPath:String = null):Bool {
    #if mobile
    if (targetPath == null) {
        targetPath = getDirectory() + "mods/";
    }
    
    if (!FileSystem.exists(targetPath)) {
        return false;
    }
    
    var sourceCount = countAssetsFiles(sourcePath);
    var targetCount = countFilesInDirectory(targetPath);
    
    return sourceCount > 0 && sourceCount == targetCount;
    #else
    return false;
    #end
  }

  /**
   * Counts files in a directory recursively
   */
  private static function countFilesInDirectory(path:String):Int {
    #if mobile
    if (!FileSystem.exists(path)) return 0;
    
    var count = 0;
    var items = FileSystem.readDirectory(path);
    
    for (item in items) {
        var fullPath = path + "/" + item;
        if (FileSystem.isDirectory(fullPath)) {
            count += countFilesInDirectory(fullPath);
        } else {
            count++;
        }
    }
    
    return count;
    #else
    return 0;
    #end
  }
}
