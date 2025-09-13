Blockly.Constants = Blockly.Constants || {};
Blockly.Constants.Logic = Blockly.Constants.Logic || {};

Blockly.Constants.Logic.CONTROLS_IF_MUTATOR_MIXIN = {
  elseifCount_: 0,
  elseCount_: 0,

  mutationToDom: function() {
    if (!this.elseifCount_ && !this.elseCount_) {
      return null;
    }
    var container = document.createElement("mutation");
    if (this.elseifCount_) {
      container.setAttribute("elseif", this.elseifCount_);
    }
    if (this.elseCount_) {
      container.setAttribute("else", 1);
    }
    return container;
  },

  domToMutation: function(xmlElement) {
    this.elseifCount_ = parseInt(xmlElement.getAttribute("elseif"), 10) || 0;
    this.elseCount_ = parseInt(xmlElement.getAttribute("else"), 10) || 0;
    this.updateShape_();
  },

  decompose: function(workspace) {
    var containerBlock = workspace.newBlock("controls_if_if");
    containerBlock.initSvg();
    var connection = containerBlock.nextConnection;
    for (var i = 1; i <= this.elseifCount_; i++) {
      var elseifBlock = workspace.newBlock("controls_if_elseif");
      elseifBlock.initSvg();
      connection.connect(elseifBlock.previousConnection);
      connection = elseifBlock.nextConnection;
    }
    if (this.elseCount_) {
      var elseBlock = workspace.newBlock("controls_if_else");
      elseBlock.initSvg();
      connection.connect(elseBlock.previousConnection);
    }
    return containerBlock;
  },

  compose: function(containerBlock) {
    var clauseBlock = containerBlock.nextConnection.targetBlock();
    this.elseifCount_ = 0;
    this.elseCount_ = 0;
    var valueConnections = [null];
    var statementConnections = [null];
    var elseStatementConnection = null;

    while (clauseBlock) {
      switch (clauseBlock.type) {
        case "controls_if_elseif":
          this.elseifCount_++;
          valueConnections.push(clauseBlock.valueConnection_);
          statementConnections.push(clauseBlock.statementConnection_);
          break;
        case "controls_if_else":
          this.elseCount_++;
          elseStatementConnection = clauseBlock.statementConnection_;
          break;
        default:
          throw TypeError("Unknown block type: " + clauseBlock.type);
      }
      clauseBlock = clauseBlock.nextConnection &&
          clauseBlock.nextConnection.targetBlock();
    }

    this.updateShape_();

    for (var i = 1; i <= this.elseifCount_; i++) {
      if (valueConnections[i]) {
        this.getInput("IF" + i).connection.connect(valueConnections[i]);
      }
      if (statementConnections[i]) {
        this.getInput("DO" + i).connection.connect(statementConnections[i]);
      }
    }
    if (this.elseCount_ && elseStatementConnection) {
      this.getInput("ELSE0").connection.connect(elseStatementConnection);
    }
  },

  saveConnections: function(containerBlock) {
    var clauseBlock = containerBlock.nextConnection.targetBlock();
    var i = 1;
    while (clauseBlock) {
      switch (clauseBlock.type) {
        case "controls_if_elseif":
          var inputIf = this.getInput("IF" + i);
          var inputDo = this.getInput("DO" + i);
          clauseBlock.valueConnection_ =
              inputIf && inputIf.connection.targetConnection;
          clauseBlock.statementConnection_ =
              inputDo && inputDo.connection.targetConnection;
          i++;
          break;
        case "controls_if_else":
          var inputDo2 = this.getInput("ELSE0");
          clauseBlock.statementConnection_ =
              inputDo2 && inputDo2.connection.targetConnection;
          break;
        default:
          throw TypeError("Unknown block type: " + clauseBlock.type);
      }
      clauseBlock = clauseBlock.nextConnection &&
          clauseBlock.nextConnection.targetBlock();
    }
  },

  updateShape_: function() {
    // Remove old inputs
    for (var i = 1; this.getInput("IF" + i); i++) {
      this.removeInput("IF" + i);
      this.removeInput("DO" + i);
    }
    if (this.getInput("ELSE0")) {
      this.removeInput("ELSE0");
    }

    // Add new elseif inputs
    for (var i = 1; i <= this.elseifCount_; i++) {
      this.appendValueInput("IF" + i)
          .setCheck("Boolean")
          .appendField(javabridge.t("blockly.block.jei_logic_ifBlock.elseif"));
      this.appendStatementInput("DO" + i)
          .appendField(javabridge.t("blockly.block.jei_logic_ifBlock.do"));
    }

    // Add new else input
    if (this.elseCount_) {
      this.appendStatementInput('ELSE0')
          .appendField(javabridge.t("blockly.block.jei_logic_ifBlock.else"));
    }
  }
};

Blockly.Extensions.registerMutator(
  'if_mutator',
  Blockly.Constants.Logic.CONTROLS_IF_MUTATOR_MIXIN,
  null,
  ['controls_if_elseif', 'controls_if_else']
);