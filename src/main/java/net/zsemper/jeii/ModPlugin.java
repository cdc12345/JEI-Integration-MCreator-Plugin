package net.zsemper.jeii;

import net.mcreator.blockly.data.BlocklyLoader;
import net.mcreator.plugin.JavaPlugin;
import net.mcreator.plugin.Plugin;
import net.mcreator.plugin.events.PreGeneratorsLoadingEvent;
import net.zsemper.jeii.utils.Constants;
import net.zsemper.jeii.utils.ElementLoader;

public class ModPlugin extends JavaPlugin {
    public ModPlugin(Plugin plugin) {
        super(plugin);

        addListener(PreGeneratorsLoadingEvent.class, event -> {
            ElementLoader.load();
            BlocklyLoader.INSTANCE.addBlockLoader(Constants.RENDER_EDITOR);
        });

        if (Constants.DEV_MODE) {
            Constants.LOG.info("JEI Integration was loaded in DEV_MODE");
        } else {
            Constants.LOG.info("JEI Integration was loaded");
        }
    }
}
