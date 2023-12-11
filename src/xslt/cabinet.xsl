<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : cabinet.xsl
    Created on : 20 novembre 2023, 13:45
    Author     : Rahmani Imen & Badzi Amine
    Description: Ce fichier corespond au xslt du cabinet qui permetras d'obtenir une page html qui afficheras pour un infirmier choisis:
                 -Le nombre de patients qu'il à sous sa charge aujourd'hui
                 -Les informations de chaque patient 
                 -Un bouton de facturation pour chaque patient
        
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:vs="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes">
    <xsl:output method="html"/>


    <!-- Charger le fichier actes.xml en tant que variable -->
    <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>

    
    
    <!--template principale-->
    <xsl:template match="/">
        
        <html>
            
            <head>
                
                <title>pageInfermier</title>
                
                <!--Lien vers le fichier css--> 
                <link rel="stylesheet" type="text/css" href="../css/cabinet.css" />
                
                <script>
                    function openWindow(){
                    window.open("","Facture","width=400,heigth=400");
                    }
                </script>
                
                <!--Lien vers le javaScript du bouton-->
                <script type="text/javascript" src="../js/facture.js"></script>
                
                <script type="text/javascript">
                    function openFacture(prenom, nom, actes) {
                    var width  = 500;
                    var height = 300;
                    if(window.innerWidth) {
                    var left = (window.innerWidth-width)/2;
                    var top = (window.innerHeight-height)/2;
                    }
                    else {
                    var left = (document.body.clientWidth-width)/2;
                    var top = (document.body.clientHeight-height)/2;
                    }
                    var factureWindow = window.open('','facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+'');
                    factureText = afficherFacture(prenom, nom, actes);
                    factureWindow.document.write(factureText);
                    }
                </script>
                
            </head>
            
            <body>
                
                <!--Appliquer la template a l'infirmier avec l'id 001-->
                <xsl:apply-templates select="//vs:infirmier[@id='001']"/>
                
            </body>
            
        </html>
        
    </xsl:template>


    <!--template des infirmiers-->
    <xsl:template match="vs:infirmier">
        
        
        <!--Message de salutation qui récupére le nom de l'infirmier-->
        <h1>Bonjour <xsl:value-of select="vs:prenom" /> !</h1>
        
        
        <!--Variable qui permet de compter le nombre de visites de l'infirmier pour la journée-->
        <xsl:variable name="visitesDuJour" select="//vs:visite[@intervenant=current()/@id]" />
        
        
        
        <p>Aujourd'hui, vous avez <xsl:value-of select="count($visitesDuJour)"/> patients</p>


        <!--Création d'un tableau pour afficher les informations des patient-->
        <table border="1">
            
            
             
            <tr>
                
                <th>Nom</th>
                <th>Prenom</th>
                <th>Adresse</th>
                <th>Numéro de sécurité sociale</th>
                <th>Liste des soins à effectuer</th>
                <th>Facture</th>
                
            </tr>
            
            
        
        
            <!-- Appliquer la template pour chaque patient -->
            <xsl:apply-templates select="//vs:patient[vs:visite/@intervenant=current()/@id]"/>
            
            
        
        </table>


    </xsl:template>




    <!--Appliquer la template pour chaque patient-->
    <xsl:template match="vs:patient">
        
        
        
        <tr>
            
            <!--Afficher les informations de chaque patient-->
            <td>
                <xsl:value-of select="vs:nom"/>
            </td>
            
            
            <td>
                <xsl:value-of select="vs:prenom"/>
            </td>
            
            
            <td>
                <xsl:value-of select="vs:adresse" />
            </td>
            
            
            <td>
                <xsl:value-of select="vs:numero" />
            </td>
            
            
            <td>
                <xsl:apply-templates select="$actes/act:actes/act:acte[@id=current()/vs:visite/vs:acte/@id]"/>
            </td>
            
            <td>
                
                <!--Bouton de facturation avec appel à la fonction JavaScript openFacture -->
                <button onclick="openFacture()">
                    
                    <!-- Ajouter l'attribut onclick avec les paramètres nécessaires -->
                    <xsl:attribute name="onclick">
                        
                        openFacture("<xsl:value-of select="vs:prenom"/>","<xsl:value-of select="vs:nom"/>")
                    </xsl:attribute>
                    
                    Facture
                    
                </button>
                
            </td>
            
            
        </tr>
        
        
    </xsl:template>
    
    
    
    
    
    <!--Template pour les actes médicaux-->
    <xsl:template match="act:acte">
   
        <li>
            
            <xsl:value-of select="./text()"/>
            
        </li>
        
    </xsl:template>
    
 

</xsl:stylesheet>