package net.zsemper.jeii.parts;

import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.entries.JSimpleEntriesList;
import net.mcreator.ui.help.IHelpContext;
import net.mcreator.ui.init.L10N;
import net.zsemper.jeii.elements.RecipeType;
import net.zsemper.jeii.utils.Constants;
import net.zsemper.jeii.utils.GuiUtils;

import javax.annotation.Nullable;
import javax.swing.*;
import java.util.List;

public class ClickList extends JSimpleEntriesList<ClickListEntry, RecipeType.ClickListEntry> {
    public ClickList(MCreator mcreator, IHelpContext gui) {
        super(mcreator, gui);
        this.add.setText(L10N.t("elementGui.click.addClickArea", Constants.NO_PARAMS));
        this.setBorder(GuiUtils.BORDER("elementGui.click.clickList", this));
    }

    @Nullable
    @Override
    protected ClickListEntry newEntry(JPanel parent, List<ClickListEntry> entryList, boolean userAction) {
        return new ClickListEntry(this.mcreator, this.gui, parent, entryList);
    }
}
