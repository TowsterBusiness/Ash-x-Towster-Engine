package;

import Paths;
import Character;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import openfl.Lib;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.addons.ui.*;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets;
import haxe.Json;
import haxe.format.JsonParser;

class CharacterState extends MusicBeatState
{   
    var UI_Box:FlxUITabMenu;
	var onScreenCharacter:Character;

	var bgLayer:FlxTypedGroup<FlxSprite>;
	var charLayer:FlxTypedGroup<Character>;

	private var camEditor:FlxCamera;
	private var camHUD:FlxCamera;
	var camFollow:FlxObject;

	public static var character:String;
	var characterFile:CharacterFile;
	
	var characterList:Array<String> = [
		'bf',
		'gf',
	];

	var tipText:FlxText;
	var tipTextList:Array<String> = [
		'E/Q - Camera Zoom In/Out
		\nArrow Keys - Move Character
		\nIJKL - Move Camera',
		'Haha You are on Character',
	];

    override function create () {
		camEditor = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		//Please tell me why this would be FlxG.cameras.reset?
		FlxG.cameras.reset(camEditor);
		FlxG.cameras.add(camHUD);
		FlxCamera.defaultCameras = [camEditor];

		bgLayer = new FlxTypedGroup<FlxSprite>();
		add(bgLayer);
		charLayer = new FlxTypedGroup<Character>();
		add(charLayer);

		//Loading BG
		var bg1:FlxSprite = new FlxSprite(-970, -580).loadGraphic(Paths.image('day/BG1', 'shared'));
		bg1.antialiasing = true;
		bg1.scale.set(0.8, 0.8);
		bg1.scrollFactor.set(0.3, 0.3);
		bg1.active = false;
		bgLayer.add(bg1);

		var bg2:FlxSprite = new FlxSprite(-1240, -650).loadGraphic(Paths.image('day/BG2', 'shared'));
		bg2.antialiasing = true;
		bg2.scale.set(0.5, 0.5);
		bg2.scrollFactor.set(0.6, 0.6);
		bg2.active = false;
		bgLayer.add(bg2);

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);
		FlxG.camera.follow(camFollow);

        var tabs = [
			{name: 'Character', label: 'Character'},
			{name: 'Sprite', label: 'Sprite Offsets'}
		];
		UI_Box = new FlxUITabMenu(null, tabs, true);
		UI_Box.resize(300, 400);
		UI_Box.x = 900;
		UI_Box.y = 20;
		UI_Box.cameras = [camHUD];
		add(UI_Box);

		character = Paths.getPreloadPath('characters/bf.json');
		characterFile = cast Json.parse(Assets.getText(character));
		onScreenCharacter = new Character(characterFile.position[0], characterFile.position[1], characterFile.image, characterFile.flipX, false, true);
		charLayer.add(onScreenCharacter);

		addCharacterUI();

		tipText = new FlxText(FlxG.width - 20, 700, 0, tipTextList[0], 12);
		tipText.setFormat(null, 12, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipText.scrollFactor.set();
		tipText.borderSize = 1;
		tipText.x -= tipText.width;
		tipText.y -= tipText.height;
		tipText.cameras = [camHUD];
		add(tipText);

		super.create();
    }

    override function update (elapsed:Float) {
		//Haha please tell me if there's a better way of doing this ;-;
		if (FlxG.mouse.justReleased) {
			tipText.text = tipTextList[UI_Box.selected_tab];
		}

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L || FlxG.keys.pressed.UP || FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.DOWN)
		{
			var change:Int = FlxG.keys.pressed.SHIFT ? 10 : 1;
			if (FlxG.keys.pressed.I)
				camFollow.y -= change;
			else if (FlxG.keys.pressed.K)
				camFollow.y += change;

			if (FlxG.keys.pressed.J)
				camFollow.x -= change;
			else if (FlxG.keys.pressed.L)
				camFollow.x += change;

			if (FlxG.keys.justPressed.LEFT)
				onScreenCharacter.x -= change;
			else if (FlxG.keys.justPressed.RIGHT)
				onScreenCharacter.x += change;
	
			if (FlxG.keys.justPressed.UP) 
				onScreenCharacter.y -= change;
			else if (FlxG.keys.justPressed.DOWN)
				onScreenCharacter.y += change;
		}

		if (FlxG.keys.justReleased.I || FlxG.keys.justReleased.J || FlxG.keys.justReleased.K || FlxG.keys.justReleased.L || FlxG.keys.justReleased.UP || FlxG.keys.justReleased.LEFT || FlxG.keys.justReleased.RIGHT || FlxG.keys.justReleased.DOWN) 
		{
			characterFile.position[0] = onScreenCharacter.x;
			characterFile.position[1] = onScreenCharacter.y;
			characterFile.cameraPosition[0] = camFollow.x;
			characterFile.cameraPosition[1] = camFollow.y;
		}

		super.update(elapsed);
    }


	function addCharacterUI () {
		var Character_Text = new FlxUIText(10, 20, 300, 'Character:');
		var Character_DropDown = new FlxUIDropDownMenu(10, 40, FlxUIDropDownMenu.makeStrIdLabelArray(characterList, true));

		var NewCharacter_Text = new FlxUIText(10, 60, 300, 'New/Update Character:');
		var NewCharacter_TextBox = new FlxUIInputText(10, 80, 'bf');
		NewCharacter_TextBox.callback = function(text:String, input:String) {

		}

		var HealthIcon_Text = new FlxUIText(10, 100, 300, 'Health Stuff:');
		var HealthIcon_TextBox = new FlxUIInputText(10, 120, 'bf');
		HealthIcon_TextBox.callback = function(text:String, input:String) {
			characterFile.healthicon = text;
		}

		var HeathIcon_R = new FlxUINumericStepper(10, 140, 1, characterFile.healthbarColors[0], 0, 255, 0);
		var HeathIcon_G = new FlxUINumericStepper(75, 140, 1, characterFile.healthbarColors[1], 0, 255, 0);
		var HeathIcon_B = new FlxUINumericStepper(140, 140, 1, characterFile.healthbarColors[2], 0, 255, 0);

		var Path_Text = new FlxUIText(10, 200, 'Path:');
		var Path_TextBox = new FlxUIInputText(10, 220, 'BOYFRIEND');
		Path_TextBox.callback = function(text:String, input:String) {
			characterFile.image = 'characters/' + text;
		}

		var Update_Button = new FlxUIButton(10, 340, 'Update', function() {
			updateSprites();
		});

		//adding all variables into the group
		var tab_group_character = new FlxUI(null, UI_Box);
		tab_group_character.name = "Character";

		tab_group_character.add(Update_Button);
		tab_group_character.add(HeathIcon_G);
		tab_group_character.add(HeathIcon_B);
		tab_group_character.add(HeathIcon_R);
		tab_group_character.add(HealthIcon_TextBox);
		tab_group_character.add(HealthIcon_Text);
		tab_group_character.add(Path_TextBox);
		tab_group_character.add(Path_Text);
		tab_group_character.add(NewCharacter_TextBox);
		tab_group_character.add(NewCharacter_Text);
		tab_group_character.add(Character_DropDown);
		tab_group_character.add(Character_Text);

		UI_Box.addGroup(tab_group_character);
	}

	var updateSprites = function () {
	}
}