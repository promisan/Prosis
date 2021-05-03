
<!--- ------------------------------------------------------------------------------------- --->
<!--- this template pre-checkes if the workflow has an open action for user on the document --->
<!--- ------------------------------------------------------------------------------------- --->
<!--- steps are : a. define the active step and b. then define if user has access --------- --->
<!--- ------------------------------------------------------------------------------------- --->

<!--- Last step of the flow by retrieving the object --->

<cfparam name="Attributes.EntityCode"        default="">
<cfparam name="Attributes.ObjectKey1"        default="">
<cfparam name="Attributes.ObjectKey2"        default="">
<cfparam name="Attributes.ObjectKey3"        default="">
<cfparam name="Attributes.ObjectKey4"        default="">

<!--- put the pk of the entity in a variuable --->
<cfset condition = " AND O.EntityCode = '#Attributes.EntityCode#'">

<cfloop index="itm" from="1" to="4"> 
	 <cfset val = evaluate("Attributes.ObjectKey"&#itm#)>	
	 <cfif val neq "">
		<cfset condition = condition&" AND O.ObjectKeyValue#itm# = '#val#'">
	 </cfif>
</cfloop>

<cfquery name="Object" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM   OrganizationObject O 
 WHERE  O.Operational  = 1
        #preserveSingleQuotes(condition)# 
</cfquery>

<cfif Object.recordcount eq "0">

	<cfset caller.wfformaccess = "VIEW">

<cfelse>
	
	<!--- define the last step(s) that are due --->
	
	<cfquery name="Steps" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT    ActionId, ActionCode
		FROM      OrganizationObjectAction
		WHERE     ObjectId = '#Object.Objectid#' 
		AND       ActionStatus = '0' 
		AND       ActionFlowOrder =
		                        (
								 SELECT   MIN(ActionFlowOrder) AS FlowOrder
		                          FROM    OrganizationObjectAction 
		                          WHERE   ObjectId = '#Object.Objectid#' 
								  AND     ActionStatus = '0'
								)
	</cfquery>							
	
	<cfset caller.wfformaccess = "VIEW">
	
	<cfloop query="steps">
	
	<!--- now check if access exist for one of the active steps --->
	
		 	<cfinvoke component = "Service.Access"  
						method         =   "AccessEntity" 
						objectid       =   "#Object.ObjectId#"
						actioncode     =   "#ActionCode#" 
						mission        =   "#Object.mission#"
						orgunit        =   "#Object.OrgUnit#" 
						entitygroup    =   "#Object.EntityGroup#" 
						returnvariable =   "stepaccess">	
						
			<cfif stepaccess eq "EDIT" or stepaccess eq "ALL">		
				  <cfset caller.wfformaccess = "EDIT">
			</cfif>						
	
	</cfloop>	
	
</cfif>						 
