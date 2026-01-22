import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;
import Toybox.Graphics;

class MenuDelegate extends WatchUi.BehaviorDelegate {
    
    function initialize() {
        BehaviorDelegate.initialize();
    }
    
    function onBack() as Boolean {
        System.exit();
        return true;
    }
    
}

// Factory pour créer le picker du salaire
class SalairePickerFactory extends WatchUi.PickerFactory {
    private var mValues as Array<Number>;
    
    function initialize() {
        PickerFactory.initialize();
        
        // Créer les valeurs de 5 à 100 par pas de 5, puis de 100 à 200 par pas de 10
        mValues = [];
        for (var i = 5; i <= 100; i += 5) {
            mValues.add(i);
        }
        for (var i = 110; i <= 200; i += 10) {
            mValues.add(i);
        }
    }
    
    function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({
            :text => mValues[index].format("%d") + " $",
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_LARGE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
    
    function getValue(index as Number) as Object or Null {
        return mValues[index];
    }
    
    function getSize() as Number {
        return mValues.size();
    }
    
    function getIndex(value as Object) as Number {
        var salaireActuel = Application.Properties.getValue("salaire");
        if (salaireActuel != null) {
            var sal = salaireActuel.toNumber();
            // Trouver l'index le plus proche
            for (var i = 0; i < mValues.size(); i++) {
                if (mValues[i] >= sal) {
                    return i;
                }
            }
        }
        return 4; // Par défaut 25$ (index 4)
    }
    
}