import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.System;

class ConfigMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    function initialize() {
        Menu2InputDelegate.initialize();
    }
    
    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        
        if (id == :salaire) {
            // NumberPicker pour le salaire (format décimal avec 2 chiffres)
            var salaireActuel = Application.Properties.getValue("salaire");
            if (salaireActuel == null) { salaireActuel = 25.0; }
            
            // Créer un picker avec 3 colonnes : dizaines, unités, décimales
            var title = new WatchUi.Text({
                :text => "Salaire $/h",
                :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                :locY => WatchUi.LAYOUT_VALIGN_BOTTOM,
                :color => Graphics.COLOR_WHITE
            });
            
            var factoryDizaines = new ChiffreDizainesFactory();
            var factoryUnites = new ChiffreUnitesFactory();
            var factoryPoint = new PointFactory();
            var factoryDecimales = new ChiffreDecimalesFactory();
            
            var picker = new WatchUi.Picker({
                :title => title, 
                :pattern => [factoryDizaines, factoryUnites, factoryPoint, factoryDecimales]
            });
            
            WatchUi.pushView(picker, new SalaireNumberPickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
            
        } else if (id == :heureDepart) {
            // Picker d'heure standard avec 2 colonnes (heures : minutes)
            var heureDepartMinutes = Application.Properties.getValue("heureDepart");
            if (heureDepartMinutes == null) { heureDepartMinutes = 420; }
            
            var title = new WatchUi.Text({
                :text => "Heure début",
                :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                :locY => WatchUi.LAYOUT_VALIGN_BOTTOM,
                :color => Graphics.COLOR_WHITE
            });
            
            var factoryH = new HeurePickerFactory();
            var factoryM = new MinutePickerFactory();
            var picker = new WatchUi.Picker({:title => title, :pattern => [factoryH, factoryM]});
            WatchUi.pushView(picker, new HeureMenuPickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
            
        } else if (id == :bucketRate) {
            // NumberPicker pour le bucket rate (nombre entier de 1 à 99)
            var bucketRateActuel = Application.Properties.getValue("bucketRate");
            if (bucketRateActuel == null) { bucketRateActuel = 7.0; }
            
            var title = new WatchUi.Text({
                :text => "Bucket Rate",
                :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                :locY => WatchUi.LAYOUT_VALIGN_BOTTOM,
                :color => Graphics.COLOR_WHITE
            });
            
            var factoryDizaines = new BucketDizainesFactory();
            var factoryUnites = new BucketUnitesFactory();
            
            var picker = new WatchUi.Picker({
                :title => title, 
                :pattern => [factoryDizaines, factoryUnites]
            });
            
            WatchUi.pushView(picker, new BucketRateNumberPickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
            
        } else if (id == :start) {
            // Démarrer l'activité avec les paramètres configurés
            var view = new BucketRateView();
            var delegate = new BucketRateDelegate();
            WatchUi.switchToView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
        }
    }
    
    function onBack() as Void {
        // Quitter complètement l'application
        System.exit();
    }
    
}

// Delegates pour les TextPickers
class SalaireTextDelegate extends WatchUi.TextPickerDelegate {
    function initialize() {
        TextPickerDelegate.initialize();
    }
    
    function onTextEntered(text as String, changed as Boolean) as Boolean {
        if (changed) {
            try {
                var salaire = text.toFloat();
                if (salaire != null && salaire > 0) {
                    Application.Properties.setValue("salaire", salaire);
                }
            } catch (e) {
                // Ignorer les erreurs de conversion
            }
        }
        // Rafraîchir le menu
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        refreshMenuAfterChange();
        return true;
    }
}

// Delegate pour le salaire avec NumberPicker
class SalaireNumberPickerDelegate extends WatchUi.PickerDelegate {
    function initialize() {
        PickerDelegate.initialize();
    }
    
    function onAccept(values as Array) as Boolean {
        // values[0] = dizaines, values[1] = unités, values[2] = point, values[3] = décimales
        var dizaines = values[0] as Number;
        var unites = values[1] as Number;
        var decimales = values[3] as Number;
        
        // Calculer le salaire : dizaines * 10 + unités + décimales / 10
        var salaire = (dizaines * 10.0) + unites.toFloat() + (decimales.toFloat() / 10.0);
        
        Application.Properties.setValue("salaire", salaire);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        refreshMenuAfterChange();
        return true;
    }
    
    function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}

// Delegate pour le bucket rate avec NumberPicker
class BucketRateNumberPickerDelegate extends WatchUi.PickerDelegate {
    function initialize() {
        PickerDelegate.initialize();
    }
    
    function onAccept(values as Array) as Boolean {
        // values[0] = dizaines, values[1] = unités
        var dizaines = values[0] as Number;
        var unites = values[1] as Number;
        
        // Calculer le bucket rate : dizaines * 10 + unités
        var bucketRate = (dizaines * 10) + unites;
        
        // Éviter le 0
        if (bucketRate == 0) {
            bucketRate = 1;
        }
        
        Application.Properties.setValue("bucketRate", bucketRate.toFloat());
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        refreshMenuAfterChange();
        return true;
    }
    
    function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}

class BucketRateTextDelegate extends WatchUi.TextPickerDelegate {
    function initialize() {
        TextPickerDelegate.initialize();
    }
    
    function onTextEntered(text as String, changed as Boolean) as Boolean {
        if (changed) {
            try {
                var bucketRate = text.toFloat();
                if (bucketRate != null && bucketRate > 0) {
                    Application.Properties.setValue("bucketRate", bucketRate);
                }
            } catch (e) {
                // Ignorer les erreurs de conversion
            }
        }
        // Rafraîchir le menu
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        refreshMenuAfterChange();
        return true;
    }
}

function refreshMenuAfterChange() as Void {
    // Demander une mise à jour de l'affichage
    WatchUi.requestUpdate();
}

// ========== FACTORIES POUR LE SALAIRE (XX.X format) ==========

// Dizaines (0-9)
class ChiffreDizainesFactory extends WatchUi.PickerFactory {
    function initialize() {
        PickerFactory.initialize();
    }
    
    function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({
            :text => index.toString(),
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_NUMBER_HOT,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
    
    function getValue(index as Number) as Object or Null {
        return index;
    }
    
    function getSize() as Number {
        return 10; // 0-9
    }
    
    function getIndex(value as Object) as Number {
        var salaire = Application.Properties.getValue("salaire");
        if (salaire != null) {
            return (salaire.toNumber() / 10) % 10;
        }
        return 2; // Par défaut 2 (pour 25)
    }
}

// Unités (0-9)
class ChiffreUnitesFactory extends WatchUi.PickerFactory {
    function initialize() {
        PickerFactory.initialize();
    }
    
    function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({
            :text => index.toString(),
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_NUMBER_HOT,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
    
    function getValue(index as Number) as Object or Null {
        return index;
    }
    
    function getSize() as Number {
        return 10; // 0-9
    }
    
    function getIndex(value as Object) as Number {
        var salaire = Application.Properties.getValue("salaire");
        if (salaire != null) {
            return salaire.toNumber() % 10;
        }
        return 5; // Par défaut 5 (pour 25)
    }
}

// Point décimal (juste un ".")
class PointFactory extends WatchUi.PickerFactory {
    function initialize() {
        PickerFactory.initialize();
    }
    
    function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({
            :text => ".",
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_NUMBER_HOT,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
    
    function getValue(index as Number) as Object or Null {
        return 0;
    }
    
    function getSize() as Number {
        return 1;
    }
    
    function getIndex(value as Object) as Number {
        return 0;
    }
}

// Décimales (0-9)
class ChiffreDecimalesFactory extends WatchUi.PickerFactory {
    function initialize() {
        PickerFactory.initialize();
    }
    
    function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({
            :text => index.toString(),
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_NUMBER_HOT,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
    
    function getValue(index as Number) as Object or Null {
        return index;
    }
    
    function getSize() as Number {
        return 10; // 0-9
    }
    
    function getIndex(value as Object) as Number {
        var salaire = Application.Properties.getValue("salaire");
        if (salaire != null) {
            var decimales = ((salaire * 10).toNumber()) % 10;
            return decimales;
        }
        return 0; // Par défaut .0
    }
}

// ========== FACTORIES POUR LE BUCKET RATE (XX format) ==========

// Dizaines pour bucket rate (0-9)
class BucketDizainesFactory extends WatchUi.PickerFactory {
    function initialize() {
        PickerFactory.initialize();
    }
    
    function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({
            :text => index.toString(),
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_NUMBER_HOT,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
    
    function getValue(index as Number) as Object or Null {
        return index;
    }
    
    function getSize() as Number {
        return 10; // 0-9
    }
    
    function getIndex(value as Object) as Number {
        var bucketRate = Application.Properties.getValue("bucketRate");
        if (bucketRate != null) {
            return (bucketRate.toNumber() / 10) % 10;
        }
        return 0; // Par défaut 0 (pour 07)
    }
}

// Unités pour bucket rate (0-9)
class BucketUnitesFactory extends WatchUi.PickerFactory {
    function initialize() {
        PickerFactory.initialize();
    }
    
    function getDrawable(index as Number, selected as Boolean) as Drawable? {
        return new WatchUi.Text({
            :text => index.toString(),
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_NUMBER_HOT,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
    
    function getValue(index as Number) as Object or Null {
        return index;
    }
    
    function getSize() as Number {
        return 10; // 0-9
    }
    
    function getIndex(value as Object) as Number {
        var bucketRate = Application.Properties.getValue("bucketRate");
        if (bucketRate != null) {
            return bucketRate.toNumber() % 10;
        }
        return 7; // Par défaut 7 (pour 07)
    }
}

// Delegates simplifiés pour revenir au menu après sélection
class SalairePickerDelegate extends WatchUi.PickerDelegate {
    function initialize() {
        PickerDelegate.initialize();
    }
    
    function onAccept(values as Array) as Boolean {
        var salaire = values[0] as Number;
        Application.Properties.setValue("salaire", salaire.toFloat());
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
    
    function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}

class HeureMenuPickerDelegate extends WatchUi.PickerDelegate {
    function initialize() {
        PickerDelegate.initialize();
    }
    
    function onAccept(values as Array) as Boolean {
        var heures = values[0] as Number;
        var minutes = values[1] as Number;
        var minutesTotales = (heures * 60) + minutes;
        Application.Properties.setValue("heureDepart", minutesTotales);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        refreshMenuAfterChange();
        return true;
    }
    
    function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}

class BucketRateMenuPickerDelegate extends WatchUi.PickerDelegate {
    function initialize() {
        PickerDelegate.initialize();
    }
    
    function onAccept(values as Array) as Boolean {
        var bucketRate = values[0] as Number;
        Application.Properties.setValue("bucketRate", bucketRate.toFloat());
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
    
    function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}