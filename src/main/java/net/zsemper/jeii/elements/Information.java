package net.zsemper.jeii.elements;

import net.mcreator.element.GeneratableElement;
import net.mcreator.element.parts.Fluid;
import net.mcreator.element.parts.MItemBlock;
import net.mcreator.workspace.elements.ModElement;

import java.util.List;

public class Information extends GeneratableElement {
    public String type;
    public List<MItemBlock> items;
    public List<Fluid> fluids;
    public List<String> info;

    public Information(ModElement element) {
        super(element);
    }

    public String getDescription() {
        String description = "";
        for (int i = 0; i < info.size(); i++)
            description += i == 0 ? info.get(i) : "\n" + info.get(i);
        return description;
    }
}
