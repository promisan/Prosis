
<cfparam name="URL.Mission"            default="">
<cfparam name="URL.AssetId"            default="1749FB2F-1018-0668-4307-088E310A0F4F">
<cfparam name="URL.observationclass"   default="Observation">
<cfparam name="URL.context"            default="status">
<cfparam name="URL.contextid"          default="">

<!---
<cfoutput>
	
	<script>
	
		function addObservation(context,oclass) {			
		    w = #CLIENT.width# - 120;
		    h = #CLIENT.height# - 160;				
			window.open("#SESSION.root#/Warehouse/Application/Asset/Observation/DocumentEntry.cfm?observationclass=" + oclass + "&context=" + context + "&ts="+new Date().getTime(), "amendment", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");		
		}
				
	</script>	

</cfoutput>

<cf_ListingScript>
--->

<cfquery name="Entity" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM    Ref_Entity
  WHERE   EntityCode  = 'AssObservation'
</cfquery>
  
<cfquery name="Parameter" 
	datasource="appsSystem">
	SELECT   *
    FROM     Parameter
</cfquery>

<cfset currrow = 0>

<!--- open access for observation in case of observation mode --->

<cfoutput>
	
	<cfswitch expression="#URL.context#">
	
	    <cfcase value="View">		
		
			<cfsavecontent variable="myquery">			
		
		     SELECT   Org.OrgUnitName,
					  A.AssetId,
			 		  A.Make, 
			          A.Model, 
					  A.Description as Descriptive, 					  
			          O.ObservationId,				     
					  R.Description, 
				      RO.Description AS ObservationName, 
					  <!--- left(ObservationMemo,200) as ObservationMemo, --->
					  O.ActionStatus,
					  RS.StatusDescription,
					  O.ObservationDate, 
					  O.ObservationPriority, 
					  O.OfficerUserId, 
					  O.OfficerLastName, 
					  O.OfficerFirstName, 
                      O.Created
			 FROM     AssetItem A 
			          INNER JOIN  skAssetItem sk ON A.AssetId = sk.AssetId 
					  INNER JOIN  Organization.dbo.Organization Org ON sk.OrgUnit = Org.OrgUnit	
					  
					  INNER JOIN  AssetItemObservation O ON A.AssetId = O.AssetId
					  INNER JOIN  Ref_AssetAction R ON O.ActionCategory = R.Code 
					  INNER JOIN  Ref_AssetActionCategoryWorkflow RO ON O.ActionCategory = RO.ActionCategory AND O.Category = RO.Category AND O.Observation = RO.Code			  									         
					  INNER JOIN Organization.dbo.Ref_EntityStatus RS ON RS.EntityCode = 'AssObservation' AND RS.EntityStatus = O.ActionStatus 
					  
			WHERE     O.ObservationClass = '#url.observationclass#'		 
				<cfif url.contextid neq "">		 
				AND      O.ActionStatus = '#URL.contextid#'											
				</cfif>
				AND      A.Mission = '#url.Mission#' 	
				
			</cfsavecontent>					  
				
		</cfcase>
	
		<cfcase value="status">
		
			<cfsavecontent variable="myquery">					
			
			    SELECT    O.ObservationId,
				          O.AssetId,
						  R.Description, 
				          RO.Description AS ObservationName, 
						  left(ObservationMemo,200) as ObservationMemo,
						  O.ActionStatus,
						  RS.StatusDescription,
						  O.ObservationDate, 
						  O.ObservationPriority, 
						  O.OfficerUserId, O.OfficerLastName, O.OfficerFirstName, 
                          O.Created
				FROM      AssetItemObservation O 
				          INNER JOIN  Ref_AssetAction R ON O.ActionCategory = R.Code 
						  INNER JOIN  Ref_AssetActionCategoryWorkflow RO ON O.ActionCategory = RO.ActionCategory AND O.Category = RO.Category AND O.Observation = RO.Code			  									         
						  INNER JOIN Organization.dbo.Ref_EntityStatus RS ON RS.EntityCode = 'AssObservation' AND RS.EntityStatus = O.ActionStatus 
						 
				WHERE     ObservationClass = '#url.observationclass#'		 
				<cfif url.contextid neq "">		 
				AND      O.ActionStatus = '#URL.contextid#'											
				</cfif>
				AND      O.AssetId = '#url.AssetId#' 				
				
			</cfsavecontent>	
			
		</cfcase>
					
	</cfswitch>

</cfoutput>

		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "Action",                  
					field         = "Description",
					alias         = "R",
					filtermode    = "2",
					search        = "text"}>							
				
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Observation",                  
					field         = "ObservationName",	
					filtermode    = "2",				
					search        = "text"}>			
					
			
<cfset itm = itm+1>									
<cfset fields[itm] = {label       		= "Pr", 		
                      LabelFilter 		= "Priority",				
					  field       		= "ObservationPriority",					
					  filtermode  		= "2",    
					  search      		= "text",
					  align       		= "center",
					  formatted   		= "Rating",
					  ratinglist  		= "High=Red,Normal=Yellow,Low=Green"}>										
				
<cfset itm = itm+1>							
<cfset fields[itm] = {label       		= "Date",  					
					  field       		= "ObservationDate",
					  alias       		= "O",
					  search      		= "",
					  formatted   		= "dateformat(ObservationDate,'#CLIENT.DateFormatShow#')"}>										
					
<cfif url.context eq "view">
	
	<cfset itm = itm+1>						
	<cfset fields[itm] = {label         = "Unit",                  
						field           = "OrgUnitName",	
						alias           = "Org",							
						search          = "text"}>	
	
	<cfset itm = itm+1>						
	<cfset fields[itm] = {label         = "Make",                  
						field           = "Make",	
						alias           = "A",
						filtermode      = "2",				
						search          = "text"}>					
						
	<cfset itm = itm+1>						
	<cfset fields[itm] = {label         = "Model",                  
						field           = "Model",	
						alias           = "A",
						filtermode      = "2",				
						search          = "text"}>					
						
	<cfset itm = itm+1>						
	<cfset fields[itm] = {label         = "Descriptive",                  
						field           = "Descriptive",	
						functionscript  = "AssetDialog",
						functionfield   = "AssetId",
						alias           = "A",					
						search          = "text"}>		

<cfelse>
						
	<cfset itm = itm+1>						
	<cfset fields[itm] = {label         = "Briefs",                  
						  field         = "ObservationMemo",
						  searchfield   = "ObservationMemo",
						  width         = "110",
						  filtermode    = "0",
						  search        = "text"}>								
						  
</cfif>					  
						
<cfset itm = itm+1>						
<cfset fields[itm] = {label       		= "Status",	
                      field       		= "StatusDescription",		
                      alias       		= "RS",					  
					  filtermode  		= "2",
					  search      		= "text"}>						  
	
								  		
<cfif url.context eq "view">

<cfelse>
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       		= "Officer",	
                      alias       		= "O",				
					  field       		= "OfficerLastName"}>	
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       		= "Entered",  					
					  field       		= "Created",
					  alias       		= "O",
					  search      		= "",
					  formatted   		= "dateformat(Created,'#CLIENT.DateFormatShow#')"}>	
					  
</cfif>					  
					
			
	   
<cfset menu=ArrayNew(1)>	

   <cfif url.context eq "status">
   
       <!---
	   <cfquery name="SystemModule" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			   
			SELECT   *
			FROM     [#Parameter.databaseServer#].Organization.dbo.OrganizationAuthorization 
			WHERE    UserAccount  = '#SESSION.acc#' 
			AND      Role         = 'ModuleOfficer' 																				
		</cfquery>
				
		--->
      						
			<cfset menu[1] = {label = "New Observation", script = "addObservation('#url.context#','#url.observationclass#','#url.assetid#')"}>				 
			
		<!---	
		
		</cfif>
		
		--->	   
   	
   </cfif>				

	<cf_listing
	    header         = "Observation"
		menu           = "#menu#"
	    box            = "observation"
		link           = "#SESSION.root#/Warehouse/Application/Asset/Observation/ObservationViewListing.cfm?mission=#url.mission#&assetid=#url.assetid#&observationclass=#url.observationclass#&context=#url.context#&contextid=#url.contextid#"
	    html           = "No"
		show           = "40"
		datasource     = "AppsMaterials"
		listquery      = "#myquery#"		
		listorder      = "ActionStatus"
		listorderalias = "O"
		listorderdir   = "ASC"
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "Hide"
		excelShow      = "Yes"
		drillmode      = "window"	
		drillargument  = "900;1000;true;true"	
		drilltemplate  = "Warehouse/Application/Asset/Observation/DocumentView.cfm?drillid="
		drillkey       = "ObservationId"
		annotation     = "SysChange">
	