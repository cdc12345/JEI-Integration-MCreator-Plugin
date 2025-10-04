package net.zsemper.jeii.parts;

import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.entries.JSimpleListEntry;
import net.mcreator.ui.component.util.ComponentUtils;
import net.mcreator.ui.dialogs.TypedTextureSelectorDialog;
import net.mcreator.ui.help.HelpUtils;
import net.mcreator.ui.help.IHelpContext;
import net.mcreator.ui.init.L10N;
import net.mcreator.ui.minecraft.TextureSelectionButton;
import net.mcreator.ui.validation.component.VTextField;
import net.mcreator.ui.workspace.resources.TextureType;
import net.zsemper.jeii.elements.RecipeType;
import net.zsemper.jeii.utils.Constants;
import net.zsemper.jeii.utils.GuiUtils;
import org.fife.ui.rtextarea.FontUtil;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;
import java.awt.*;
import java.util.List;
import java.util.Objects;

public class SlotListEntry extends JSimpleListEntry<RecipeType.SlotListEntry> {
    private final JComboBox<String> io = new JComboBox<>();
    private final JComboBox<String> type = new JComboBox<>(new String[]{"Item", "Fluid","Logic", "Number", "Text"});
    private final VTextField name = new VTextField();
    private final JSpinner x = new JSpinner(new SpinnerNumberModel(0, 0, 1000, 1));
    private final JSpinner y = new JSpinner(new SpinnerNumberModel(0, 0, 1000, 1));
    private final JCheckBox single = new JCheckBox();
    private final JSpinner height = new JSpinner(new SpinnerNumberModel(16, 1, 1000, 1));
    private final JCheckBox fullTank = new JCheckBox();
    private final JSpinner tankCapacity = new JSpinner(new SpinnerNumberModel(1, 1, null, 1));
    private final JCheckBox optional = new JCheckBox();
    private final JComboBox<String> defaultBoolean = new JComboBox<>(new String[]{"true", "false"});
    private final JSpinner defaultDouble = new JSpinner(new SpinnerNumberModel(0d, null, null, 0.01d));
    private final VTextField defaultString = new VTextField();
    private final TextureSelectionButton resource;
    private final JTextField custom = new JTextField();

    private final JComponent nameComp;
    private final JComponent typeComp;
    private final JComponent xComp;
    private final JComponent yComp;
    private final JComponent singleComp;
    private final JComponent heightComp;
    private final JComponent fullTankComp;
    private final JComponent tankCapacityComp;
    private final JComponent optionalComp;
    private final JComponent defaultComp;
    private final JComponent resourceComp;
    private final JComponent customComp;

    public SlotListEntry(MCreator mcreator, IHelpContext help, JPanel parent, List<SlotListEntry> entryList) {
        super(parent, entryList);

        nameComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/slot_name"), L10N.label("elementGui.slots.name", Constants.NO_PARAMS));
        typeComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/slot_type"), L10N.label("elementGui.slots.type", Constants.NO_PARAMS));
        xComp = new JLabel(Constants.Translatable.X);
        yComp = new JLabel(Constants.Translatable.Y);
        singleComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/single_item"), L10N.label("elementGui.slots.single", Constants.NO_PARAMS));
        heightComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/tank_height"), new JLabel(Constants.Translatable.HEIGHT));
        fullTankComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/full_tank"), L10N.label("elementGui.slots.tank", Constants.NO_PARAMS));
        tankCapacityComp = L10N.label("elementGui.slots.tankCapacity", Constants.NO_PARAMS);
        optionalComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/optional"), L10N.label("elementGui.slots.optional", Constants.NO_PARAMS));
        defaultComp = L10N.label("elementGui.slots.defaultValue");
        resourceComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/render_texture"), L10N.label("elementGui.slots.resource", Constants.NO_PARAMS));
        customComp = L10N.label("elementGui.slots.custom", Constants.NO_PARAMS);

        height.setVisible(false);
        heightComp.setVisible(false);
        fullTank.setVisible(false);
        fullTankComp.setVisible(false);
        tankCapacity.setVisible(false);
        tankCapacity.setEnabled(false);
        tankCapacityComp.setVisible(false);

        if (Constants.DEV_MODE) {
            io.setModel(new DefaultComboBoxModel<>(new String[]{"Input", "Output", "Render", "Custom"}));
        } else {
            io.setModel(new DefaultComboBoxModel<>(new String[]{"Input", "Output", "Render"}));
        }

        resourceComp.setVisible(false);
        resource = new TextureSelectionButton(new TypedTextureSelectorDialog(mcreator, TextureType.SCREEN), 40);
        resource.setVisible(false);

        custom.setVisible(false);
        customComp.setVisible(false);

        defaultComp.setVisible(false);
        defaultBoolean.setVisible(false);
        defaultDouble.setVisible(false);
        defaultString.setVisible(false);

        io.setPreferredSize(Constants.DIMENSION);
        type.setPreferredSize(Constants.DIMENSION);
        name.setPreferredSize(Constants.DIMENSION);
        x.setPreferredSize(Constants.DIMENSION);
        y.setPreferredSize(Constants.DIMENSION);
        height.setPreferredSize(Constants.DIMENSION);
        tankCapacity.setPreferredSize(Constants.DIMENSION);

        custom.setPreferredSize(new Dimension(1000, Constants.HEIGHT));
        custom.setFont(FontUtil.getDefaultMonospacedFont());

        defaultBoolean.setPreferredSize(Constants.DIMENSION);
        defaultDouble.setPreferredSize(Constants.DIMENSION);
        defaultString.setPreferredSize(Constants.DIMENSION);

        defaultBoolean.setEnabled(false);
        defaultDouble.setEnabled(false);
        defaultString.setEnabled(false);

        io.addActionListener(e -> setIOSelected((String) io.getSelectedItem()));
        type.addActionListener(e -> setTypeSelected((String) type.getSelectedItem()));
        optional.addActionListener(e -> setOptional(optional.isSelected()));
        fullTank.addActionListener(e -> tankCapacity.setEnabled(fullTank.isSelected()));
        name.getDocument().addDocumentListener(GuiUtils.FORCE_LOWER_CASE(name));

        line.add(HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/slot_io"), L10N.label("elementGui.slots.io", Constants.NO_PARAMS)));
        line.add(io);
        line.add(typeComp);
        line.add(type);
        line.add(nameComp);
        line.add(name);
        line.add(xComp);
        line.add(x);
        line.add(yComp);
        line.add(y);
        line.add(singleComp);
        line.add(single);
        line.add(heightComp);
        line.add(height);
        line.add(fullTankComp);
        line.add(fullTank);
        line.add(tankCapacityComp);
        line.add(tankCapacity);
        line.add(optionalComp);
        line.add(optional);
        line.add(resourceComp);
        line.add(resource);
        line.add(customComp);
        line.add(custom);
        line.add(defaultComp);
        line.add(defaultBoolean);
        line.add(defaultDouble);
        line.add(defaultString);
    }

    @Override
    public void reloadDataLists() {
        super.reloadDataLists();
    }

    @Override
    protected void setEntryEnabled(boolean enabled) {
        io.setEnabled(enabled);
        type.setEnabled(enabled);
        name.setEnabled(enabled);
        x.setEnabled(enabled);
        y.setEnabled(enabled);

        single.setEnabled(enabled);

        height.setEnabled(enabled);
        fullTank.setEnabled(enabled);

        optional.setEnabled(enabled);
        resource.setEnabled(enabled);

        custom.setEnabled(enabled);
    }

    @Override
    public RecipeType.SlotListEntry getEntry() {
        RecipeType.SlotListEntry element = new RecipeType.SlotListEntry();

        element.io = (String) io.getSelectedItem();
        element.type = (String) type.getSelectedItem();
        element.name = name.getText();
        element.x = (int) x.getValue();
        element.y =(int) y.getValue();

        element.singleItem = single.isSelected();

        element.height = (int) height.getValue();
        element.fullTank = fullTank.isSelected();
        element.tankCapacity = (int) tankCapacity.getValue();

        element.optional = optional.isSelected();
        element.resource = resource.getTextureHolder();
        element.resourceWidth = resource.getTextureHolder().getImage(TextureType.SCREEN).getWidth(null);
        element.resourceHeight = resource.getTextureHolder().getImage(TextureType.SCREEN).getHeight(null);

        element.custom = custom.getText();

        if(defaultBoolean.getSelectedItem().equals("true")) {
            element.defaultBoolean = true;
        } else {
            element.defaultBoolean = false;
        }
        element.defaultDouble = (double) defaultDouble.getValue();
        element.defaultString = defaultString.getText();

        return element;
    }

    @Override
    public void setEntry(RecipeType.SlotListEntry element) {
        io.setSelectedItem(element.io);
        type.setSelectedItem(element.type);
        name.setText(element.name);
        x.setValue(element.x);
        y.setValue(element.y);

        single.setSelected(element.singleItem);

        height.setValue(element.height);
        fullTank.setSelected(element.fullTank);
        tankCapacity.setValue(element.tankCapacity);

        optional.setSelected(element.optional);
        resource.setTexture(element.resource);

        custom.setText(element.custom);

        if (element.defaultBoolean) {
            defaultBoolean.setSelectedItem("true");
        } else {
            defaultBoolean.setSelectedItem("false");
        }
        defaultDouble.setValue(element.defaultDouble);
        defaultString.setText(element.defaultString);
    }

    private void hideAll(boolean includeNameAndType) {
        if (includeNameAndType) {
            typeComp.setVisible(false);
            type.setVisible(false);
            nameComp.setVisible(false);
            name.setVisible(false);
        }

        xComp.setVisible(false);
        x.setVisible(false);
        yComp.setVisible(false);
        y.setVisible(false);

        singleComp.setVisible(false);
        single.setVisible(false);

        heightComp.setVisible(false);
        height.setVisible(false);
        fullTankComp.setVisible(false);
        fullTank.setVisible(false);
        tankCapacityComp.setVisible(false);
        tankCapacity.setVisible(false);

        optionalComp.setVisible(false);
        optional.setVisible(false);

        resourceComp.setVisible(false);
        resource.setVisible(false);

        customComp.setVisible(false);
        custom.setVisible(false);

        defaultComp.setVisible(false);
        defaultBoolean.setVisible(false);
        defaultDouble.setVisible(false);
        defaultString.setVisible(false);
    }

    private void enableRender() {
        setInputEnabled(false);

        resourceComp.setVisible(true);
        resource.setVisible(true);
    }

    private void setIOSelected(@Nullable String io) {
        hideAll(true);

        switch (io) {
            case "Input" -> {
                typeComp.setVisible(true);
                type.setVisible(true);
                nameComp.setVisible(true);
                name.setVisible(true);

                setTypeSelected((String) type.getSelectedItem());

                setInputEnabled(true);
            }
            case "Output" -> {
                typeComp.setVisible(true);
                type.setVisible(true);
                nameComp.setVisible(true);
                name.setVisible(true);

                setTypeSelected((String) type.getSelectedItem());

                setInputEnabled(false);
            }
            case "Render" -> {
                nameComp.setVisible(true);
                name.setVisible(true);

                enableRender();
            }
            case "Custom" -> {
                customComp.setVisible(true);
                custom.setVisible(true);
            }
            case null, default -> hideAll(true);
        }
    }

    private void setTypeSelected(@Nullable String type) {
        if (!Objects.equals(io.getSelectedItem(), "Input") && !Objects.equals(io.getSelectedItem(), "Output")) {
            return;
        }

        hideAll(false);

        optionalComp.setVisible(true);
        optional.setVisible(true);

        switch (type) {
            case "Item" -> {
                xComp.setVisible(true);
                x.setVisible(true);
                yComp.setVisible(true);
                y.setVisible(true);

                singleComp.setVisible(true);
                single.setVisible(true);
            }
            case "Fluid" -> {
                xComp.setVisible(true);
                x.setVisible(true);
                yComp.setVisible(true);
                y.setVisible(true);

                heightComp.setVisible(true);
                height.setVisible(true);
                fullTankComp.setVisible(true);
                fullTank.setVisible(true);
                tankCapacityComp.setVisible(true);
                tankCapacity.setVisible(true);
            }
            case "Logic" -> {
                defaultComp.setVisible(true);
                defaultBoolean.setVisible(true);
            }
            case "Number" -> {
                defaultComp.setVisible(true);
                defaultDouble.setVisible(true);
            }
            case "Text" -> {
                defaultComp.setVisible(true);
                defaultString.setVisible(true);
            }
            case null, default -> hideAll(false);
        }
    }

    private void setOptional(boolean optional) {
        defaultBoolean.setEnabled(optional);
        defaultDouble.setEnabled(optional);
        defaultString.setEnabled(optional);
    }

    private void setInputEnabled(boolean input) {
        if (!input) {
            single.setSelected(false);
        }
        single.setEnabled(input);
    }
}
