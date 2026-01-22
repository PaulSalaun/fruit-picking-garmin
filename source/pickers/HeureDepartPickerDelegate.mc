import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;
import Toybox.Graphics;

// Factory pour les heures (0-23)
class HeurePickerFactory extends WatchUi.PickerFactory {
    
    function initialize() {
        PickerFactory.initialize();
    }
    
    function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({
            :text => index.format("%02d"),
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_LARGE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
    
    function getValue(index as Number) as Object or Null {
        return index;
    }
    
    function getSize() as Number {
        return 24; // 0 à 23
    }
    
    function getIndex(value as Object) as Number {
        var heureDepartMinutes = Application.Properties.getValue("heureDepart");
        if (heureDepartMinutes != null) {
            return heureDepartMinutes / 60;
        }
        return 7; // Par défaut 7h
    }
    
}

// Factory pour les minutes (0-59)
class MinutePickerFactory extends WatchUi.PickerFactory {
    
    function initialize() {
        PickerFactory.initialize();
    }
    
    function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({
            :text => index.format("%02d"),
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_LARGE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
    
    function getValue(index as Number) as Object or Null {
        return index;
    }
    
    function getSize() as Number {
        return 60; // 0 à 59
    }
    
    function getIndex(value as Object) as Number {
        var heureDepartMinutes = Application.Properties.getValue("heureDepart");
        if (heureDepartMinutes != null) {
            return heureDepartMinutes % 60;
        }
        return 0; // Par défaut 00 minutes
    }
    
}