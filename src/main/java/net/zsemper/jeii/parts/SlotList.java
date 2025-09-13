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

public class SlotList extends JSimpleEntriesList<SlotListEntry, RecipeType.SlotListEntry> {
    public SlotList(MCreator mcreator, IHelpContext gui) {
        super(mcreator, gui);
        this.add.setText(L10N.t("elementGui.slots.addSlot", Constants.NO_PARAMS));
        this.setBorder(GuiUtils.BORDER("elementGui.slots.slotList", this));
    }

    @Nullable
    @Override
    protected SlotListEntry newEntry(JPanel parent, List<SlotListEntry> entryList, boolean userAction) {
        return new SlotListEntry(this.mcreator, this.gui, parent, entryList);
    }
}
