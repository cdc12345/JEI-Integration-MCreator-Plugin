package net.zsemper.jeii.parts;

import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.entries.JSimpleEntriesList;
import net.mcreator.ui.help.IHelpContext;
import net.mcreator.ui.init.L10N;
import net.zsemper.jeii.elements.Recipe;
import net.zsemper.jeii.utils.Constants;
import net.zsemper.jeii.utils.GuiUtils;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;
import java.util.List;

public class RecipeList extends JSimpleEntriesList<RecipeListEntry, Recipe.RecipeListEntry> {
    private final String listType;

    public RecipeList(MCreator mcreator, IHelpContext gui, String listType) {
        super(mcreator, gui);
        this.listType = listType;

        String io = "";
        if (listType.equals("input")) {
            io = " " + L10N.t("elementGui.rio.input", Constants.NO_PARAMS);
        } else if (listType.equals("output")) {
            io = " " + L10N.t("elementGui.rio.output", Constants.NO_PARAMS);
        }

        add.setText(L10N.t("elementGui.rio.addRio", Constants.NO_PARAMS) + io);
        this.setBorder(GuiUtils.BORDER("elementGui.rio.list_" + listType, this));
    }

    @Override
    protected @Nullable RecipeListEntry newEntry(JPanel parent, List<RecipeListEntry> entryList, boolean userAction) {
        return new RecipeListEntry(this.mcreator, this.gui, parent, entryList, listType);
    }
}
