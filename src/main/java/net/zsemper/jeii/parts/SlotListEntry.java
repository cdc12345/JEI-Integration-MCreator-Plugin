package net.zsemper.jeii.parts;

import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.entries.JSimpleListEntry;
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
import org.jetbrains.annotations.Nullable;

import javax.swing.*;
import java.util.List;

public class SlotListEntry extends JSimpleListEntry<RecipeType.SlotListEntry> {
    private final JComboBox<String> io = new JComboBox<>(new String[]{"Input", "Output", "Render"});
    private final JComboBox<String> type = new JComboBox<>(new String[]{"Item", "Fluid","Logic", "Number", "Text"});
    private final VTextField name = new VTextField();
    private final JSpinner x = new JSpinner(new SpinnerNumberModel(0, 0, 1000, 1));
    private final JSpinner y = new JSpinner(new SpinnerNumberModel(0, 0, 1000, 1));
    private final JSpinner height = new JSpinner(new SpinnerNumberModel(16, 1, 1000, 1));
    private final JCheckBox fullTank = new JCheckBox();
    private final JSpinner tankCapacity = new JSpinner(new SpinnerNumberModel(1, 1, null, 1));
    private final JCheckBox optional = new JCheckBox();
    private final JComboBox<String> defaultBoolean = new JComboBox<>(new String[]{"true", "false"});
    private final JSpinner defaultDouble = new JSpinner(new SpinnerNumberModel(0d, null, null, 0.01d));
    private final VTextField defaultString = new VTextField();
    private final TextureSelectionButton resource;

    private final JComponent typeComp;
    private final JComponent xComp;
    private final JComponent yComp;
    private final JComponent heightComp;
    private final JComponent fullTankComp;
    private final JComponent tankCapacityComp;
    private final JComponent optionalComp;
    private final JComponent defaultComp;
    private final JComponent resourceComp;

    public SlotListEntry(MCreator mcreator, IHelpContext help, JPanel parent, List<SlotListEntry> entryList) {
        super(parent, entryList);

        typeComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/slot_type"), L10N.label("elementGui.slots.type", Constants.NO_PARAMS));
        xComp = new JLabel(Constants.Translatable.X);
        yComp = new JLabel(Constants.Translatable.Y);
        heightComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/tank_height"), new JLabel(Constants.Translatable.HEIGHT));
        fullTankComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/full_tank"), L10N.label("elementGui.slots.tank", Constants.NO_PARAMS));
        tankCapacityComp = L10N.label("elementGui.slots.tankCapacity", Constants.NO_PARAMS);
        optionalComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/optional"), L10N.label("elementGui.slots.optional", Constants.NO_PARAMS));
        defaultComp = L10N.label("elementGui.slots.defaultValue");
        resourceComp = HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/render_texture"), L10N.label("elementGui.slots.resource", Constants.NO_PARAMS));

        height.setVisible(false);
        heightComp.setVisible(false);
        fullTank.setVisible(false);
        fullTankComp.setVisible(false);
        tankCapacity.setVisible(false);
        tankCapacity.setEnabled(false);
        tankCapacityComp.setVisible(false);

        resourceComp.setVisible(false);
        resource = new TextureSelectionButton(new TypedTextureSelectorDialog(mcreator, TextureType.SCREEN), 40);
        resource.setVisible(false);

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

        defaultBoolean.setPreferredSize(Constants.DIMENSION);
        defaultDouble.setPreferredSize(Constants.DIMENSION);
        defaultString.setPreferredSize(Constants.DIMENSION);

        io.addActionListener(e -> {
            renderSelected(io.getSelectedItem().equals("Render"));

            if (io.getSelectedItem().equals("Output")) {
                optional.setSelected(false);
                optional.setEnabled(false);
            } else {
                optional.setEnabled(true);
            }
        });

        type.addActionListener(e -> {
            triggerVarSelection();

            fluidSelected(type.getSelectedItem().equals("Fluid"));
        });

        optional.addActionListener(e -> {
            triggerVarSelection();
        });

        fullTank.addActionListener(e -> {
            tankCapacity.setEnabled(fullTank.isSelected());
        });

        name.getDocument().addDocumentListener(GuiUtils.FORCE_LOWER_CASE(name));

        this.line.add(HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/slot_io"), L10N.label("elementGui.slots.io", Constants.NO_PARAMS)));
        this.line.add(io);
        this.line.add(typeComp);
        this.line.add(type);
        this.line.add(HelpUtils.wrapWithHelpButton(help.withEntry("recipe_type/slot_name"), L10N.label("elementGui.slots.name", Constants.NO_PARAMS)));
        this.line.add(name);
        this.line.add(xComp);
        this.line.add(x);
        this.line.add(yComp);
        this.line.add(y);
        this.line.add(heightComp);
        this.line.add(height);
        this.line.add(fullTankComp);
        this.line.add(fullTank);
        this.line.add(tankCapacityComp);
        this.line.add(tankCapacity);
        this.line.add(optionalComp);
        this.line.add(optional);
        this.line.add(resourceComp);
        this.line.add(resource);
        this.line.add(defaultComp);
        this.line.add(defaultBoolean);
        this.line.add(defaultDouble);
        this.line.add(defaultString);
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

        height.setEnabled(enabled);
        fullTank.setEnabled(enabled);

        optional.setEnabled(enabled);
        resource.setEnabled(enabled);

        defaultBoolean.setEnabled(enabled);
        defaultDouble.setEnabled(enabled);
        defaultString.setEnabled(enabled);
    }

    @Override
    public RecipeType.SlotListEntry getEntry() {
        RecipeType.SlotListEntry entry = new RecipeType.SlotListEntry();

        entry.io = (String) io.getSelectedItem();
        entry.type = (String) type.getSelectedItem();
        entry.name = name.getText();
        entry.x = (int) x.getValue();
        entry.y =(int) y.getValue();

        entry.height = (int) height.getValue();
        entry.fullTank = fullTank.isSelected();
        entry.tankCapacity = (int) tankCapacity.getValue();

        entry.optional = optional.isSelected();
        entry.resource = resource.getTextureHolder();
        entry.resourceWidth = resource.getTextureHolder().getImage(TextureType.SCREEN).getWidth(null);
        entry.resourceHeight = resource.getTextureHolder().getImage(TextureType.SCREEN).getHeight(null);

        if(defaultBoolean.getSelectedItem().equals("true")) {
            entry.defaultBoolean = true;
        } else {
            entry.defaultBoolean = false;
        }
        entry.defaultDouble = (double) defaultDouble.getValue();
        entry.defaultString = defaultString.getText();

        return entry;
    }

    @Override
    public void setEntry(RecipeType.SlotListEntry entry) {
        io.setSelectedItem(entry.io);
        type.setSelectedItem(entry.type);
        name.setText(entry.name);
        x.setValue(entry.x);
        y.setValue(entry.y);

        height.setValue(entry.height);
        fullTank.setSelected(entry.fullTank);
        tankCapacity.setValue(entry.tankCapacity);

        optional.setSelected(entry.optional);
        resource.setTexture(entry.resource);

        if (entry.defaultBoolean) {
            defaultBoolean.setSelectedItem("true");
        } else {
            defaultBoolean.setSelectedItem("false");
        }
        defaultDouble.setValue(entry.defaultDouble);
        defaultString.setText(entry.defaultString);

        triggerVarSelection();
    }

    private void fluidSelected(boolean visible) {
        height.setVisible(visible);
        heightComp.setVisible(visible);
        fullTank.setVisible(visible);
        fullTankComp.setVisible(visible);
        tankCapacity.setVisible(visible);
        tankCapacityComp.setVisible(visible);
    }

    private void renderSelected(boolean visible) {
        typeComp.setVisible(!visible);
        type.setVisible(!visible);
        xComp.setVisible(!visible);
        x.setVisible(!visible);
        yComp.setVisible(!visible);
        y.setVisible(!visible);

        if (type.getSelectedItem().equals("Fluid")) {
            height.setVisible(!visible);
            heightComp.setVisible(!visible);
            fullTank.setVisible(!visible);
            fullTank.setVisible(!visible);
            tankCapacity.setVisible(!visible);
            tankCapacityComp.setVisible(!visible);
        }

        optionalComp.setVisible(!visible);
        optional.setVisible(!visible);

        defaultComp.setVisible(!visible);
        if (!visible) {
            triggerVarSelection();
        } else {
            varSelected("not visible");
        }

        resourceComp.setVisible(visible);
        resource.setVisible(visible);
    }

    private void triggerVarSelection() {
        String selected = (String) type.getSelectedItem();

        if (!io.getSelectedItem().equals("Render")) {
            if (selected.equals("Logic") || selected.equals("Number") || selected.equals("Text")) {
                x.setVisible(false);
                xComp.setVisible(false);
                y.setVisible(false);
                yComp.setVisible(false);

                height.setVisible(false);
                height.setVisible(false);
                fullTank.setVisible(false);
                fullTankComp.setVisible(false);
                tankCapacity.setVisible(false);
                tankCapacityComp.setVisible(false);
            } else {
                x.setVisible(true);
                xComp.setVisible(true);
                y.setVisible(true);
                yComp.setVisible(true);
            }
        }

        if (optional.isSelected()) {
            varSelected(selected);
        } else {
            varSelected(null);
        }
    }

    private void varSelected(@Nullable String type) {
        switch (type) {
            case "Logic" -> {
                defaultComp.setVisible(true);
                defaultBoolean.setVisible(true);
                defaultDouble.setVisible(false);
                defaultString.setVisible(false);
            }
            case "Number" -> {
                defaultComp.setVisible(true);
                defaultBoolean.setVisible(false);
                defaultDouble.setVisible(true);
                defaultString.setVisible(false);
            }
            case "Text" -> {
                defaultComp.setVisible(true);
                defaultBoolean.setVisible(false);
                defaultDouble.setVisible(false);
                defaultString.setVisible(true);
            }
            case null -> {
                varSelected("null");
            }
            default -> {
                defaultComp.setVisible(false);
                defaultBoolean.setVisible(false);
                defaultDouble.setVisible(false);
                defaultString.setVisible(false);
            }
        }
    }
}
