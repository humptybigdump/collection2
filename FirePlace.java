package model.buildings;

import java.util.Arrays;
import java.util.List;

import model.ECard;
import model.Player;

public class FirePlace extends Building {

	public FirePlace() {
		super(EBuilding.FIREPLACE);
	}

	@Override
	public List<ECard> getResourceCosts() {
		return Arrays.asList(ECard.WOOD, ECard.WOOD, ECard.WOOD, ECard.METAL);
	}

	@Override
	public void onBuild(Player p) {
		// give bonus of fireplace
	}
}
