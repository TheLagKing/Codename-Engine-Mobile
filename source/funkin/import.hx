#if !macro
import funkin.backend.system.Main;
import funkin.backend.assets.Paths;
import funkin.backend.MusicBeatState;
import funkin.backend.MusicBeatSubstate;
import funkin.backend.MusicBeatGroup;
import funkin.backend.FunkinSprite;
import funkin.backend.utils.*;
import funkin.backend.utils.TranslationUtil as TU;
import funkin.backend.system.Logs;
import funkin.options.Options;
import funkin.game.PlayState;
import funkin.backend.scripting.EventManager;

import openfl.utils.Assets;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.sound.FlxSound;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

import funkin.backend.system.Flags;
import funkin.Types;

import funkin.mobile.backend.SUtil;

#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.Tools as AndroidTools;
import android.os.Build.VERSION as AndroidVersion;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
import android.os.BatteryManager as AndroidBatteryManager;
#end

import funkin.menus.ui.Alphabet;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

using StringTools;
using funkin.backend.utils.CoolUtil;
#end