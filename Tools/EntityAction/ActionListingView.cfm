<cfoutput>

<cfparam name="CLIENT.LanPrefix" default="">
	
<cfsavecontent variable="myact">
	SELECT OA.*, 
	        A.ActionPublishNo, 
			A.ActionCode,
			A.ActionParent,
			A.ActionDescription,
			A.ActionCompletedColor,
			A.ActionType,
			A.EnableNotification,
			A.NotificationManual,
			A.ActionDialog,
			
			<!--- language --->
			A.ActionDescription,
			A.ActionCompleted,
			A.ActionDenied,
			A.ActionProcess,
			A.ActionReference,
			<!--- -------- --->
			
			A.EnableQuickProcess,
			A.DisableStandardDialog,
			A.EnableHTMLEdit,
			A.ActionURLDetails,
			A.ActionTrigger,
			A.EnableAttachment,
			A.PersonMailCode,
			A.PersonMailAction,
			A.EmbeddedClass,		
			P.DateEffective    as TrackEffective,
			O.OfficerUserid    as OwnerId, 
			O.OfficerLastName  as OwnerLastName, 
			O.OfficerFirstName as OwnerFirstName, 
	        O.EntityGroup, 
			O.EntityCode, 
			O.EntityClass, 
			EA.ProcessMode,
			E.EnableTopMenu,
			E.EnableRefresh,
			EC.RefreshInterval,
			E.Role 
	  FROM  OrganizationObjectAction OA, 
	        OrganizationObject O, 
		    #CLIENT.LanPrefix#Ref_EntityActionPublish A,
			Ref_EntityClassPublish P,
		    Ref_Entity E,
			Ref_EntityClass EC,
			Ref_EntityAction EA
	 WHERE  OA.ObjectId       = O.ObjectId  		
	  AND 	O.EntityCode      = E.EntityCode
	  AND   O.EntityCode      = EC.EntityCode 
	  AND   O.EntityClass     = EC.EntityClass
	  AND 	A.ActionPublishNo = OA.ActionPublishNo
	  AND 	A.ActionCode      = OA.ActionCode
	  AND 	P.ActionPublishNo = OA.ActionPublishNo 
	  AND 	O.Operational     = '#object_op#'
	  AND   A.ActionCode      = EA.ActionCode
	  <cfif object_op eq "0">
	  AND   OA.ActionStatus <> '0'
	  </cfif>
	  #preserveSingleQuotes(condition)#  
	  
	  <!--- only interested in open actions --->
	  <cfif Attributes.Show eq "Mini">
	  AND   OA.ActionStatus = '0'
	  </cfif>
	 
		  
	</cfsavecontent>
	
	<!--- define leadtimes --->
		
	<cfinclude template="ActionListingLeadTime.cfm">
	
	<cfquery name="Actions" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 #preservesinglequotes(myact)#
	  ORDER BY OA.ActionFlowOrder DESC,  
	           OA.OfficerDate DESC 			   
	</cfquery>
		
	
	<!--- 
				
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css"  media="print">
	
	--->

</cfoutput>

<cfif attributes.ajaxid eq "" and attributes.subFlow eq "No">
	<cfinclude template="ActionListingScript.cfm">	
</cfif>

<!--- we check the last timestamp of an action recorded in the workflow --->


<cfquery name="FirstDue" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   MIN(ActionFlowOrder) as ActionFlowOrder 
	 FROM     OrganizationObjectAction OA
	 WHERE    ObjectId  = '#ObjectId#' 
	 AND      ActionStatus = '0'
</cfquery>

<cfquery name="LastSubmit" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   MAX(OfficerDate) as OfficerDate 
	 FROM     OrganizationObjectAction OA
	 WHERE    ObjectId  = '#ObjectId#' 
 </cfquery>
 
<cfquery name="NextAction" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   MIN(ActionFlowOrder) as ActionFlowOrder 
 FROM     OrganizationObjectAction OA
 WHERE    ObjectId   = '#ObjectId#' 
 <cfif Attributes.OrgUnit neq "NULL"> 
    AND   OA.OrgUnit = '#Attributes.OrgUnit#' 
 </cfif>
 AND      ActionStatus < '2'
 AND      ActionFlowOrder >= (SELECT DISTINCT Min(ActionFlowOrder) 
					   FROM  OrganizationObjectAction OA
					   WHERE  ObjectId  = '#ObjectId#' 
					   <cfif Attributes.OrgUnit neq "NULL"> 
					   AND  OA.OrgUnit = '#Attributes.OrgUnit#' 
					   </cfif>
					   AND   OfficerDate = '#DateFormat(LastSubmit.OfficerDate,client.DateSQL)#')
</cfquery>

<cfquery name="Concurrent" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT R.ActionParent
	 FROM   OrganizationObjectAction OA, Ref_EntityActionPublish R
	 WHERE  OA.ObjectId  = '#ObjectId#' 
	 AND    OA.ActionFlowOrder = '#NextAction.ActionFlowOrder#'
	 AND    R.ActionCode = OA.ActionCode
	 AND    R.ActionPublishNo = '#Actions.ActionPublishNo#'
</cfquery>

<cfquery name="CheckClosed" dbtype="query">
	SELECT *
	FROM  Actions 
	WHERE ActionStatus < '2'  		
</cfquery>

<cfquery name="CheckNext" dbtype="query">
	SELECT Min(ActionFlowOrder) as ActionFlowOrder
	FROM  Actions 
	WHERE ActionStatus = '0'  		
</cfquery>

<cfquery name="CheckLast" dbtype="query">
	SELECT Max(ActionFlowOrder) as ActionFlowOrder
	FROM  Actions 
	WHERE ActionStatus != '0'  		
</cfquery>

<cfquery name="isActor" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT DISTINCT UserAccount
	 FROM   OrganizationAuthorization
	 WHERE  UserAccount = '#SESSION.acc#'
	 AND    Role        = '#Entity.Role#'
	 UNION 
	 SELECT DISTINCT UserAccount
	 FROM   OrganizationObjectActionAccess
	 WHERE  UserAccount = '#SESSION.acc#'
	 AND    ObjectId    = '#ObjectId#'	
</cfquery>

<!--- ------------------------------- --->
<!--- ------log the view access------ --->
<!--- ------------------------------- --->

<cf_getHost host="#cgi.http_host#">

<cfquery name="LogAccess" 	
	datasource="#attributes.Datasource#"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO UserActionEntity 
		(Account, 
		 HostName, 
		 NodeIP,
		 ObjectId,
		 ActionDescription)
	VALUES 
		('#SESSION.acc#',
		 '#host#',
		 '#CGI.Remote_Addr#',
		 '#ObjectId#',
		 'Open Workflow') 			
</cfquery>

<cfset col = "9">

<!--- -------------------------- --->		
<!--- trigger the back end check --->

<cfset refr = "0">

<cfif attributes.ajaxid neq "">

	<cfoutput>	    
	
		<!--- container for show of interval check --->	
		<tr class="hide">
			<td colspan="<cfoutput>#col#</cfoutput>" id="communicate_#objectid#"></td>
		</tr>
		
		<cfquery name="CheckStatus" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT    ActionId
			 FROM      OrganizationObjectAction
			 WHERE     ObjectId       = '#ObjectId#'
			 AND       ActionStatus IN ('0')		
		</cfquery>
		
		<cfquery name="CheckLastAction" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT    TOP 1 OfficerDate
			 FROM      OrganizationObjectAction
			 WHERE     ObjectId       = '#ObjectId#'
			 AND       ActionStatus IN ('2','2Y','2N')
			 ORDER BY  OfficerDate DESC
		</cfquery>
			
		<!--- trigger interval check function --->
			
		<script language="JavaScript">					
			<!--- reset any backoffice scripts that might be still running --->
			try { clearInterval ( workflowrefresh_#left(objectid,8)# ) } catch(e) {}													
		</script>		
		
		<cfif checkStatus.recordcount gte "1"> <!--- the workflow has at least one (1) pending action --->
			
			<cfif Actions.enableRefresh eq "1" and Actions.refreshInterval gt "0">	
			
				<cfset refr = "1">
						
				<script>												
					<cfset milsec = Actions.refreshInterval*1000>		
					workflowrefresh_#left(objectid,8)# = setInterval('objectstatus("#checklastaction.officerDate#","#objectid#","#attributes.ajaxid#")',#milsec#) 																
				</script>
			
			</cfif>
			
		</cfif>
			
	</cfoutput>

</cfif>

<!---  28/3 reomoved this condition -- and Object_op eq "1" ---> 

<cfif Attributes.Show eq "Yes">

	<cfif attributes.subflow eq "No">
		
		<cfset url.ownerid = actions.ownerid>
		
		<cfoutput>
		
		<cfif attributes.showattachment eq "Yes">
		<tr><td id="external" colspan="#col#">
			<cfinclude template="ActionListingViewExternal.cfm">
		</td></tr>
		</cfif>
		
		<cfif Attributes.Header neq "" and getAdministrator("#Object.Mission#") eq "0">
			<tr><td colspan="#col#" height="16" align="center">#Attributes.Header#</td></tr>
			<tr><td colspan="#col#" class="line" align="center"></td></tr>
		</cfif>
		
		<cfif object_op is 0>
		
		    <tr><td height="4" colspan="9"></td></tr>		
			<tr>
				<td colspan="9" class="labelit"
				    style="padding-left:4px;height:23;border:1px solid silver; background: dfdfdf;padding-left:20px">
					
					<table>
					<tr>
					<td><cf_tl id="Prior workflow">: <cf_tl id="Owner">: <b>#Actions.OwnerFirstName# #Actions.OwnerLastName#</b></td>								
					<td style="padding-left:10px">
					
						<cfif Actions.recordcount gte "1">
				   
						   	<cfquery name="Org" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">			
									SELECT *
									FROM   Organization
									WHERE  OrgUnit = '#Object.OrgUnit#'				
							</cfquery>
								
							<cfif Org.recordcount neq "0">	
															   
						    <cfoutput>#Org.OrgUnitName#</cfoutput>	
					       
						  </cfif>
				
						</cfif>
					
					</td>								
					</tr>
					</table>
				
			</tr>	
			<tr><td height="9" colspan="9"></td></tr>					
			
		<cfelse>
		
			<cfif   getAdministrator("#Object.Mission#") eq "1"
					or
				    (Actions.EnableTopMenu eq "1" and Actions.OwnerId eq SESSION.acc) 
					or
					(Actions.EnableTopMenu eq "3" and Attributes.toolbar neq "hide")>
			
			   <cfinclude template="ActionListingMenu.cfm">		
			
			</cfif>
		
		</cfif>
		
		</cfoutput>
		
		<cfif attributes.rowlabel eq "Yes">
		
			<tr class="labelmedium fixrow">
			   <td colspan="2" style="min-width:380px;padding-left:10px"><cf_tl id="Status"><cfif refr eq "1">##</cfif></td>		  
			   <td style="min-width:60px"><cf_tl id="Action by"></td>
			   <td style="width:70%"><cf_tl id="Actor"></td>	
			   <!---	  
			   <td width="120"><cf_tl id="Processed"></td>
			   --->
			   <td style="min-width:60px"><cf_tl id="Leadtime"></td>
			   <td style="min-width:80px"><cf_tl id="Action Date"></td>
			   <td width="10"></td>
			   <td width="10"></td>
			</tr>	
		
		<cfelse>
		
			<tr>
			   <td colspan="2" style="min-width:380px;padding-left:10px"></td>		  
			   <td style="min-width:60px"></td>
			   <td style="min-width:120px"></td>		  		  
			   <td style="min-width:60px"></td>
			   <td style="min-width:80px"></td>
			   <td width="10"></td>
			   <td width="10"></td>
			</tr>	
		
		</cfif>
		
		<tr><td colspan="<cfoutput>#col#</cfoutput>" class="line"></td></tr>
		
	</cfif>	
		
	<!--- here start the records to be listed --->
		
	<cfset prior    = Object.Created>
	<cfset keepdate = Object.Created>
	
	<cfoutput query="Actions">
					
		<cfset embed = "0">
	
		<cfif EmbeddedClass neq "">
	
			<cfquery name="EmbedFlow" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				SELECT *
				FROM   Ref_EntityClass
				WHERE  EntityCode  = '#Object.EntityCode#'
				AND    EntityClass = '#EmbeddedClass#' 
			</cfquery>
			
			<cfquery name="EmbedCompleted" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				SELECT   TOP 1 *
				FROM     OrganizationObject O, OrganizationObjectAction A
				WHERE    O.ObjectId = A.ObjectId
				AND      O.ObjectKeyValue4 = '#ActionId#'		
				ORDER BY A.ActionStatus
			</cfquery>
						
			<cfquery name="Script" 
			 	datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT TOP 1 IsNull(MethodScript,'') as MethodScript
				 FROM         Ref_EntityActionPublishScript R
				 WHERE        R.ActionPublishNo = '#Actions.ActionPublishNo#' 
				 AND          R.ActionCode      = '#Actions.ActionCode#' 
				 AND          R.Method          = 'Embed'
				 AND          MethodEnabled = 1 
			</cfquery>
			
			<!--- define if condition for embedded workflow would work --->
			
			<cfset conembed = "1">
			
			<cfif Script.recordcount eq "1" 
			      and TRIM(Script.MethodScript) neq "">
					
						<cfset val         = "#Script.MethodScript#">
						<cfinclude template= "ProcessActionSubmitScript.cfm">
						
						<!--- runs the query --->
						
						<cfif SQL.recordcount eq "0">
						
							<!--- condition is not met --->
							<cfset conembed = "0">							
						
						</cfif>
									
			</cfif>
									
			<!--- check if class exists and 
			    object has NOT been completed --->
	
			<cfif Embedflow.recordcount eq "1" and conembed eq "1" and 
				(EmbedCompleted.recordcount eq "0" or
				EmbedCompleted.ActionStatus eq "0")>
								
				<!--- embedded workflow is not completed --->
		
				<cfset embed = "2">
				
			<cfelseif Embedflow.recordcount eq "1" and conembed eq "1" and 
				EmbedCompleted.recordcount eq "1" and
				EmbedCompleted.ActionStatus gte "2">	
				
				<!--- embedded workflow is completed --->
				
				<cfset embed = "1">
												
			</cfif>	
			
		</cfif>	
					
		<cfif embed eq "0">
		
			<cfset showaction = 1>
			<cfinclude template="ActionListingViewLine.cfm">		 
							
		<cfelseif embed eq "1">		
		
			<!--- embedded workflow is completed --->
		
			<cfset showaction = 1>
			<cfinclude template="ActionListingViewLine.cfm">
										
			<cfset link = "#Object.ObjectURL#">
									
			<cf_ActionListing 
				EntityCode       = "#Object.EntityCode#"
				EntityClass      = "#EmbeddedClass#"
				EntityGroup      = "#Object.EntityGroup#"
				EntityStatus     = "#Object.EntityStatus#"
				Mission          = "#Object.mission#"
				OrgUnit          = "#Object.orgunit#"
				PersonNo         = "#Object.PersonNo#" 
				PersonEMail      = "#Object.PersonEMail#"
				ObjectReference  = "#Object.ObjectReference#"
				ObjectReference2 = "Embedded workflow"
				ParentObjectId   = "#Object.ObjectId#"
				ObjectKey4       = "#ActionId#"
				AjaxId           = "#Attributes.AjaxId#"
				ObjectURL        = "#link#"
				SubFlow          = "Yes"											
				CompleteFirst    = "No">		
				
				<tr><td colspan="#col#" class="line"></td></tr>	
		
		<cfelse> 
				
			<!--- the embedded workflow is not completed --->
			
			<cfif Actions.ActionFlowOrder lte CheckNext.ActionFlowOrder or CheckNext.ActionFlowOrder eq "">		
			
				<cfset showaction = 0>
				
				<cfinclude template="ActionListingViewLine.cfm">				
					
				<cfset link = "#Object.ObjectURL#">
																
				<cf_ActionListing 
					EntityCode       = "#Object.EntityCode#"
					EntityClass      = "#EmbeddedClass#"
					EntityGroup      = "#Object.EntityGroup#"
					EntityStatus     = "#Object.EntityStatus#"
					Mission          = "#Object.mission#"
					OrgUnit          = "#Object.orgunit#"
					PersonNo         = "#Object.PersonNo#" 
					PersonEMail      = "#Object.PersonEMail#"
					ObjectReference  = "#Object.ObjectReference#"
					ObjectReference2 = "Embedded workflow"
					ParentObjectId   = "#Object.ObjectId#"
					ObjectKey4       = "#ActionId#"
					ObjectURL        = "#link#"
					SubFlow          = "Yes"	
					SubFlowName      = "#ActionDescription#"	
					AjaxId           = "#Attributes.AjaxId#"	
					CompleteFirst    = "No">	
				
			 </cfif>	
										
		</cfif>	
								
	</cfoutput>
	
<cfelse>
			
	<cfoutput query="Actions">
								
			<cfset showaction = 1>
			
			<cfinclude template="ActionListingViewMini.cfm">			 
											
	</cfoutput>
	
</cfif>	
