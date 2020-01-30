
<cfparam name="URL.TransactionType" default="Distribution">


<!--- INIT GLOBAL VARIABLES --->
<cfset vOrientation = "landscape">
<cfset vHeight = "5">
<cfset vWidth  = "50">


<cfif vOrientation eq "landscape">
	<cfset vMargin = "0.5">
	<cfset vG_Width = "222">
	<cfset vG_Height = "220">	
	<cfset vSlogan = FALSE>
	<cfset vHeaderAt = "10">		
	<cfset vRowAt ="30">	
	<cfset vTotalRows = 30>	
<cfelse>
	<cfset vMargin = "4.0">
	<cfset vG_Width = "200">
	<cfset vG_Height = "266">	
	<cfset vSlogan = TRUE>	
	<cfset vHeaderAt = "30">	
	<cfset vRowAt ="45">
	<cfset vTotalRows = 35>	
</cfif>
	


<cfif CGI.HTTP_HOST eq "www.promisan.net" or CGI.HTTP_HOST eq "dev01" or CGI.HTTP_HOST eq "www.prosismedia.com">
	<cfset vMission = "MINUSTAH">
	<cfset vCategory ="POL">
<cfelse>
	<cfset vMission = "MINUSTAH">
	<cfset vCategory ="FUEL">
</cfif>





<cfquery name = "qMandate" datasource="AppsOrganization">
	SELECT TOP 1 MandateNo
	FROM Ref_Mandate
	WHERE Mission = '#vMission#'
	ORDER BY DateExpiration DESC
</cfquery>

<cfquery name = "qWarehouses" datasource = "AppsMaterials">
	SELECT Warehouse,WarehouseName,MissionOrgUnitId
	FROM Warehouse
	WHERE Mission = '#vMission#'
	<!---
	AND City = 'Port au prince'	
	--->
</cfquery>



<cfloop query = "qWarehouses">

<cfoutput>
<cfsavecontent variable="vcontent"><?xml version="1.0" encoding="UTF-8"?>
<?xfa generator="ProsisFormGenerator" APIVersion="3.1.20001.0"?>
<xdp:xdp xmlns:xdp="http://ns.adobe.com/xdp/" timeStamp="2011-06-13T19:20:59Z" uuid="481f6d9f-326b-458d-a343-71c3089121ac">
<template xmlns="http://www.xfa.org/schema/xfa-template/2.6/">
   <?formServer defaultPDFRenderFormat acrobat8.1static?>
   <subform name="form1" layout="tb" locale="en_US" restoreState="auto">
   
      <pageSet>
         <pageArea name="Page1" id="Page1">
	            <contentArea x="#vMargin#mm" y="#vMargin#mm" w="#vG_Width#mm" h="#vG_Height#mm" id="contentArea_ID"/>
	            <medium stock="letter" short="215.9mm" long="#vG_Height#mm" orientation="#vOrientation#"/>
    	        <?templateDesigner expand 1?>
		</pageArea>
        <?templateDesigner expand 0?>
	  </pageSet>

      <subform w="#vG_Width#mm" h="#vG_Height#mm" name="Transaction_Logsheet">
		 
		 <cfinclude template = "Title.cfm">	

         <break overflowTarget="Page1.##contentArea"/>
		 
 		 <cfset x = vMargin + (vG_Width/2-(vWidth*3)/2) >

		 <subform name="Table0" layout="table" columnWidths="#vWidth#mm #vWidth*2#mm" y="#vHeaderAt#mm" x = "#x#mm">
		 	<cfinclude template = "HeaderTable.cfm">		 
		 </subform>
		 

		 
		 <cfset vXSmall  ="7">
 		 <cfset vSmall   ="10">
		 <cfset vMedium  ="18">
		 <cfset vLarge   ="30"> 
		 
		<cfif URL.TransactionType eq "Distribution">
	  		 <cfset x = vMargin + (vG_Width/2-(vXSmall+vMedium+vMedium+vMedium+vMedium+vMedium+vLarge+vLarge+vMedium+vMedium)/2) >
    	     <subform name="Table1" layout="table" columnWidths="#vXSmall#mm #vMedium#mm #vMedium#mm #vMedium#mm #vMedium#mm #vMedium#mm #vLarge#mm #vLarge#mm #vMedium#mm #vMedium#mm" y="#vRowAt#mm" x = "#x#mm">
		<cfelse>
	  		 <cfset x = vMargin + (vG_Width/2-(vXSmall+vMedium+vMedium+vMedium+vMedium+vLarge+vMedium+vLarge+vMedium+vMedium)/2) >
    	     <subform name="Table1" layout="table" columnWidths="#vXSmall#mm #vMedium#mm #vLarge*2#mm #vLarge*2#mm #vLarge#mm #vMedium#mm" y="#vRowAt#mm" x = "#x#mm">
		</cfif>			 
            <border>
               <edge/>
            </border>
	            <subform layout="row" name="HeaderRow">
					<cfinclude template = "HeaderRow#URL.TransactionType#.cfm">
				</subform>
					<cfset vCount = 0>
					<cfloop condition = "vCount lt #vTotalRows#"> 
						<cfset vCount = vCount + 1>
			            <subform layout="row" name="Row#vCount#">
							<cfinclude template = "Row#URL.TransactionType#.cfm">
						</subform>
					</cfloop>
					<cfset vCount = vCount + 1>
					
					<subform layout = "row" name="Row#vCount#">
						<cfinclude template = "Total#URL.TransactionType#.cfm">					
					</subform>
					
    	        <keep intact="contentArea"/>
            <?templateDesigner rowpattern first:1, next:1, firstcolor:f0f0f0, nextcolor:ffffff, apply:1?>
            <?templateDesigner expand 1?>
		</subform>
         <?templateDesigner expand 1?>
	 </subform>
      <proto/>
      <desc>
         <text name="version">8.2.1.4029.1.523496.503679</text>
      </desc>
      <?templateDesigner expand 1?>
	  
	  </subform>
   <?templateDesigner DefaultLanguage FormCalc?>
   <?templateDesigner DefaultRunAt client?>
   <?acrobat JavaScript strictScoping?>
   <?templateDesigner Grid show:1, snap:1, units:0, color:ff8080, origin:(0,0), interval:(125000,125000)?>
   <?templateDesigner SavePDFWithLog 0?>
   <?templateDesigner XDPPreviewFormat 20?>
   <?templateDesigner FormTargetVersion 26?>
   <?templateDesigner Zoom 172?>
   <?templateDesigner SaveTaggedPDF 0?>
   <?templateDesigner SavePDFWithEmbeddedFonts 0?>
   <?templateDesigner Rulers horizontal:1, vertical:1, guidelines:1, crosshairs:0?></template>

<cfinclude template="Config.cfm">
<cfinclude template="LocalSet.cfm">
<cfinclude template="Meta.cfm">
<xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve">
   <annots/>
</xfdf></xdp:xdp></cfsavecontent>
</cfoutput>

<cfif not DirectoryExists("#SESSION.rootPath#\CFRStage\user\administrator\xdp\#URL.TransactionType#\")>
		<cftry>
			 <cfdirectory action="CREATE" 
	         directory="#SESSION.rootPath#\CFRStage\user\administrator\xdp\#URL.TransactionType#\">
		<cfcatch></cfcatch>
		</cftry>
</cfif>

<cfset fname = "#URL.TransactionType#_#Warehouse#.xdp">
<cffile action="Write" output = "#vcontent#" file = "#SESSION.rootPath#\CFRStage\user\administrator\xdp\#URL.TransactionType#\#fname#">


<cfoutput>
#WarehouseName# - #SESSION.rootPath#\CFRStage\user\administrator\xdp\#URL.TransactionType#\#fname#
<br>
<br>
</cfoutput>


</cfloop>