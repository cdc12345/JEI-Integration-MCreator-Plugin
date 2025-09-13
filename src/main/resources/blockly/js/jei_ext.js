// Render Blockly Start Block
Blockly.Blocks["render_start"] = {
    init: function () {
        this.appendDummyInput().appendField(javabridge.t("blockly.block.render_start"));
        this.setStyle("hat_blocks");
        this.setNextStatement(true);
        this.setColour("#67a55b");
    }
}

// Force Lowercase FieldTextInput
class FieldLowerTextInput extends Blockly.FieldTextInput {
    doClassValidation_(newValue) {
        return newValue.toLowerCase();
    }
}
Blockly.fieldRegistry.register("field_lowercase_input", FieldLowerTextInput);
