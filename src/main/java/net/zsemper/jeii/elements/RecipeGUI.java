package net.zsemper.jeii.elements;

import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.SearchableComboBox;
import net.mcreator.ui.component.util.ComboBoxUtil;
import net.mcreator.ui.component.util.ComponentUtils;
import net.mcreator.ui.component.util.PanelUtils;
import net.mcreator.ui.help.HelpUtils;
import net.mcreator.ui.init.L10N;
import net.mcreator.ui.modgui.ModElementGUI;
import net.mcreator.ui.validation.AggregatedValidationResult;
import net.mcreator.util.ListUtils;
import net.mcreator.workspace.elements.ModElement;
import net.zsemper.jeii.parts.RecipeList;
import net.zsemper.jeii.utils.Constants;
import net.zsemper.jeii.utils.ElementLoader;
import net.zsemper.jeii.utils.GuiUtils;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;
import java.awt.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Collection;
import java.util.Collections;
import java.util.stream.Collectors;

public class RecipeGUI extends ModElementGUI<Recipe> {
    private final SearchableComboBox<String> category;
    private final RecipeList inputs;
    private final RecipeList outputs;

    public RecipeGUI(MCreator mcreator, @NotNull ModElement modElement, boolean editingMode) {
        super(mcreator, modElement, editingMode);

        category = new SearchableComboBox<>();
        inputs = new RecipeList(mcreator, this, "input");
        outputs = new RecipeList(mcreator, this, "output");

        this.initGUI();
        super.finalizeGUI();
    }

    @Override
    protected void initGUI() {
        JLabel categoryLabel = L10N.label("elementGui.customRecipe.recipeType", Constants.NO_PARAMS);

        ComponentUtils.deriveFont(categoryLabel, 16);
        ComponentUtils.deriveFont(category, 16);

        JPanel global = new JPanel(new BorderLayout(2, 2));
        global.setOpaque(false);

        JPanel categoryPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        categoryPanel.setOpaque(false);
        categoryPanel.add(HelpUtils.wrapWithHelpButton(this.withEntry("custom_recipe/recipe_type"), categoryLabel));
        categoryPanel.add(category);

        outputs.setPreferredSize(new Dimension(200, 200));

        JPanel main = new JPanel();
        main.setOpaque(false);
        main.setLayout(new BoxLayout(main, BoxLayout.Y_AXIS));

        main.add(categoryPanel);
        main.add(outputs);

        global.add(PanelUtils.northAndCenterElement(main, inputs));
        global.setBorder(GuiUtils.EMPTY_BORDER(10));

        addPage(global);
    }

    protected AggregatedValidationResult validatePage(int page) {
        return new AggregatedValidationResult.PASS();
    }

    @Override
    public void reloadDataLists() {
        super.reloadDataLists();
        inputs.reloadDataLists();
        outputs.reloadDataLists();
        ComboBoxUtil.updateComboBoxContents(this.category, ListUtils.merge(Collections.singleton("No category"), (Collection)this.mcreator.getWorkspace().getModElements().stream().filter((var) -> {
            return var.getType() == ElementLoader.RECIPE_TYPE;
        }).map(ModElement::getRegistryName).collect(Collectors.toList())), "No category");
    }

    @Override
    protected void openInEditingMode(Recipe element) {
        category.setSelectedItem(element.category);
        inputs.setEntries(element.inputs);
        outputs.setEntries(element.outputs);
    }

    @Override
    public Recipe getElementFromGUI() {
        Recipe element = new Recipe(modElement);

        element.category = category.getSelectedItem();
        element.inputs = inputs.getEntries();
        element.outputs = outputs.getEntries();

        return element;
    }

    @Override
    public @Nullable URI contextURL() throws URISyntaxException {
        return new URI(Constants.WIKI + "recipes");
    }
}
