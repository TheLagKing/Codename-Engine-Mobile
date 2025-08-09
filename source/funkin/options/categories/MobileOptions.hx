package funkin.options.categories;

class AppearanceOptions extends OptionsScreen {
	public override function new() {
		super("Mobile Options", "Change Mobile Options. Only on mobile...");
		add(new Checkbox(
			"Hitbox Visibility",
			"Makes the hitbox invisible",
  }
    #if mobile
	 MusicBeatState.instance.addVPad(FULL, A_B);
	 MusicBeatState.instance.addVPadCamera();
	 #end
	}
