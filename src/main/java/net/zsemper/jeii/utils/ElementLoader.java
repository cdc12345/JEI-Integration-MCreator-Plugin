package net.zsemper.jeii.utils;

import net.mcreator.element.ModElementType;
import net.zsemper.jeii.elements.*;

import static net.mcreator.element.ModElementTypeLoader.register;

public class ElementLoader {

    public static ModElementType<?> INFORMATION;
    public static ModElementType<?> RECIPE_TYPE;
    public static ModElementType<?> RECIPE;

    public static void load() {
        INFORMATION = register(
            new ModElementType<>("information", 'I', InformationGUI::new, Information.class)
        );

        RECIPE_TYPE = register(
                new ModElementType<>("recipe_type", 'R', RecipeTypeGUI::new, RecipeType.class)
        );

        RECIPE = register(
                new ModElementType<>("custom_recipe", 'C', RecipeGUI::new, Recipe.class)
        );
    }
}
