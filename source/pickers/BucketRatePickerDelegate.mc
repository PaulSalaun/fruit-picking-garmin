import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;
import Toybox.Graphics;

// Factory pour le picker du bucket rate
class BucketRatePickerFactory extends WatchUi.PickerFactory {
    private var mValues as Array<Number>;
    
    function initialize() {
        PickerFactory.initialize();
        
        // Créer les valeurs de 1 à 50
        mValues = [];
        for (var i = 1; i <= 50; i++) {
            mValues.add(i);
        }
    }
    
    function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({
            :text => mValues[index].toString(),
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
        var bucketRateActuel = Application.Properties.getValue("bucketRate");
        if (bucketRateActuel != null) {
            var rate = bucketRateActuel.toNumber();
            // Trouver l'index correspondant (rate - 1 car on commence à 1)
            if (rate >= 1 && rate <= 50) {
                return rate - 1;
            }
        }
        return 6; // Par défaut 7 (index 6)
    }
    
}