
<!--- get context --->

<cfparam name="url.actionid" default="">
<cfparam name="url.useraccount" default="">
<cfparam name="url.referenceid" default="">

<cfquery name="Object" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT    OOA.ObjectId, 
	          OO.EntityCode, 
			  OO.Mission, 
			  OO.OrgUnit, 
			  OO.ActionPublishNo, 
			  R.ActionCode,
			  R.ActionDescription
	FROM      OrganizationObjectAction AS OOA INNER JOIN
	          OrganizationObject AS OO ON OOA.ObjectId = OO.ObjectId INNER JOIN
	          Ref_EntityActionPublish AS R ON OO.ActionPublishNo = R.ActionPublishNo AND OOA.ActionCode = R.ActionCode
	WHERE     OOA.ActionId = '#url.actionid#'
</cfquery>


<cfquery name="Session" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT    *
	FROM      OrganizationObjectActionSession
	WHERE     ActionId        = '#url.actionid#'
	AND       EntityReference = '#url.referenceId#'
</cfquery>

<cfquery name="Document" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT    R.DocumentId, R.DocumentCode, R.DocumentDescription, R.DocumentTemplate, R.DocumentStringList
	
	FROM      Ref_EntityDocument AS R INNER JOIN
              Ref_EntityAction A ON R.EntityCode = A.EntityCode INNER JOIN
              Ref_EntityActionPublishDocument AS D ON A.ActionCode = D.ActionCode AND R.DocumentId = D.DocumentId
	 	
	WHERE     R.DocumentType = 'session'  AND D.ActionCode    = '#Object.ActionCode#' AND ActionPublishNo = '#Object.ActionPublishNo#'
	
</cfquery>

<cfif Document.recordcount eq "0">

	<table width="94%" class="formspacing formpadding" align="center">
	
	<tr class="labelmedium2">
	   <td style="fint-size:17px;padding-top:20px" align="center">There is no interface set for this action</td>
	</tr>
	
	</table>

<cfelse>

	<cfif Object.recordcount eq "1">
	
		<cfoutput>
		
		<cfform method="POST" name="sessionform" onsubmit="return false">
	
			<table width="94%" class="formspacing formpadding" align="center">
							
				<tr class="labelmedium2"><td><cf_tl id="Web form"></td>
				
				    <td>
					<select name="DocumentId" class="regularxxl" style="width:90%">
						<cfloop query="Document">
						<option value="#DocumentId#" <cfif documentId eq session.sessionDocumentId>selected</cfif>>#DocumentDescription#</option>
						</cfloop>
					</select>		
					
					</td>
				</tr>
				
				<cfquery name="get" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 	SELECT    *
					 	FROM      Ref_EntityDocument
						<cfif session.sessiondocumentId eq "">
						WHERE 1=0
						<cfelse>
						WHERE    DocumentId = '#session.sessionDocumentId#'
						</cfif>
				</cfquery>
				
				<cfif session.actionsessionid neq "">
				
				<tr class="labelmedium2">
					<td style="min-width:200px;height:34px"><cf_tl id="Session URL"></td>
					<td style="width:75%" id="link"><a href="#session.root#/ActionSession.cfm?id=#session.actionSessionId#&mode=test" target="_blank"><cf_tl id="Test link"></a></td>			
				</tr>
				
				</cfif>
				
				<tr class="labelmedium2">
				    <td style="height:34px"><cf_tl id="Session active"></td>
				    <td>
					
						<table cellspacing="0" cellpadding="0">
						<tr class="labelmedium2">
						<td>
						
							<cf_intelliCalendarDate9
								FieldName="SessionPlanStart" 
								message="Please enter a valid start date" 
								Default="#Dateformat(Session.SessionPlanStart, '#CLIENT.DateFormatShow#')#"
								AllowBlank="False"
								Class="regularxxl">	
						
						</td>
						
						<td style="padding-left:10px">
								
						<cfif Timeformat(Session.SessionPlanStart, 'HH') eq "">
						   <cfset tah = "12">
						   <cfset tam = "00">
						<cfelse>
						   <cfset tah = "#Timeformat(Session.SessionPlanStart, 'HH')#">
						   <cfset tam = "#Timeformat(Session.SessionPlanStart, 'MM')#">
						</cfif>
											
						<cfinput type="Text" 
							name="HourSessionPlanStart" 
							range="1,23" 
							value="#tah#"
							message="Please enter a valid hour" 
							validate="integer" 
							required="Yes" 
							size="1" 
							maxlength="2" 
							class="regularxxl" 
							style="text-align: center;">
						:
						<cfinput type="Text" 
					         name="MinuteSessionPlanStart" 
							 range="0,59" 
							 value="#tam#"
							 message="Please enter a valid hour" 
							 validate="integer" 						 
							 required="Yes" 
							 size="1" 
							 maxlength="2" 
							 style="text-align: center;" 
							 class="regularxxl">
							 
						</td>
						</tr>
						</table>
						</td>
					</tr>	
						
					<tr class="labelmedium2">
				    <td><cf_tl id="Session expiry"></td>
				    <td>
					
						<table cellspacing="0" cellpadding="0">
						<tr class="labelmedium">
						<td>
						
							<cf_intelliCalendarDate9
								FieldName="SessionPlanEnd" 
								Default="#Dateformat(Session.SessionPlanEnd, '#CLIENT.DateFormatShow#')#"
								AllowBlank="False"
								message="Please enter a valid expiration date" 
								Class="regularxxl">	
						
						</td>
						
						<td style="padding-left:10px">
																
						<cfif Timeformat(Session.SessionPlanEnd, 'HH') eq "">
						   <cfset teh = "12">
						   <cfset tem = "00">
						<cfelse>
						   <cfset teh = "#Timeformat(Session.SessionPlanEnd, 'HH')#">
						   <cfset tem = "#Timeformat(Session.SessionPlanEnd, 'MM')#">
						</cfif>	
								
						<cfinput type="Text" 
							name="HourSessionPlanEnd" 
							range="1,24" 
							value="#teh#"
							message="Please enter a valid hour" 
							validate="integer" 
							required="Yes" 
							size="1" 
							maxlength="2" 
							class="regularxxl" 
							style="text-align: center;">
						:
						<cfinput type="Text" 
					         name="MinuteSessionPlanEnd" 
							 range="0,60" 
							 value="#tem#"
							 message="Please enter a valid hour" 
							 validate="integer" 
							 required="Yes" 
							 size="1" 
							 maxlength="2" 
							 style="text-align: center;" 
							 class="regularxxl">
							 
						 </td>
							 
						 </tr>
							 
						 </table>
					
					
					</td>
				</tr>
				
				<tr class="labelmedium2"><td><cf_tl id="Passcode"></td>
				    <td>
					<input type="text" name="Passcode" value="#Session.SessionPasscode#" maxlength="6" class="regularxxl" style="width:80px">
					</td>
				</tr>
				
				<tr class="labelmedium2"><td><cf_tl id="Operational"></td>
				    <td>
					<input type="checkbox" name="Operational" value="#Session.Operational#" <cfif session.operational neq "0">checked</cfif> class="radiol">
					</td>
				</tr>
				
					
				<cfif session.recordcount eq "0">
				
				<cfelse>
				
					<tr class="labelmedium2"><td><cf_tl id="IP used"></td>
					    <td><input type="text" class="regularxxl"  name="SessionIP" value="#session.sessionIP#"></td>
					</tr>
					
					<tr class="labelmedium2"><td><cf_tl id="Interaction"></td>
					    <td style="padding-left:5px;padding-right:5px;font-size:15px;background-color:f1f1f1">#dateformat(Session.SessionActualStart,client.dateformatshow)# #timeformat(Session.SessionactualStart,"HH:MM:SS")#
						#dateformat(Session.SessionActualEnd,client.dateformatshow)# #timeformat(Session.SessionactualEnd,"HH:MM:SS")#
						</td>
					</tr>				
								
				</cfif>
				
				<tr class="line"><td colspan="2"></td></tr>
				
				<tr>
				<td colspan="2">
					<table align="center" class="formspacing">
					<tr>
					<td><input type="button" class="button10g" name="Close" value="Close" onclick="ProsisUI.closeWindow('wfusersession')"></td>
					<td><input type="button" class="button10g" type="text" name="Save" value="Save" onclick="workflowsessionsave('#url.actionid#','#url.referenceid#','#url.useraccount#')"></td>
					</tr>
					</table>
				</td>
				</tr>		
			
			</table>
		
		</cfform>
		
		</cfoutput>	
	
	</cfif>
		
	<cfset ajaxonload("doCalendar")>
	
</cfif>	

<cfoutput>

<cfset AjaxOnLoad("function(){ProsisUI.setWindowTitle('#Object.Mission# : #Object.ActionDescription# [Web session]','','black');}")>		

</cfoutput>