
<!--- disabled do not revert this back as it affect the token procesing
    <html><head><title>Workflow Object</title></head><body>
--->

<!---
<cftransaction isolation="read_uncommitted"> 
--->

<cfset candidate= "0">  <!--- can be removed --->

<cfparam name="url.id" default="{00000000-0000-0000-0000-000000000000}">

<cfparam name="Attributes.Datasource"        default="appsOrganization">
<cfparam name="Attributes.EntityCode"        default="">
<cfparam name="Attributes.EntityClass"       default="Standard">
<cfparam name="Attributes.EnforceWorkflow"   default="Yes">
<cfparam name="Attributes.Mission"           default="">
<cfparam name="Attributes.ProgramCode"       default="">

<cf_validateBrowser minIE="11">

<!--- ------------------------------- --->
<!--- ----define the correct flow---- --->
<!--- ------------------------------- --->

<cfquery name="Entity" 
 datasource="#attributes.Datasource#"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Organization.dbo.Ref_Entity 
	 WHERE    EntityCode     = '#Attributes.EntityCode#'  
</cfquery>

<cfif Entity.operational eq "0">
	<!--- workflow object has been disabled globally --->
	<table align="center"><tr><td class="labelmedium"><font color="FF0000">Problem, workflow has been disabled. Please contact your administrator</td></tr></table>
	<cfexit method="EXITTEMPLATE">
</cfif>

<!--- check mission workflow enabled --->

<cfif attributes.mission neq "">

	<!--- Safeguard :
	check if this feature is used, if no mission are enabled we presume all are enabled --->
	
	<cfquery name="Precheck" 
	 datasource="#attributes.Datasource#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     Organization.dbo.Ref_EntityMission 
		 WHERE    EntityCode     = '#Attributes.EntityCode#'  
		 AND      WorkflowEnabled = '1'
	</cfquery>

	<cfquery name="CheckMission" 
	 datasource="#attributes.Datasource#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     Organization.dbo.Ref_EntityMission 
		 WHERE    EntityCode     = '#Attributes.EntityCode#'  
		 AND      Mission        = '#Attributes.Mission#' 
	</cfquery>
	
	<cfif Precheck.recordcount gte "1" and CheckMission.WorkflowEnabled eq "0" and CheckMission.recordcount eq "1">
	    <cf_alert message="Workflow Object #Attributes.EntityCode# is not enabled for entity: #Attributes.Mission#.">
		<!--- workflow object has been disabled for this mission --->
		<cfexit method="EXITTEMPLATE">
	</cfif>

</cfif>

<cfif Attributes.EntityClass eq "">

	<cfquery name="Class" 
	 datasource="#attributes.Datasource#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT    *
		 FROM      Organization.dbo.Ref_EntityClassPublish S
		 WHERE     S.EntityCode     = '#Attributes.EntityCode#' 	
		 ORDER BY  DateEffective DESC 
	</cfquery>
	
	<cfif class.recordcount gte "1">
		   <cfset attributes.EntityClass = Class.EntityClass>	
	</cfif>

</cfif>

<cfquery name="Entity" 
 datasource="#attributes.Datasource#"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   TOP 1 *
	 FROM     Organization.dbo.Ref_EntityClassPublish S INNER JOIN Organization.dbo.Ref_Entity E ON E.EntityCode = S.EntityCode 
	 WHERE    E.EntityCode     = '#Attributes.EntityCode#' 
	 AND      S.EntityClass    = '#Attributes.EntityClass#' 	
	 ORDER BY DateEffective DESC 
</cfquery>


<cfif Entity.recordcount eq "0" and attributes.EnforceWorkflow eq "Yes">
		
	<cf_message message="Problem, workflow could not be initiated since the requested class [#Attributes.EntityClass#] does not have a published version." return="No">
	<cfabort>
	<!---
	<cfexit method="EXITTEMPLATE">
	--->
	
</cfif>

<cfif Entity.EnableFirstStep eq "1">

	<cfset Attributes.CompleteFirst = "Yes"> 
	
<cfelse>

	<cfparam name="Attributes.CompleteFirst"   default="No"> 
	
</cfif>

<cfparam name="Attributes.EntityClassReset"  default="0">
<cfparam name="Attributes.EntityGroup"       default="">
<cfparam name="Attributes.EntityStatus"      default="">

<cfparam name="Attributes.ObjectId"          default="">
<cfparam name="Attributes.ObjectKey1"        default="">
<cfparam name="Attributes.ObjectKey2"        default="">
<cfparam name="Attributes.ObjectKey3"        default="">
<cfparam name="Attributes.ObjectKey4"        default="">

<cfparam name="Attributes.Owner"             default="">

<!--- NEW : to hide current tracks, use value = ENFORCE to close open tracks and create a NEW one --->
<cfparam name="Attributes.HideCurrent"       default="No"> <!--- YES|NO|ENFORC: deactivates the current workflow object record --->
<cfparam name="Attributes.CompleteCurrent"   default="No"> <!--- YES|NO : resets open actions to prevent any triggering --->

<cfparam name="Attributes.ObjectReference"   default="">
<cfparam name="Attributes.ObjectReference2"  default="">
<cfparam name="Attributes.ObjectFilter"      default="">
<cfparam name="Attributes.ObjectURL"         default="">
<cfparam name="Attributes.ObjectDue"         default="">
<cfparam name="Attributes.ParentObjectId"    default="">
<cfparam name="Attributes.Questionaire"      default="No">

<cfquery name="getQuestionaire" 
	datasource="#attributes.Datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT     *
    FROM       Organization.dbo.Ref_EntityDocument D 
    WHERE      D.EntityCode   = '#attributes.EntityCode#'
	AND        D.DocumentType = 'Question'
	AND        D.Operational  = 1
</cfquery>	

<cfif getQuestionaire.recordcount eq "0">
	 <cfset attributes.Questionaire = "No">
</cfif>

<cfparam name="Attributes.TableWidth"       default="100%">

<!--- newly added attributes --->
<cfparam name="Attributes.RowLabel"         default="yes">
<cfparam name="Attributes.RowHeight"        default="35">

<cfparam name="Attributes.Create"           default="Yes">
<cfparam name="Attributes.Show"             default="Yes">
<!--- NEW : To let workflow work within a Ajax environment --->
<cfparam name="Attributes.AjaxId"           default="">
<!--- NEW : triggered from this template ActionListingView only if a subflow is found --->
<cfparam name="Attributes.Subflow"          default="No">
<cfparam name="Attributes.SubflowName"      default="">
<cfparam name="Attributes.Header"           default="">
<cfparam name="Attributes.Toolbar"          default="">
<cfparam name="Attributes.Annotation"       default="Yes">
<cfparam name="Attributes.Communicator"     default="No">
<cfparam name="Attributes.Reset"            default="Yes">
<cfparam name="Attributes.FrameColor"       default="f4f4f4">
<cfparam name="Attributes.AllowProcess"     default="Yes"> 

<!--- NEW : API provision to complete a step outside the dialog screen --->
<cfparam name="client.resubmit"             default="No"> 
<cfparam name="Attributes.resubmit"         default="#client.resubmit#">

<!--- Yes|No --->
<cfparam name="Attributes.DocumentStatus"   default="0">
<cfparam name="Attributes.ActionMail"       default="Yes">

<cfparam name="Attributes.PreventProcess"   default="">
<cfparam name="Attributes.ShowAttachment"   default="No">

<!--- added for travel claim resubmission 
            to not show the button for processing --->
<cfparam name="Attributes.HideProcess"      default="0">

<cfif attributes.show eq "Yes">
	<cf_tl id="Workflow action" var="1">
</cfif>

<cfset Attributes.ObjectURL = Replace("#Attributes.ObjectURL#", "#SESSION.root#","")>
<cfparam name="Attributes.Mission"          default="">
<cfparam name="Attributes.OrgUnit"          default="">

<!--- define this user as a actor on the fly for the first step 
           that will be processed in the interface -------------- --->

<cfparam name="Attributes.FlyActor"         default="">
<cfparam name="Attributes.FlyActor2"        default="">
<cfparam name="Attributes.FlyActor3"        default="">
<cfparam name="Attributes.FlyActorAction"   default="">
<cfparam name="Attributes.FlyActor2Action"  default="">
<cfparam name="Attributes.FlyActor3Action"  default="">

<!--- ----------------------------------------------------------- --->

<cfparam name="Attributes.PersonNo"         default="">
<cfparam name="Attributes.EntityCodeForce"  default="No"> <!--- shows only worfklows for the passed entity, which is turned off as for contract mannagement we swap  --->
<cfparam name="Attributes.PersonEMail"      default="">

<!--- put the pk of the entity in a variuable --->

<cfif attributes.EntityCodeForce eq "yes">
	<cfset condition = "AND O.EntityCode = '#Attributes.entitycode#'">
<cfelse>
	<cfset condition = "">
</cfif>	

<cfloop index="itm" from="1" to="4"> 

	 <cfset val = evaluate("Attributes.ObjectKey#itm#")>
	 <cfif val neq "">	
		<cfset condition = condition&" AND O.ObjectKeyValue#itm# = '#val#'">
	 <cfelseif itm lte "3">
	 	<cfset condition = condition&" AND O.ObjectKeyValue#itm# is NULL">	
	 </cfif>
</cfloop>

<cfif condition eq "">

	<cf_message message="Problem, workflow cannot be initiated as API does not contain a valid reference." return="No">
	<cfabort>
	<!--- <cfexit method="EXITTEMPLATE"> --->

</cfif>

<cfif Attributes.ObjectFilter neq "">
	<cfset condition = condition & " AND O.ObjectFilter= '#Attributes.ObjectFilter#' ">
</cfif>

<!--- disabled by hanno to support crossing classes
<cfset condition = "#condition# AND O.EntityCode = '#Attributes.EntityCode#'">
--->

<cfif Attributes.OrgUnit neq "">

	<cfquery name="Check" 
	 datasource="#attributes.Datasource#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Organization.dbo.Organization
		 WHERE  OrgUnit = '#Attributes.OrgUnit#'  
	</cfquery>	

	<cfif Check.recordcount eq "0">
	
		<cf_message message="Problem, workflow cannot be initiated as the organizational unit can not be determined (<cfoutput>#Attributes.OrgUnit#</cfoutput>).">
		<cfabort>
		<!---
		<cfexit method="EXITTEMPLATE">
		--->
	
	</cfif>
	
</cfif>	

<cfif Attributes.OrgUnit neq "" and Attributes.Mission eq "">

	<cfquery name="Mission" 
	 datasource="#attributes.Datasource#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Organization.dbo.Organization
		 WHERE  OrgUnit = '#Attributes.OrgUnit#'  
	</cfquery>	
	
	<cfset attributes.mission = Mission.Mission>

</cfif>

<cfif Attributes.Owner eq "">

	<cfquery name="Mission" 
	 datasource="#attributes.Datasource#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Organization.dbo.Ref_Mission
		 WHERE  Mission = '#Attributes.Mission#'  
	</cfquery>	
	
	<cfset attributes.owner = Mission.MissionOwner>

</cfif>

<!--- ---------------------------------------------------------------- --->
<!--- --deactivate the track if this is requested through the method-- --->
<!--- ---------------------------------------------------------------- --->

<cfif attributes.hidecurrent eq "Enforce">

	<cfquery name="CloseCurrent" 
	 datasource="#attributes.Datasource#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE  Organization.dbo.OrganizationObject
		 SET     Operational = 0
		 WHERE   ObjectId IN (
		                     SELECT ObjectId 
		 					 FROM   Organization.dbo.OrganizationObject O
							 WHERE  O.EntityCode   = '#Attributes.EntityCode#' 
							 AND    O.Operational  = 1 
							 #preserveSingleQuotes(condition)#
							 ) 
							 
	</cfquery>
		
</cfif>

<!--- ----------------------------------------------------------------- --->
<!--- --complete the object if this is requested through the method---- --->
<!--- ----------------------------------------------------------------- --->

<cfif attributes.CompleteCurrent eq "Yes">
	
	<cfquery name="CompleteCurrent" 
		 datasource="#attributes.Datasource#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	 
			UPDATE  Organization.dbo.OrganizationObjectAction
			SET     ActionStatus     = '2',
			        ActionMemo       = 'Closed by WORKFLOW AGENT',
			        OfficerUserId    = 'Prosis',
				    OfficerLastName  = 'Agent',
				    OfficerFirstName = 'System',									   
				    OfficerDate      = getDate()					   		
			WHERE   ObjectId IN (SELECT ObjectId 
			                     FROM   Organization.dbo.OrganizationObject O
								 WHERE  O.EntityCode   = '#Attributes.EntityCode#' 
								 AND    O.Operational  = 1 
								 #preserveSingleQuotes(condition)#)
			AND     ActionStatus = '0'			
	</cfquery>	 
		
</cfif>

<cfif Attributes.Show neq "No" and attributes.subflow eq "No">

	<table width="<cfoutput>#attributes.Tablewidth#</cfoutput>" align="center">
	<tr>
	<td>
			
	<table width="100%" align="center" style="border:0px solid silver">			
	<tr><td colspan="2">

	<table width="100%" border="0">
			
</cfif>

<!--- current workflow --->

<cfquery name="EntityClass" 
 datasource="#attributes.Datasource#"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Organization.dbo.Ref_EntityClass
	 WHERE    EntityCode     = '#Attributes.EntityCode#'  
	 AND      EntityClass    = '#Attributes.EntityClass#'	 
</cfquery>

<cfif attributes.hidecurrent eq "No">   

	   	<cfinclude template="ObjectCreate.cfm">		

		<cfquery name="Check" 
		 datasource="#attributes.Datasource#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Organization.dbo.OrganizationObject O
			 WHERE  O.EntityCode   = '#Attributes.EntityCode#' 
			 AND    Operational    = 1
			        #preserveSingleQuotes(condition)#
		</cfquery>
		
						
		<cfif attributes.create eq "Yes">
			
			<cfif Check.recordcount eq "0">
				<cfexit method="EXITTEMPLATE">
			</cfif>
			
			<cfset ObjectId = Check.ObjectId>
					
			<cfquery name="SetStatus0" 
				datasource="#attributes.Datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE  Organization.dbo.OrganizationObject 		
				SET     ObjectStatus = 0
				FROM    Organization.dbo.OrganizationObject OB
				WHERE   OB.Objectid = '#objectid#' 
				AND     OB.ObjectId IN (   SELECT  ObjectId
										   FROM    Organization.dbo.OrganizationObjectAction OA
										   WHERE   ActionStatus = '0'										  
										   AND     Objectid     = '#objectid#'  )
										   
			</cfquery>	
			
			<!--- default inherit access --->
												
			<cfif EntityClass.EnableActionOwner eq "1">
						
				<cfquery name="getObject" 
				datasource="#attributes.Datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * FROM Organization.dbo.OrganizationObject WHERE Objectid = '#objectid#'										   
				</cfquery>				
		
				<cfquery name="InsertObject" 
					 datasource="#attributes.Datasource#"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 INSERT INTO Organization.dbo.OrganizationObjectActionAccess
						        (ObjectId,ActionCode,UserAccount,AccessLevel,OfficerUserId,OfficerLastName,OfficerFirstName)
								 
						 SELECT DISTINCT '#objectid#',
						                 ActionCode,
										 '#getObject.OfficerUserId#',
										 '#EntityClass.OwnerAccessLevel#',
										 '#SESSION.acc#',
										 '#SESSION.last#',
										 '#SESSION.first#'
										 
						 FROM   Organization.dbo.Ref_EntityActionPublish
						 WHERE  ActionPublishNo = '#Entity.ActionPublishNo#'
						 AND    DisableOwner = '0'
						 AND    ActionCode NOT IN (SELECT ActionCode
						                           FROM   Organization.dbo.OrganizationObjectActionAccess
												   WHERE  ObjectId    = '#objectid#'
												   AND    UserAccount = '#getobject.OfficerUserId#')
												   
				</cfquery>		
				
			</cfif>
			
		</cfif>	
				
		<cfif (Attributes.Show eq "Yes" or Attributes.Show eq "Mini") and Check.recordcount eq "1"> 
		
		    <cfset objectcnt = 0>
			<cfset object_op = 1>		
			
			<!--- container for show of interval check --->	
			
			
																				
			<cfinclude template="ActionListingView.cfm"> 
								
		</cfif>

</cfif>

<!--- redefine entitygroup --->


<cfif Attributes.Show eq "Yes"> 
	
	<cfif entity.showhistory gte "1">
							
				
		<!--- Prior workflow --->
		
		<cfquery name="Object" 
		 datasource="#attributes.Datasource#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT TOP #entity.showhistory# *
			 FROM       Organization.dbo.OrganizationObject O
			 WHERE      Operational = 0
			            #preserveSingleQuotes(condition)#
			 AND        EXISTS (SELECT 'X' FROM organizationObjectAction WHERE ObjectId = O.ObjectId AND ActionStatus <> '0')			
			 ORDER BY   Created DESC	
			 
		</cfquery>
								
		<cfoutput query="Object">
						
			<cfset ObjectId = "#Object.ObjectId#">		
									
			    <cfset objectcnt = currentrow>
		    	<cfset object_op = 0>
				<cfset attributes.subflow = "No">
				<cfset condition = "AND O.ObjectId = '#ObjectId#'">
						
				 <cfinclude template="ActionListingView.cfm">	 
				 			
					
		</cfoutput>
				
	</cfif>	
	
</cfif>

<cfif Attributes.Show neq "No" and attributes.subflow eq "No">

		</table>	
		
		</td></tr>
		
		</table>	
		
		</td></tr>
		
		</table>
	
	</cfif>

<!---
</cftransaction>
--->




