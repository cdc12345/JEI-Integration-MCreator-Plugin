package net.zsemper.jeii.parts;

import net.mcreator.element.ModElementType;
import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.entries.JSimpleListEntry;
import net.mcreator.ui.help.IHelpContext;
import net.mcreator.ui.minecraft.SingleModElementSelector;
import net.zsemper.jeii.elements.RecipeType;
import net.zsemper.jeii.utils.Constants;

import javax.swing.*;
import java.awt.*;
import java.util.List;

public class ClickListEntry extends JSimpleListEntry<RecipeType.ClickListEntry> {
    private final SingleModElementSelector clickGui;
    private final JSpinner clickX = new JSpinner(new SpinnerNumberModel(0, 0, 1000, 1));
    private final JSpinner clickY = new JSpinner(new SpinnerNumberModel(0, 0, 1000, 1));
    private final JSpinner clickWidth = new JSpinner(new SpinnerNumberModel(0, 0, 1000, 1));
    private final JSpinner clickHeight = new JSpinner(new SpinnerNumberModel(0, 0, 1000, 1));

    public ClickListEntry(MCreator mcreator, IHelpContext help, JPanel parent, List<ClickListEntry> entryList) {
        super(parent, entryList);
        clickGui = new SingleModElementSelector(mcreator, ModElementType.GUI);

        clickGui.setPreferredSize(new Dimension(Constants.WIDTH, Constants.HEIGHT));
        clickX.setPreferredSize(Constants.DIMENSION);
        clickY.setPreferredSize(Constants.DIMENSION);
        clickWidth.setPreferredSize(Constants.DIMENSION);
        clickHeight.setPreferredSize(Constants.DIMENSION);

        line.add(new JLabel("GUI:"));
        line.add(clickGui);
        line.add(new JLabel(Constants.Translatable.X));
        line.add(clickX);
        line.add(new JLabel(Constants.Translatable.Y));
        line.add(clickY);
        line.add(new JLabel(Constants.Translatable.WIDTH));
        line.add(clickWidth);
        line.add(new JLabel(Constants.Translatable.HEIGHT));
        line.add(clickHeight);
    }

    @Override
    public void reloadDataLists() {
        super.reloadDataLists();
    }

    @Override
    protected void setEntryEnabled(boolean enabled) {
        clickGui.setEnabled(enabled);
        clickX.setEnabled(enabled);
        clickY.setEnabled(enabled);
        clickWidth.setEnabled(enabled);
        clickHeight.setEnabled(enabled);
    }

    @Override
    public RecipeType.ClickListEntry getEntry() {
        RecipeType.ClickListEntry entry = new RecipeType.ClickListEntry();
        entry.clickGui = clickGui.getEntry();
        entry.clickX = (int) clickX.getValue();
        entry.clickY = (int) clickY.getValue();
        entry.clickWidth = (int) clickWidth.getValue();
        entry.clickHeight = (int) clickHeight.getValue();
        return entry;
    }

    @Override
    public void setEntry(RecipeType.ClickListEntry entry) {
        clickGui.setEntry(entry.clickGui);
        clickX.setValue(entry.clickX);
        clickY.setValue(entry.clickY);
        clickWidth.setValue(entry.clickWidth);
        clickHeight.setValue(entry.clickHeight);
    }
}
