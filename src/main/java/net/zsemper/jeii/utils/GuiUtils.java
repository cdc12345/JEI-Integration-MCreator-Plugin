package net.zsemper.jeii.utils;

import net.mcreator.ui.init.L10N;
import net.mcreator.ui.laf.themes.Theme;
import net.mcreator.ui.validation.component.VTextField;

import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.text.BadLocationException;
import java.awt.*;

public final class GuiUtils {
    private static final Color color = Theme.current().getForegroundColor();

    // Returns a border of the element
    public static Border BORDER() {
        return BorderFactory.createLineBorder(color, 1);
    }

    // Returns a border with a title of the element
    public static Border BORDER(String key, JComponent this0) {
        Border lineBorder = BORDER();

        return BorderFactory.createTitledBorder(lineBorder, L10N.t(key, Constants.NO_PARAMS), 0, 0, this0.getFont().deriveFont(12.0F), color);
    }

    // Returns an empty border with padding
    public static Border EMPTY_BORDER(int padding) {
        return BorderFactory.createEmptyBorder(padding, padding, padding, padding);
    }

    // Returns a JPanel with a border and title
    public static JPanel BORDER_PANEL(String key, JComponent this0) {
        Border empty = BorderFactory.createEmptyBorder();
        Border border = BorderFactory.createCompoundBorder(BORDER(key, this0), empty);

        JPanel panel = new JPanel();
        panel.setOpaque(false);
        panel.add(this0);
        panel.setBorder(border);
        return panel;
    }

    public static Dimension PANEL_DIMENSION(int width, int height, int rows, int cols, int hgap, int vgap) {
        int dWidth = (width * cols) + ((cols + 1) * hgap);
        int dHeight = (height * rows) + ((rows + 1) * vgap);
        return new Dimension(dWidth, dHeight);
    }

    public static Dimension PANEL_DIMENSION(int width, int height, int rows, int cols) {
        return PANEL_DIMENSION(width, height, rows, cols, 2, 2);
    }

    public static Dimension PANEL_DIMENSION(int rows, int cols) {
        return PANEL_DIMENSION(Constants.WIDTH, Constants.HEIGHT, rows, cols, 2, 2);
    }

    public static DocumentListener FORCE_LOWER_CASE(VTextField this0) {
        return new DocumentListener() {
            private void update(DocumentEvent evt) {
                SwingUtilities.invokeLater(() -> {
                    try {
                        String str = evt.getDocument().getText(0, evt.getDocument().getLength());
                        String set = str.toLowerCase();

                        if(!str.equals(set)) {
                            this0.setText(set);
                        }
                    } catch (BadLocationException e) {
                        Constants.LOG.error(e.getStackTrace());
                    }
                });
            }
            @Override
            public void insertUpdate(DocumentEvent evt) {
                update(evt);
            }

            @Override
            public void removeUpdate(DocumentEvent evt) {
                update(evt);
            }

            @Override
            public void changedUpdate(DocumentEvent evt) {
                update(evt);
            }
        };
    }
}
