import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Application;

class BucketRateView extends WatchUi.View {
    
    private var salaire as Float = 24.5;
    private var heureDepart as Number = 420; // minutes depuis minuit
    private var bucketRate as Float = 7.0;
    private var bucketValue as Float = 0.0;
    private var currentTimeString as String = "";

    function initialize() {
        View.initialize();
        
        // Charger les paramètres depuis les propriétés
        var salaireProperty = Application.Properties.getValue("salaire");
        if (salaireProperty != null) {
            salaire = salaireProperty as Float;
        }
        
        var heureDepartProperty = Application.Properties.getValue("heureDepart");
        if (heureDepartProperty != null) {
            heureDepart = heureDepartProperty as Number;
        }
        
        var bucketRateProperty = Application.Properties.getValue("bucketRate");
        if (bucketRateProperty != null) {
            bucketRate = bucketRateProperty as Float;
        }
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
        // Démarre le timer pour mettre à jour chaque seconde
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Dc) as Void {
        // Récupérer l'heure actuelle
        var clockTime = System.getClockTime();
        var currentMinutes = (clockTime.hour * 60) + clockTime.min;
        
        // Calculer les heures travaillées en format décimal
        var minutesTravaillees = currentMinutes - heureDepart;
        
        // Si on est avant l'heure de départ, considérer 0
        if (minutesTravaillees < 0) {
            minutesTravaillees = 0;
        }
        
        var heuresTravaillees = minutesTravaillees / 60.0;
        
        // Calculer le bucket value
        // Formule : (salaire * heures travaillées) / bucket rate
        bucketValue = (salaire * heuresTravaillees) / bucketRate;
        
        // Formater l'heure actuelle
        currentTimeString = clockTime.hour.format("%02d") + ":" + 
                           clockTime.min.format("%02d") + ":" + 
                           clockTime.sec.format("%02d");
        
        // Dessiner l'interface
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Fond noir
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        // === HEURE ACTUELLE (en haut) ===
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            40,
            Graphics.FONT_MEDIUM,
            currentTimeString,
            Graphics.TEXT_JUSTIFY_CENTER
        );
        
        // === BUCKET VALUE (centre, gros chiffre) ===
        var bucketValueStr = bucketValue.format("%.2f");
        
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            height / 2 - 80,
            Graphics.FONT_NUMBER_HOT,
            bucketValueStr,
            Graphics.TEXT_JUSTIFY_CENTER
        );
        
        // Label sous le chiffre
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            height / 2 + 50,
            Graphics.FONT_SMALL,
            "Bucket Value",
            Graphics.TEXT_JUSTIFY_CENTER
        );
        
        // === INFOS EN BAS ===
        var heureDepartHeures = heureDepart / 60;
        var heureDepartMinutes = heureDepart % 60;
        var infos = "Start: " + heureDepartHeures.format("%02d") + ":" + heureDepartMinutes.format("%02d") + 
                    " | Rate: " + bucketRate.format("%.1f");
        
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            width / 2,
            height - 70,
            Graphics.FONT_XTINY,
            infos,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function onHide() as Void {
    }

}