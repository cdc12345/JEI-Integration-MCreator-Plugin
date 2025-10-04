Blockly.Extensions.register("color_changing", function () {
  const field = this.getField("HEX");

  field.setValidator(function (newValue) {
    if (typeof newValue !== "string") return null;

    let v = newValue.trim().toUpperCase();
    if (!v.startsWith("#")) v = "#" + v;

    v = "#" + v.slice(1).replace(/[^0-9A-F]/g, "").slice(0, 6);

    return v;
  });

  const updateColor = (blk) => {
    const hex = field.getValue();
    if (/^#[0-9A-F]{6}$/.test(hex)) {
      blk.setColour(hex);
    }
  };

  updateColor(this);

  this.setOnChange(function (_e) {
    updateColor(this);
  });
});
