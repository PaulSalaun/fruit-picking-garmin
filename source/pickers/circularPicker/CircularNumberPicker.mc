import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

class CircularNumberPicker extends WatchUi.View {
    private var currentValue as String = "";
    private var title as String;
    private var maxDigits as Number;
    private var allowDecimal as Boolean;
    private var propertyKey as String;
    
    function initialize(titleText as String, propKey as String, maxDig as Number, decimal as Boolean) {
        View.initialize();
        title = titleText;
        propertyKey = propKey;
        maxDigits = maxDig;
        allowDecimal = decimal;
        currentValue = "";
    }
    
    function onLayout(dc as Dc) as Void {
    }
    
    function onShow() as Void {
    }
    
    function onUpdate(dc as Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;
        var radius = width * 0.38;
        
        // Fond noir
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        // Dessiner les chiffres en cercle (0-9 + symbole)
        // 11 positions au total : 0-9 + point/deux-points
        var totalPositions = 11;
        
        for (var i = 0; i < totalPositions; i++) {
            // Calculer l'angle : commencer en haut (-90°) et faire un tour complet (360°)
            // Chaque position est espacée de 360/11 = 32.7°
            var angle = -90 + (i * 360.0 / totalPositions);
            var angleRad = Math.toRadians(angle);
            
            var x = centerX + (radius * Math.cos(angleRad));
            var y = centerY + (radius * Math.sin(angleRad));
            
            var text;
            var color = Graphics.COLOR_WHITE;
            
            if (i < 10) {
                text = i.toString();
            } else {
                // Dernier élément : point ou deux-points
                text = propertyKey.equals("heureDepart") ? ":" : ".";
                color = Graphics.COLOR_YELLOW;
            }
            
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            dc.drawText(x, y, Graphics.FONT_MEDIUM, text, Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        // Afficher la valeur actuelle au centre
        var displayValue = currentValue;
        if (displayValue.length() == 0) {
            displayValue = "-";
        }
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - 50, Graphics.FONT_NUMBER_MEDIUM, displayValue, Graphics.TEXT_JUSTIFY_CENTER);
        
        // Icône/bouton VALIDER en bas du centre
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY + 70, 30);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY + 45, Graphics.FONT_SMALL, "OK", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function onHide() as Void {
    }
    
    // Ajouter un chiffre à la valeur
    function addDigit(digit as Number) as Void {
        if (currentValue.length() < maxDigits) {
            currentValue = currentValue + digit.toString();
            WatchUi.requestUpdate();
        }
    }
    
    // Ajouter un point décimal ou deux-points
    function addDecimalPoint() as Void {
        if (allowDecimal && currentValue.find(".") == null && currentValue.find(":") == null) {
            var symbol = propertyKey.equals("heureDepart") ? ":" : ".";
            currentValue = currentValue + symbol;
            WatchUi.requestUpdate();
        }
    }
    
    // Effacer le dernier chiffre
    function deleteLastDigit() as Void {
        if (currentValue.length() > 0) {
            currentValue = currentValue.substring(0, currentValue.length() - 1);
            WatchUi.requestUpdate();
        }
    }
    
    // Réinitialiser
    function clear() as Void {
        currentValue = "";
        WatchUi.requestUpdate();
    }
    
    // Obtenir la valeur finale
    function getValue() as String {
        return currentValue;
    }
    
    function getPropertyKey() as String {
        return propertyKey;
    }
}