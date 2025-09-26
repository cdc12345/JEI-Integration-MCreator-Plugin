package net.zsemper.jeii.parts;

import net.mcreator.element.parts.Fluid;
import net.mcreator.minecraft.ElementUtil;
import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.entries.JSimpleListEntry;
import net.mcreator.ui.help.HelpUtils;
import net.mcreator.ui.help.IHelpContext;
import net.mcreator.ui.init.L10N;
import net.mcreator.ui.minecraft.FluidListField;
import net.mcreator.ui.minecraft.MCItemHolder;
import net.mcreator.ui.validation.component.VTextField;
import net.zsemper.jeii.elements.Recipe;
import net.zsemper.jeii.utils.Constants;
import net.zsemper.jeii.utils.GuiUtils;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;

public class RecipeListEntry extends JSimpleListEntry<Recipe.RecipeListEntry> {
    private final JComboBox<String> type = new JComboBox<>(new String[]{"Item", "Fluid", "Logic", "Number", "Text"});
    private final VTextField name = new VTextField();
    private final MCItemHolder itemId;
    private final JSpinner itemAmount = new JSpinner(new SpinnerNumberModel(1, 1, 64, 1));
    private final FluidListField fluidId;
    private final JSpinner fluidAmount = new JSpinner(new SpinnerNumberModel(1, 1, null, 1));
    private final JComboBox<String> logic = new JComboBox<>(new String[]{"true", "false"});
    private final JSpinner number = new JSpinner(new SpinnerNumberModel(0d, null, null, 0.01d));
    private final VTextField text = new VTextField();

    private final JComponent itemComp;
    private final JComponent fluidComp;
    private final JComponent logicComp;
    private final JComponent numberComp;
    private final JComponent textComp;
    private final JComponent amountComp;
    private final JComponent mbComp;

    private final String listType;

    public RecipeListEntry(MCreator mcreator, IHelpContext help, JPanel parent, List<RecipeListEntry> entryList, String listType) {
        super(parent, entryList);
        this.listType = listType;

        boolean enableTags = listType.equals("input");
        itemId = new MCItemHolder(mcreator, ElementUtil::loadBlocksAndItems, enableTags);
        fluidId = new FluidListField(mcreator);

        String io = "";
        if (listType.equals("input")) {
            io = " " + L10N.t("elementGui.rio.input", Constants.NO_PARAMS);
        } else if (listType.equals("output")) {
            io = " " + L10N.t("elementGui.rio.output", Constants.NO_PARAMS);
        }

        itemComp = new JLabel(L10N.t("elementGui.rio.item", Constants.NO_PARAMS) + io + ":");
        fluidComp = new JLabel(L10N.t("elementGui.rio.fluid") + io + ":");
        logicComp = new JLabel(L10N.t("elementGui.rio.logic") + io + ":");
        numberComp = new JLabel(L10N.t("elementGui.rio.number") + io + ":");
        textComp = new JLabel(L10N.t("elementGui.rio.text") + io + ":");
        amountComp = L10N.label("elementGui.rio.amount", Constants.NO_PARAMS);
        mbComp = L10N.label("elementGui.rio.mb", Constants.NO_PARAMS);

        fluidId.setVisible(false);
        fluidAmount.setVisible(false);
        logic.setVisible(false);
        number.setVisible(false);
        text.setVisible(false);

        fluidComp.setVisible(false);
        logicComp.setVisible(false);
        numberComp.setVisible(false);
        textComp.setVisible(false);
        mbComp.setVisible(false);

        type.setPreferredSize(Constants.DIMENSION);
        name.setPreferredSize(Constants.DIMENSION);
        itemId.setPreferredSize(new Dimension(30, Constants.HEIGHT));
        itemAmount.setPreferredSize(Constants.DIMENSION);
        fluidId.setPreferredSize(new Dimension(250, Constants.HEIGHT));
        fluidAmount.setPreferredSize(Constants.DIMENSION);
        logic.setPreferredSize(Constants.DIMENSION);
        number.setPreferredSize(Constants.DIMENSION);
        text.setPreferredSize(Constants.DIMENSION);

        name.getDocument().addDocumentListener(GuiUtils.FORCE_LOWER_CASE(name));

        line.add(HelpUtils.wrapWithHelpButton(help.withEntry("custom_recipe/slot_type"), L10N.label("elementGui.slots.type", Constants.NO_PARAMS)));
        line.add(type);
        line.add(HelpUtils.wrapWithHelpButton(help.withEntry("custom_recipe/slot_name"), L10N.label("elementGui.rio.name", Constants.NO_PARAMS)));
        line.add(name);
        line.add(itemComp);
        line.add(itemId);
        line.add(fluidComp);
        line.add(fluidId);
        line.add(amountComp);
        line.add(itemAmount);
        line.add(fluidAmount);
        line.add(mbComp);
        line.add(logicComp);
        line.add(logic);
        line.add(numberComp);
        line.add(number);
        line.add(textComp);
        line.add(text);

        type.addActionListener(e -> {
            changeType();
        });

        fluidId.addChangeListener(e -> {
            List<Fluid> fluid = new ArrayList<>();
            List<Fluid> oldFluids = fluidId.getListElements();
            if (oldFluids.size() > 1) {
                fluid.add(oldFluids.getLast());
                fluidId.setListElements(fluid);
            }
        });
    }

    @Override
    public void reloadDataLists() {
        super.reloadDataLists();
    }

    @Override
    protected void setEntryEnabled(boolean enabled) {
        type.setEnabled(enabled);
        name.setEnabled(enabled);
        itemId.setEnabled(enabled);
        itemAmount.setEnabled(enabled);
        fluidId.setEnabled(enabled);
        fluidAmount.setEnabled(enabled);
        logic.setEnabled(enabled);
        number.setEnabled(enabled);
        text.setEnabled(enabled);
    }

    @Override
    public Recipe.RecipeListEntry getEntry() {
        Recipe.RecipeListEntry element = new Recipe.RecipeListEntry(listType);

        element.type = (String) type.getSelectedItem();
        element.name = (String) name.getText();

        if (itemId.containsItem()) {
            element.itemId = itemId.getBlock();
        }
        element.itemAmount = (int) itemAmount.getValue();
        if (!fluidId.getListElements().isEmpty()) {
            element.fluidId = fluidId.getListElements().getFirst();
        }
        element.fluidAmount = (int) fluidAmount.getValue();

        element.logic = logic.getSelectedItem().equals("true");
        element.number = (double) number.getValue();
        element.text = text.getText();

        return element;
    }

    @Override
    public void setEntry(Recipe.RecipeListEntry element) {
        type.setSelectedItem(element.type);
        name.setText(element.name);

        if (element.itemId != null) {
            itemId.setBlock(element.itemId);
        }
        itemAmount.setValue(element.itemAmount);
        if (element.fluidId != null) {
            fluidId.setListElements(List.of(element.fluidId));
        }
        fluidAmount.setValue(element.fluidAmount);

        if (element.logic) {
            logic.setSelectedItem("true");
        } else {
            logic.setSelectedItem("false");
        }
        number.setValue(element.number);
        text.setText(element.text);
    }

    private void changeType() {
        hideAll();

        switch ((String) type.getSelectedItem()) {
            case "Item" -> {
                itemId.setVisible(true);
                itemAmount.setVisible(true);
                itemComp.setVisible(true);
                amountComp.setVisible(true);
            }
            case "Fluid" -> {
                fluidId.setVisible(true);
                fluidAmount.setVisible(true);
                fluidComp.setVisible(true);
                amountComp.setVisible(true);
            }
            case "Logic" -> {
                logic.setVisible(true);
                logicComp.setVisible(true);
            }
            case "Number" -> {
                number.setVisible(true);
                numberComp.setVisible(true);
            }
            case "Text" -> {
                text.setVisible(true);
                textComp.setVisible(true);
            }
            case null, default -> hideAll();
        }
    }

    private void hideAll() {
        itemId.setVisible(false);
        itemAmount.setVisible(false);
        fluidId.setVisible(false);
        fluidAmount.setVisible(false);
        logic.setVisible(false);
        number.setVisible(false);
        text.setVisible(false);

        itemComp.setVisible(false);
        fluidComp.setVisible(false);
        logicComp.setVisible(false);
        numberComp.setVisible(false);
        textComp.setVisible(false);
        amountComp.setVisible(false);
        mbComp.setVisible(false);
    }
}
