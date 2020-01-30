
<cfparam name="attributes.entitycode"      default="">
<cfparam name="attributes.datasource"      default="AppsOrganization">
<cfparam name="attributes.objectkeyvalue1" default="">
<cfparam name="attributes.objectkeyvalue2" default="">
<cfparam name="attributes.objectkeyvalue3" default="">
<cfparam name="attributes.objectkeyvalue4" default="">
<cfparam name="attributes.objectId"        default="">
<cfparam name="attributes.Mode" 	       default="Close">

<cfquery name="Object" 
	datasource="#attributes.datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
			FROM   Organization.dbo.OrganizationObject
			
			<cfif (attributes.ObjectId neq "" or attributes.objectkeyvalue4 neq "") and attributes.EntityCode eq "">
			WHERE 1 = 1
			<cfelse>
			WHERE  EntityCode = '#attributes.entitycode#' 
			</cfif>
						
			<cfif attributes.objectkeyvalue1 neq "">
			AND    ObjectKeyValue1 = '#attributes.objectkeyvalue1#'
			</cfif>
			<cfif attributes.objectkeyvalue2 neq "">
			AND    ObjectKeyValue2 = '#attributes.objectkeyvalue2#'
			</cfif>
			<cfif attributes.objectkeyvalue3 neq "">
			AND    ObjectKeyValue3 = '#attributes.objectkeyvalue3#'
			</cfif>
			<cfif attributes.objectkeyvalue4 neq "">
			AND    ObjectKeyValue4 = '#attributes.objectkeyvalue4#'
			</cfif>
			<cfif attributes.objectId neq "">
			AND    ObjectId = '#attributes.objectId#'
			</cfif>			
			AND  Operational = 1
			
</cfquery>

<cfif Object.recordcount neq "1">

	<!--- do nothing there is no workflow to adjust --->

<cfelse>

	   <cfquery name="checkprocessed" 
		   datasource="#attributes.datasource#" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
				SELECT *
				FROM   OrganizationObjectAction
				WHERE  ObjectId = '#Object.ObjectId#'			   	   
				AND    ActionStatus != '0' 
	   </cfquery>  
	  	   
	   <cfif checkprocessed.recordcount gte "1">	
	   					
			  <!--- deactivate the workflow and remove the steps --->
				
			  <cfquery name="RemoveUnprocessedAction" 
				   datasource="#attributes.datasource#" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
						DELETE FROM OrganizationObjectAction
						WHERE  ObjectId = '#Object.ObjectId#'			   	   
						AND    ActionStatus = '0' 
			  </cfquery>   	
			
			  <cfif attributes.mode eq "recreate">
			  
			  	 <!--- Setting operational 0 associated workflows --->
				 
				  <cfquery name="DisableWkf" 
				   datasource="#attributes.datasource#" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
						UPDATE OrganizationObject
						SET    Operational    = '0'
						WHERE  ObjectId = '#Object.ObjectId#'			   	   
				  </cfquery>   
			
				  <!--- trigger a new workflow --->
			
					<cf_ActionListing 
					    EntityCode       = "#Object.EntityCode#"	
						EntityClass      = "#Object.EntityClass#"			
						EntityGroup      = "#Object.EntityGroup#"				
						Owner            = "#Object.Owner#"
						Mission          = "#Object.Mission#"
						OrgUnit          = "#Object.OrgUnit#"
						EntityStatus     = ""	
						PersonNo         = "#Object.PersonNo#"
						PersonEMail      = "#Object.PersonEMail#"
						ProgramCode      = "#Object.ProgramCode#"
						ObjectReference  = "#Object.ObjectReference#"
						ObjectReference2 = "#Object.ObjectReference2#"
						ObjectFilter     = "#Object.ObjectFilter#"
					    ObjectKey1       = "#Object.ObjectKeyValue1#"
						ObjectKey2       = "#Object.ObjectKeyValue2#"
						ObjectKey3       = "#Object.ObjectKeyValue3#"
						ObjectKey4       = "#Object.ObjectKeyValue4#"				
						Show             = "no"				
						CompleteCurrent  = "Yes"
						ObjectURL        = "#Object.ObjectURL#">		
					
			  </cfif>
		  
		</cfif>
	
</cfif>
