var AMIVAL = 3.15;
var AISVAL = 2.65;
var DIVAL = 10.0;

var totalFacture = 0.0;

function afficherFacture(prenom, nom, actes)
{
    totalFacture = 0.0;
    var text = "<html>\n";
    text +=
            "    <head>\n\
            <title>Facture</title>\n\
            <link rel='stylesheet' type='text/css' href='css/mystyle.css'/>\n\
         </head>\n\
         <body>\n";


    text += "Facture pour " + prenom + " " + nom + "<br/>";


    // Trouver l'adresse du patient
    var xmlDoc = loadXMLDoc("data/cabinetInfirmier.xml");
    var patients = xmlDoc.getElementsByTagName("patient");
    var i = 0;
    var found = false;

    while ((i < patients.length) && (!found)) {
        var patient = patients[i];
        var localNom = patient.getElementsByTagName("nom")[0].childNodes[0].nodeValue;
        var localPrenom = patient.getElementsByTagName("prÃ©nom")[0].childNodes[0].nodeValue;
        if ((nom === localNom) && (prenom === localPrenom)) {
            found = true;
        } else {
            i++;
        }
    }


    if (found) {
        text += "Adresse: ";
        // On rÃ©cupÃ¨re l'adresse du patient
        var adresse;
        adresse = patient.getElementsByTagName("adresse")[0];
        text += adresseToText(adresse);
        text += "<br/>";

        var nSS = "0";
        nss = patient.getElementsByTagName("numero")[0].childNodes[0].nodeValue;

        text += "NumÃ©ro de sÃ©curitÃ© sociale: " + nSS + "\n";
    }
    text += "<br/>";



    // Tableau rÃ©capitulatif des Actes et de leur tarif
    text += "<table border='1'  bgcolor='#CCCCCC'>";
    text += "<tr>";
    text += "<td> Type </td> <td> ClÃ© </td> <td> IntitulÃ© </td> <td> Coef </td> <td> Tarif </td>";
    text += "</tr>";

    var acteIds = actes.split(" ");
    for (var j = 0; j < acteIds.length; j++) {
        text += "<tr>";
        var acteId = acteIds[j];
        text += acteTable(acteId);
        text += "</tr>";
    }

    text += "<tr><td colspan='4'>Total</td><td>" + totalFacture + "</td></tr>\n";

    text += "</table>";


    text +=
            "    </body>\n\
    </html>\n";

    return text;
}

// Mise en forme d'un noeud adresse pour affichage en html
function adresseToText(adresse)
{
    var str = "";
    str += adresse.getElementsByTagName("numéro")[0].childNodes[0].nodeValue + " ";
    str += adresse.getElementsByTagName("rue")[0].childNodes[0].nodeValue + " ";
    str += adresse.getElementsByTagName("codePostal")[0].childNodes[0].nodeValue + " ";
    str += adresse.getElementsByTagName("ville")[0].childNodes[0].nodeValue;
    return str;
}


function acteTable(acteId)
{
    var str = "";

    var xmlDoc = loadXMLDoc("data/actes.xml");
    var actes;
    actes = xmlDoc.getElementsByTagName("acte");

    // ClÃ© de l'acte (3 lettres)
    var cle;
    // Coef de l'acte (nombre)
    var coef;
    // Type id pour pouvoir rÃ©cupÃ©rer la chaÃ®ne de caractÃ¨res du type 
    //  dans les sous-Ã©lÃ©ments de types
    var typeId;
    // ChaÃ®ne de caractÃ¨re du type
    var type = "";
    // ...
    // IntitulÃ© de l'acte
    var intitule;

    // Tarif = (lettre-clÃ©)xcoefficient (utiliser les constantes 
    // var AMIVAL = 3.15; var AISVAL = 2.65; et var DIVAL = 10.0;)
    // (cf  http://www.infirmiers.com/votre-carriere/ide-liberale/la-cotation-des-actes-ou-comment-utiliser-la-nomenclature.html)      
    var tarif = 0.0;

    // Trouver l'acte qui correspond
    var i = 0;
    var found = false;
    var acte;
// Parcourir la liste des actes jusqu'à ce que l'acte soit trouvé ou que la fin soit atteinte
    while ((i < actes.length) && (!found)) {

        // Récupérer l'acte courant dans la liste
        var acteCourant = actes[i];

        // Récupérer l'identifiant de l'acte courant
        var idActeCourant = acteCourant.getAttribute("id");

        // Vérifier si l'identifiant de l'acte courant correspond à celui recherché
        if (acteId === idActeCourant) {

            // L'acte a été trouvé, assigner l'acte courant à la variable acte
            acte = acteCourant;
            found = true;
        } else {

            // Passer à l'acte suivant dans la liste
            i++;
        }


        if (found) {
            // recuperer la clé de l'acte
            cle = acte.getAttribut("cle");
            
            //recuperer le coeficient de 'acte
            coef = parseFloat(acte.getAttribut("coef"));
            
            //récuperer le type de l'acte
            typeId = acte.getAttribute("type");
            
//        type = ;
            //récuperer l'intitulé de l'acte
            intitule = acte.innerText;
            ///tarif = (cle.charCodeAt(0) * coef)
            //calculer le tarif selon la clé
            switch (cle) {
                case "AMI":
                    tarif = AMIVAL * coef;
                    break;
                case "AIS":
                    tarif = AISVAL * coef;
                    break;
                case "DI":
                    tarif = DIVAL * coef;
                    break;
                default:
                    break;
            }
        }

        // A modifier
        str += "<td>" + cle + "</td>";
        str += "<td>" + coef + "</td>";
        str += "<td>" + typeId + "</td>";
        str += "<td>" + type + "</td>";
        str += "<td>" + tarif + "</td>";
        totalFacture += tarif;

        return str;
    }

}

// Fonction qui charge un document XML
function loadXMLDoc(docName)
{
    var xmlhttp;
    if (window.XMLHttpRequest)
    {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp = new XMLHttpRequest();
    } else
    {// code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    xmlhttp.open("GET", docName, false);
    xmlhttp.send();
    xmlDoc = xmlhttp.responseXML;

    return xmlDoc;
}
