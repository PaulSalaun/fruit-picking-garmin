import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Application;

class MenuView extends WatchUi.View {
    private var menu as WatchUi.Menu2?;
    
    function initialize() {
        View.initialize();
    }
    
    function onLayout(dc as Dc) as Void {
    }
    
    function onShow() as Void {
        showConfigMenu();
    }
    
    function showConfigMenu() as Void {
        // Créer le menu de configuration
        menu = new WatchUi.Menu2({:title => "Configuration"});
        
        // Récupérer les valeurs actuelles
        var salaire = Application.Properties.getValue("salaire");
        var heureDepart = Application.Properties.getValue("heureDepart");
        var bucketRate = Application.Properties.getValue("bucketRate");
        
        // Valeurs par défaut
        if (salaire == null) { 
            salaire = 25.0; 
            Application.Properties.setValue("salaire", salaire);
        }
        if (heureDepart == null) { 
            heureDepart = 420; 
            Application.Properties.setValue("heureDepart", heureDepart);
        }
        if (bucketRate == null) { 
            bucketRate = 7.0; 
            Application.Properties.setValue("bucketRate", bucketRate);
        }
        
        // Formatter l'heure
        var heures = heureDepart / 60;
        var minutes = heureDepart % 60;
        var heureStr = heures.format("%02d") + ":" + minutes.format("%02d");
        
        // Ajouter les items au menu avec les valeurs actuelles
        menu.addItem(
            new WatchUi.MenuItem(
                "Salaire",
                salaire.format("%.2f") + " $/h",
                :salaire,
                {}
            )
        );
        
        menu.addItem(
            new WatchUi.MenuItem(
                "Heure début",
                heureStr,
                :heureDepart,
                {}
            )
        );
        
        menu.addItem(
            new WatchUi.MenuItem(
                "Bucket Rate",
                bucketRate.format("%.1f"),
                :bucketRate,
                {}
            )
        );
        
        menu.addItem(
            new WatchUi.MenuItem(
                "Démarrer",
                "",
                :start,
                {}
            )
        );
        
        WatchUi.pushView(menu, new ConfigMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
    }
    
    function onUpdate(dc as Dc) as Void {       
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
    }
    
    function onHide() as Void {
    }
    
}