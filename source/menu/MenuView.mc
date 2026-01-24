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
    
    // Appelé quand la vue redevient visible (après retour d'un picker)
    function onUpdate(dc as Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Fond noir
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        // Dessiner un indicateur vert sur le côté droit (position du bouton SELECT)
        // Cercle vert à droite au milieu de l'écran
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(width - 20, height / 2, 8);
        
        // Ajouter une flèche ou icône "play" dans le cercle
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon([
            [width - 23, height / 2 - 5],
            [width - 23, height / 2 + 5],
            [width - 15, height / 2]
        ]);
        
        // Le menu se dessine lui-même par-dessus
    }
    
    function showConfigMenu() as Void {
        // Créer le menu de configuration avec les valeurs actuelles
        menu = createConfigMenu();
        WatchUi.pushView(menu, new ConfigMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
    }
    
    // Créer le menu avec les valeurs actuelles
    function createConfigMenu() as WatchUi.Menu2 {
        var newMenu = new WatchUi.Menu2({:title => "Configuration"});
        
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
        newMenu.addItem(
            new WatchUi.MenuItem(
                "Salaire",
                salaire.format("%.2f") + " $/h",
                :salaire,
                {}
            )
        );
        
        newMenu.addItem(
            new WatchUi.MenuItem(
                "Heure début",
                heureStr,
                :heureDepart,
                {}
            )
        );
        
        newMenu.addItem(
            new WatchUi.MenuItem(
                "Bucket Rate",
                bucketRate.format("%.1f"),
                :bucketRate,
                {}
            )
        );
        
        // Ajouter l'élément pour démarrer
        newMenu.addItem(
            new WatchUi.MenuItem(
                "DEMARRER",
                "Lancer l'activite",
                :start,
                {}
            )
        );
        
        return newMenu;
    }
    
    function onHide() as Void {
    }
    
}