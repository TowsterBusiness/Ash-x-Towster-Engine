package;

import Paths;
import Character;
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

	public static var character:String;
	var characterFile:CharacterFile;
	
	var characterList:Array<String> = [
		'bf',
		'gf',
	];

    override function create () {

        var tabs = [
			{name: 'Character', label: 'Character'},
			{name: 'Sprite', label: 'Sprite Offsets'}
		];

		UI_Box = new FlxUITabMenu(null, tabs, true);
		UI_Box.resize(300, 400);
		UI_Box.x = 700;
		UI_Box.y = 20;
		add(UI_Box);

		character = Paths.getPreloadPath('characters/bf.json');

		characterFile = cast Json.parse(Assets.getText(character));

		onScreenCharacter = new Character(characterFile.position[0], characterFile.position[1], characterFile.image, characterFile.flipX, false, true);
		add(onScreenCharacter);

		addCharacterUI();

		super.create();
    }

    override function update (elapsed:Float) {

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
		var HeathIcon_R = new FlxUIInputText(10, 140, '49');
		HeathIcon_R.callback = function(text:String, input:String) {
			characterFile.healthbarColors[0] = Std.parseInt(text);
		}
		var HeathIcon_B = new FlxUIInputText(10, 160, '176');
		HeathIcon_R.callback = function(text:String, input:String) {
			characterFile.healthbarColors[1] = Std.parseInt(text);
		}
		var HeathIcon_G = new FlxUIInputText(10, 180, '209');
		HeathIcon_R.callback = function(text:String, input:String) {
			characterFile.healthbarColors[3] = Std.parseInt(text);
		}

		var Path_Text = new FlxUIText(10, 200, 'Path:');
		var Path_TextBox = new FlxUIInputText(10, 220, 'BOYFRIEND');
		Path_TextBox.callback = function(text:String, input:String) {
			characterFile.image = 'characters/' + text;
		}

		var PositionsX_Text = new FlxUIText(10, 240, 'x: ');
		var PositionsX_TextBox = new FlxUIInputText(10, 260, '0');
		PositionsX_TextBox.callback = function(text:String, input:String) {
			characterFile.position[0] = Std.parseInt(text);
			onScreenCharacter.x = Std.parseInt(text);
		}

		var PositionsY_Text = new FlxUIText(10, 280, 'y: ');
		var PositionsY_TextBox = new FlxUIInputText(10, 300, '0');
		PositionsY_TextBox.callback = function(text:String, input:String) {
			characterFile.position[1] = Std.parseInt(text);
			onScreenCharacter.y = Std.parseInt(text);
		}

		var Update_Button = new FlxUIButton(10, 340, 'Update', function() {
			updateSprites();
		});

		

		//adding all variables into the group
		var tab_group_character = new FlxUI(null, UI_Box);
		tab_group_character.name = "Character";

		tab_group_character.add(Update_Button);
		tab_group_character.add(PositionsY_TextBox);
		tab_group_character.add(PositionsY_Text);
		tab_group_character.add(PositionsX_TextBox);
		tab_group_character.add(PositionsX_Text);
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