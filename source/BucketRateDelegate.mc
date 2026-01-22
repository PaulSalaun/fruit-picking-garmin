import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.System;

class BucketRateDelegate extends WatchUi.BehaviorDelegate {
    
    private var updateTimer as Timer.Timer?;

    function initialize() {
        BehaviorDelegate.initialize();
        
        // Créer un timer qui met à jour l'affichage chaque seconde
        updateTimer = new Timer.Timer();
        updateTimer.start(method(:onTimer), 1000, true);
    }
    
    // Appelé chaque seconde par le timer
    function onTimer() as Void {
        WatchUi.requestUpdate();
    }
    
    // Bouton BACK pour quitter
    function onBack() as Boolean {
        if (updateTimer != null) {
            updateTimer.stop();
        }
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
    
    // Bouton SELECT pour forcer une mise à jour
    function onSelect() as Boolean {
        WatchUi.requestUpdate();
        return true;
    }

}