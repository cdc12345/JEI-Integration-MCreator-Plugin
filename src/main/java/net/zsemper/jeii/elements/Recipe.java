package net.zsemper.jeii.elements;

import net.mcreator.element.GeneratableElement;
import net.mcreator.element.parts.Fluid;
import net.mcreator.element.parts.MItemBlock;
import net.mcreator.workspace.elements.ModElement;
import net.mcreator.workspace.references.ModElementReference;

import java.util.List;

public class Recipe extends GeneratableElement {
    public String category;
    public List<RecipeListEntry> inputs;
    public List<RecipeListEntry> outputs;

    public static class RecipeListEntry {
        public RecipeListEntry(String listType) {}

        public String type;
        public String name;
        // Item
        @ModElementReference
        public MItemBlock itemId;
        public int itemAmount;
        // Fluid
        @ModElementReference
        public Fluid fluidId;
        public int fluidAmount;
        // Boolean
        public boolean logic;
        // Number
        public double number;
        // Text
        public String text;
    }

    public Recipe(ModElement element) {
        super(element);
    }


}
