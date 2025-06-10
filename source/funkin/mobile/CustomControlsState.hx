package funkin.mobile;

#if mobile
import flixel.addons.ui.FlxUIButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import haxe.Json;
import lime.system.Clipboard;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class CustomControlsState extends MusicBeatSubstate {
    var _pad:FlxVirtualPad;
    var _hb:HitBox;

    var exitButton:FlxUIButton;
    var exportButton:FlxUIButton;
    var importButton:FlxUIButton;

    var inputVari:FlxText;
    var upText:FlxText;
    var downText:FlxText;
    var leftText:FlxText;
    var rightText:FlxText;

    var leftArrow:FlxSprite;
    var rightArrow:FlxSprite;
    var controlItems:Array<String> = ['right control', 'left control', 'keyboard', 'custom', 'hitbox'];

    var curSelected:Int = 0;
    var buttonIsTouched:Bool = false;
    var bindButton:FlxButton;
    var config:Config;

    public function new() {
        super();
        config = new Config();
        var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menuBGBlue.png');
        bg.scrollFactor.set(0, 0.18);
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = true;
        add(bg);

        curSelected = config.getcontrolmode();
        _pad = new FlxVirtualPad(RIGHT_FULL, NONE);
        _pad.alpha = 0;
        inputVari = new FlxText(125, 50, 0, controlItems[0], 48);
        _hb = new HitBox();
        _hb.visible = false;

        exitButton = createButton(FlxG.width - 650, 25, 'exit', null);
        exitButton.resize(125, 50);
        var saveButton = createButton(exitButton.x + exitButton.width + 25, 25, 'exit and save', () ->
        {
            save();
            close();
        });
        saveButton.resize(250, 50);
        exportButton = createButton(FlxG.width - 150, 25, 'export', () -> savetoclipboard(_pad));
        exportButton.resize(125, 50);
        importButton = createButton(exportButton.x, 100, 'import', () -> loadfromclipboard(_pad));
        importButton.resize(125, 50);
        for (button in [exitButton, saveButton, exportButton, importButton]) add(button);

        upText = createText(200, 200, 'Button up x:' + _pad.buttonUp.x + ' y:' + _pad.buttonUp.y);
        downText = createText(200, 250, 'Button down x:' + _pad.buttonDown.x + ' y:' + _pad.buttonDown.y);
        leftText = createText(200, 300, 'Button left x:' + _pad.buttonLeft.x + ' y:' + _pad.buttonLeft.y);
        rightText = createText(200, 350, 'Button right x:' + _pad.buttonRight.x + ' y:' + _pad.buttonRight.y);
        for (txt in [upText, downText, leftText, rightText]) add(txt);

        var arrowTex = FlxAtlasFrames.fromSparrow('assets/mobile/arrows.png', 'assets/mobile/arrows.xml');
        leftArrow = createArrow(inputVari.x - 60, inputVari.y - 10, arrowTex, 'arrow left', 'arrow push left');
        rightArrow = createArrow(inputVari.x + inputVari.width + 10, leftArrow.y, arrowTex, 'arrow right', 'arrow push right');
        for (obj in [leftArrow, rightArrow, inputVari, _pad, _hb]) add(obj);

        changeSelection();
    }

    function createButton(x:Float, y:Float, label:String, onClick:Void->Void):FlxUIButton {
        var button = new FlxUIButton(x, y, label, onClick);
        button.setLabelFormat('VCR OSD Mono', 24, FlxColor.BLACK, 'center');
        return button;
    }

    function createText(x:Float, y:Float, text:String):FlxText {
        return new FlxText(x, y, 0, text, 24);
    }

    function createArrow(x:Float, y:Float, frames:FlxAtlasFrames, idlePrefix:String, pressPrefix:String):FlxSprite {
        var arrow = new FlxSprite(x, y);
        arrow.frames = frames;
        arrow.animation.addByPrefix('idle', idlePrefix);
        arrow.animation.addByPrefix('press', pressPrefix);
        arrow.animation.play('idle');
        return arrow;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (exitButton.justReleased #if android || FlxG.android.justReleased.BACK #end) close();
        for (touch in FlxG.touches.list) handleTouch(touch);
    }

    function handleTouch(touch:flixel.input.touch.FlxTouch) {
        if (touch.overlaps(leftArrow) && touch.justPressed) changeSelection(-1);
        else if (touch.overlaps(rightArrow) && touch.justPressed) changeSelection(1);
        arrowAnimate(touch);
        trackButton(touch);
    }

    function changeSelection(change:Int = 0, ?forceChange:Int = null) {
        curSelected = (curSelected + change + controlItems.length) % controlItems.length;
        if (forceChange != null) curSelected = forceChange;

        inputVari.text = controlItems[curSelected];
        _pad.visible = curSelected == 2;
        _hb.visible = false;
        switch (curSelected) {
            case 0: updatePad(RIGHT_FULL, 0.75);
            case 1: updatePad(FULL, 0.75);
            case 2: _pad.alpha = 0;
            case 3: loadCustom(); updatePad(FULL, 0.75);
            case 4: remove(_pad); _hb.visible = true;
        }
    }

    function updatePad(mode, alpha:Float) {
        remove(_pad);
        _pad = new FlxVirtualPad(mode, NONE);
        _pad.alpha = alpha;
        add(_pad);
    }

    function arrowAnimate(touch:flixel.input.touch.FlxTouch) {
        if (touch.overlaps(leftArrow)) leftArrow.animation.play(touch.pressed ? 'press' : 'idle');
        if (touch.overlaps(rightArrow)) rightArrow.animation.play(touch.pressed ? 'press' : 'idle');
    }

    function trackButton(touch:flixel.input.touch.FlxTouch) {
        if (buttonIsTouched) {
            if (bindButton.justReleased && touch.justReleased) {
                bindButton = null;
                buttonIsTouched = false;
            } else {
                moveButton(touch, bindButton);
                setButtonTexts();
            }
        } else {
            if (_pad.buttonUp.justPressed) handleButtonPress(touch, _pad.buttonUp);
            if (_pad.buttonDown.justPressed) handleButtonPress(touch, _pad.buttonDown);
            if (_pad.buttonRight.justPressed) handleButtonPress(touch, _pad.buttonRight);
            if (_pad.buttonLeft.justPressed) handleButtonPress(touch, _pad.buttonLeft);
        }
    }

    function handleButtonPress(touch:flixel.input.touch.FlxTouch, button:FlxButton) {
        if (curSelected != 3) changeSelection(0, 3);
        moveButton(touch, button);
    }

    function moveButton(touch:flixel.input.touch.FlxTouch, button:FlxButton) {
        button.x = touch.x - button.width / 2;
        button.y = touch.y - button.height / 2;
        bindButton = button;
        buttonIsTouched = true;
    }

    function setButtonTexts() {
        upText.text = 'Button up x:' + _pad.buttonUp.x + ' y:' + _pad.buttonUp.y;
        downText.text = 'Button down x:' + _pad.buttonDown.x + ' y:' + _pad.buttonDown.y;
        leftText.text = 'Button left x:' + _pad.buttonLeft.x + ' y:' + _pad.buttonLeft.y;
        rightText.text = 'Button right x:' + _pad.buttonRight.x + ' y:' + _pad.buttonRight.y;
    }

    function save() {
        config.setcontrolmode(curSelected);
        if (curSelected == 3) saveCustom();
    }

    function saveCustom()
        config.savecustom(_pad);

    function loadCustom():Void
        _pad = config.loadcustom(_pad);

    function savetoclipboard(pad:FlxVirtualPad) {
        var json = { buttonsarray: [] };
        for (button in pad) json.buttonsarray.push(FlxPoint .get(button.x, button.y));
        openfl.system.System.setClipboard(Json.stringify(json).trim());
    }

    function loadfromclipboard(pad:FlxVirtualPad):Void {
        if (curSelected != 3) changeSelection(0, 3);
        var cbText:String = Clipboard.text; // this not working on android 10 or higher
        // Wait, really?? ~ Idklool 2025
        if (!cbText.endsWith('}')) return;

        var json = Json.parse(cbText);
        for (i in 0...pad.length) {
            pad.x = json.buttonsarray[i].x;
            pad.y = json.buttonsarray[i].y;
        }
        setButtonTexts();
    }

    override function destroy()
        super.destroy();
}
#end
