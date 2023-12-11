<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : patient_xml.xsl
    Created on : 23 novembre 2023, 15:22
    Author     : Rahmani Imen & Amine Badzi
    Description: ce fichier corespond au xslt qui serat apliqué sur le fichier cabinet.xml affin d'obtenir un fichier xml qui contiendras :
                 -Les informations du patient en question
                 -Un tableau qui regroupe les visites du patient
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:vs="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes"
                xmlns:xs="http://www.w3.org/2001/XMLSchema-instance"
                xmlns="http://www.ujf-grenoble.fr/l3miage/patient"
>
    <xsl:output method="xml" indent="yes"/>
    
    
    
    <!-- Charger le fichier actes.xml en tant que variable -->
    <xsl:variable name="actes" select="document('../xml/actes.xml')/act:ngap"/>
    
    
    
    <!--Paramètre pour spécifier le nom du patient-->
    <xsl:param name="destinedName" select="'Alécole'"/>
    
    
    
    <!--Variable pour les informations du patient-->   
    <xsl:variable name="notrePatient" select="//vs:cabinet/vs:patients/vs:patient[vs:nom=$destinedName]"/>
    
    
    
    <!--Templtale principale la transformation-->
    <xsl:template match="/">
        
        
        <patient>
          
            <xsl:attribute name="xs:schemaLocation">http://www.ujf-grenoble.fr/l3miage/patient ../xsd/patient.xsd</xsl:attribute>
            
            <!--Extraction et affichage des informations du patient-->
            <nom>
                <xsl:value-of select="$notrePatient/vs:nom"/>
            </nom>
          
            
            <prenom>
                <xsl:value-of select="$notrePatient/vs:prenom"/>
            </prenom>
            
            
            <sexe>
                <xsl:value-of select="$notrePatient/vs:sexe"/>
            </sexe>
            
            
            <naissance>
                <xsl:value-of select="$notrePatient/vs:naissance"/>
            </naissance>
            
            <numero>
                <xsl:value-of select="$notrePatient/vs:numero"/>
            </numero>
            
            
            <adresse>
                
                <numéro>
                    <xsl:value-of select="$notrePatient/vs:adresse/vs:numéro"/>
                </numéro>
                
                <rue>
                    <xsl:value-of select="$notrePatient/vs:adresse/vs:rue"/>
                </rue>
                
                <codePostal>
                    <xsl:value-of select="$notrePatient/vs:adresse/vs:codePostal"/>
                </codePostal>
                
                <ville>
                    <xsl:value-of select="$notrePatient/vs:adresse/vs:ville"/>
                </ville>

            </adresse>
            
            
            <!--Appliquer la template pour chaque visite du patient-->
            <xsl:apply-templates select="$notrePatient/vs:visite"/>
            
        </patient>
    
    </xsl:template>
    

    <xsl:template match="vs:patient">

        
        
    </xsl:template>
    <!--Template pour traiter chaque visite-->
    <xsl:template match="vs:visite">
        
    
        <visite date="{@date}">
            
            <!--extraction et affichage des informations l'intervenant-->
            <intervenant>
                
                <nom>
                    <xsl:value-of select="//vs:infirmiers/vs:infirmier[@id=current()/@intervenant]/vs:nom"/>
                </nom>
                
                <prenom>
                    <xsl:value-of select="//vs:infirmiers/vs:infirmier[@id=current()/@intervenant]/vs:prenom"/>
                </prenom>
                
            </intervenant>

            <!--Appliquer la template des actes sur chaque acte medical-->
            <xsl:apply-templates select="vs:acte"/>
                
            
        </visite>
        
        
    </xsl:template>
    
    
    
    <!--template pour traiter les actes medicaux-->
    <xsl:template match="vs:acte">
        
        <acte>
            
            <xsl:variable name="idActe" select="@id"/>
            <xsl:value-of select="$actes/act:actes/act:acte[@id=$idActe]/text()"/>
        
        </acte>
        
    </xsl:template>
    
</xsl:stylesheet>