import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Application;
import Toybox.System;

class CircularNumberPickerDelegate extends WatchUi.InputDelegate {
    private var picker as CircularNumberPicker;
    
    function initialize(pickerView as CircularNumberPicker) {
        InputDelegate.initialize();
        picker = pickerView;
    }
    
    // Gestion du clic sur l'écran tactile
    function onTap(clickEvent as ClickEvent) as Boolean {
        var coords = clickEvent.getCoordinates();
        var x = coords[0];
        var y = coords[1];
        
        // Obtenir les dimensions de l'écran
        var width = System.getDeviceSettings().screenWidth;
        var height = System.getDeviceSettings().screenHeight;
        var centerX = width / 2;
        var centerY = height / 2;
        var radius = width * 0.38;
        
        // Calculer la distance du clic par rapport au centre
        var dx = x - centerX;
        var dy = y - centerY;
        var distance = Math.sqrt((dx * dx) + (dy * dy));
        
        // Vérifier si on a cliqué sur le bouton OK au centre-bas
        var okButtonY = centerY + 50;
        var okButtonDx = x - centerX;
        var okButtonDy = y - okButtonY;
        var okDistance = Math.sqrt((okButtonDx * okButtonDx) + (okButtonDy * okButtonDy));
        
        if (okDistance < 30) {
            // Clic sur le bouton OK - valider
            validateAndSave();
            return true;
        }
        
        // Si le clic est sur le cercle des chiffres (zone autour du rayon)
        if (distance > radius * 0.6 && distance < radius * 1.4) {
            // Calculer l'angle du clic
            var angleRad = Math.atan2(dy, dx);
            var angleDeg = Math.toDegrees(angleRad);
            
            // Normaliser l'angle (0° en haut = -90° en radians standard)
            // Convertir pour que 0° soit en haut et augmente dans le sens horaire
            angleDeg = angleDeg + 90;
            if (angleDeg < 0) {
                angleDeg = angleDeg + 360;
            }
            
            // 11 positions : 0-9 + symbole
            // Chaque position occupe 360/11 = 32.7°
            var totalPositions = 11;
            var degreesPerPosition = 360.0 / totalPositions;
            
            // Déterminer quelle position a été cliquée
            var positionIndex = ((angleDeg + (degreesPerPosition / 2)) / degreesPerPosition).toNumber() % totalPositions;
            
            if (positionIndex < 10) {
                // Chiffre 0-9
                picker.addDigit(positionIndex);
            } else {
                // Position 10 : point ou deux-points
                picker.addDecimalPoint();
            }
            
            // IMPORTANT : retourner true pour consommer l'événement
            return true;
        }
        
        // Si on clique ailleurs, ne rien faire mais consommer l'événement
        return true;
    }
    
    // Valider et sauvegarder
    function validateAndSave() as Void {
        var value = picker.getValue();
        var propertyKey = picker.getPropertyKey();
        
        if (value.length() == 0) {
            value = "0";
        }
        
        // Sauvegarder selon le type de propriété
        if (propertyKey.equals("salaire")) {
            var salaire = value.toFloat();
            if (salaire != null) {
                Application.Properties.setValue("salaire", salaire);
            }
        } else if (propertyKey.equals("heureDepart")) {
            // Parser HH:MM
            var colonIndex = value.find(":");
            if (colonIndex != null) {
                var heuresStr = value.substring(0, colonIndex);
                var minutesStr = value.substring(colonIndex + 1, value.length());
                var heures = heuresStr.toNumber();
                var minutes = minutesStr.toNumber();
                
                if (heures != null && minutes != null) {
                    var minutesTotales = (heures * 60) + minutes;
                    Application.Properties.setValue("heureDepart", minutesTotales);
                }
            } else {
                // Si pas de deux-points, considérer comme des heures seulement
                var heures = value.toNumber();
                if (heures != null) {
                    Application.Properties.setValue("heureDepart", heures * 60);
                }
            }
        } else if (propertyKey.equals("bucketRate")) {
            var bucketRate = value.toFloat();
            if (bucketRate != null && bucketRate > 0) {
                Application.Properties.setValue("bucketRate", bucketRate);
            }
        }
        
        // Marquer que le menu doit être rafraîchi
        $.gMenuNeedsRefresh = true;
        
        // Retour au menu
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        
        // Forcer la recréation du menu immédiatement
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        var menuView = new MenuView();
        WatchUi.pushView(menuView, new MenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
    }
    
    // Gestion des touches physiques
    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();
        
        if (key == WatchUi.KEY_ENTER) {
            // Bouton SELECT pour valider
            validateAndSave();
            return true;
        } else if (key == WatchUi.KEY_ESC) {
            // Bouton BACK pour effacer le dernier chiffre
            var value = picker.getValue();
            if (value.length() > 0) {
                picker.deleteLastDigit();
                return true;
            } else {
                // Si vide, retour au menu
                WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
                return true;
            }
        } else if (key == WatchUi.KEY_DOWN) {
            // Bouton DOWN pour effacer tout
            picker.clear();
            return true;
        }
        
        return false;
    }
    
}