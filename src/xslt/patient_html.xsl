<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : patient_xml.xsl
    Created on : 15 novembre 2023, 21:53
    Author     : Rahmani Imen & Amine Badzi
    Description: ce fichier corespond au xslt qui permetteras de produire une page html en l'apliquant sur patient_xml.xsl

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:vs="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes"
                xmlns:pat="http://www.ujf-grenoble.fr/l3miage/patient">

    <xsl:output method="html"/>
    
    <!-- Charger le fichier actes.xml en tant que variable -->
    <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>

    
    
    <!--Template principale pour la transformation -->
    <xsl:template match="/">
        
        <html>
            
            <head>
                
                <title>Fiche Patient</title>
                
                <!--Lien vers le fichier CSS-->
                <link rel="stylesheet" type="text/css" href="../css/cabinet.css" />
                
            </head>
            
            
            
            <body>
                
                <h1>Fiche Patient</h1>
                
                <!--Application de la template sur chaque patient-->
                <xsl:apply-templates select="//pat:patient"/>
                
            </body>
            
        </html>
        
    </xsl:template>
    
    
    
    <!--Template pour le patient-->
    <xsl:template match="pat:patient">
        
        <!--Afficher les informations du patient-->
        
        
        <p>Nome : <xsl:value-of select="pat:nom"/></p>
        
        <p>Prénom : <xsl:value-of select="pat:prenom"/></p>
        
        <p>sexe : <xsl:value-of select="pat:sexe"/></p>
        
        <p>Naissance : <xsl:value-of select="pat:naissance"/></p>
        
        <p>Numero de sécurite scociale : <xsl:value-of select="pat:numero"/></p>
        
        <p>Adresse : <xsl:apply-templates select="pat:adresse" mode="stringify"/></p>
        
        
        
        <!--tableau des visites-->
        <table border="1">
            
            <tr>
                
                <th>Visites</th>
                <th>Intervenant</th>
                <th>libellé des actes</th>
                
            </tr>
            
            <!--Application du template pour chaque visite--> 
            <xsl:apply-templates select="pat:visite"/>
            
        </table>
        
    </xsl:template>
    
    <!--La template pour soigner l'affichage de l'adresse-->
    <xsl:template match="pat:adresse" mode="stringify">
        
        
        <!-- Concaténer les éléments de l'adresse -->
       
        <xsl:value-of select="pat:numéro"/>
        <xsl:text> </xsl:text>
        
        <xsl:value-of select="pat:rue"/>
        <xsl:text> </xsl:text>
        
        <xsl:value-of select="pat:ville"/>
        <xsl:text> </xsl:text>
        
        <xsl:value-of select="pat:codePostal"/>

                
    </xsl:template>
    
    
    
    
    <!--Template pour chaque visite-->
    <xsl:template match="pat:visite">
        
        <tr>
            
            <!--Afficher la date de la visite--> 
            <td>
                <xsl:value-of select="@date"/>
            </td>
            
            
            <!--Afficher les informations de l'intervenant-->
            <td>
                
                <xsl:value-of select="pat:intervenant/pat:nom"/>
                
                <xsl:text> </xsl:text>
                
                <xsl:value-of select="pat:intervenant/pat:prenom"/>
                
            </td>
            
            
            <!--Afficher les actes médicaux--> 
            <td>
                
                <xsl:for-each select="current()/pat:acte">
                    <li>
                        <xsl:value-of select="text()"/>
                        <br/> <!-- Insérer un saut de ligne après chaque acte -->
                    </li>
                </xsl:for-each>
                
            </td>
            
        </tr>
        
    </xsl:template>
    


</xsl:stylesheet>
