
<cfparam name="Attributes.SystemModule" default="">
<cfparam name="Attributes.DatabaseName" default="0">
<cfparam name="Attributes.MissionTable" default="">

<!--- check role --->
<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    Ref_SystemModuleDatabase
WHERE   SystemModule = '#Attributes.SystemModule#' 
</cfquery>
		
<cfif Check.recordcount eq "0">

   <cfquery name="System" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO  Ref_SystemModuleDatabase
	      (SystemModule, 
		  DatabaseName,
		  MissionTable) 		
	VALUES ('#Attributes.SystemModule#', 
		  	'#Attributes.DatabaseName#', 
		 	'#Attributes.MissionTable#') 
   </cfquery>
   
<cfelse> 
  
	  <cfquery name="System" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_SystemModuleDatabase
		SET  DatabaseName = '#Attributes.DatabaseName#',
		    MissionTable = '#Attributes.MissionTable#'
		WHERE   SystemModule = '#Attributes.SystemModule#' 
		</cfquery>
	
</cfif>