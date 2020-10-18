
<!--- listing of the action --->

<cfif url.id eq "">
	<cfset url.id = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfif url.actionid eq "">
	<cfset url.actionid = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfquery name="Entity" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT       *
	FROM         Ref_EntityAction
	WHERE        ActionCode = '#url.actioncode#'			
</cfquery>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT       *
	FROM         OrganizationObject
	WHERE        EntityCode = '#Entity.EntityCode#'
	AND          ObjectKeyValue1 = '#url.DocumentNo#'
	AND          Operational = 1		
</cfquery>

<cfquery name="Function" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT       *
	FROM         FunctionOrganization
	WHERE        DocumentNo = '#url.DocumentNo#'
	AND          Announcement = 1		
</cfquery>

<cfquery name="ActionLookup" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT       D.DocumentId, D.DocumentCode, D.DocumentDescription, D.DocumentOrder
	FROM         Ref_EntityActionDocument AS A INNER JOIN
	             Ref_EntityDocument AS D ON A.DocumentId = D.DocumentId
	WHERE        A.ActionCode = '#url.actioncode#'
	AND          DocumentType = 'activity'
	ORDER BY     D.DocumentOrder		
</cfquery>

<cfquery name="get" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT      ActionId, DocumentNo, PersonNo, ActionCode, DocumentId, ActionDateStart, ActionDateEnd, ActionMemo, ActionStatus, OfficerUserId, OfficerLastName, 
                OfficerFirstName, Created
    FROM        DocumentCandidateReviewAction
	WHERE       ActionId = '#url.id#'	
</cfquery>

<cfform method="POST" name="activityform">

	<cfoutput>
	<table class="formpadding formspacing" style="width:96%" align="center">
		<tr><td style="min-width:200px"><cf_tl id="Activity"></td>
			<td style="width:100%">
			<select name="DocumentId" class="regularxxl">
				<cfloop query="ActionLookup">
				<option value="#DocumentId#" <cfif documentId eq get.DocumentId>selected</cfif>>#DocumentDescription#</option>
				</cfloop>
			</select>		
			</td>
		</tr>	
		<tr><td><cf_tl id="Due Date"></td>
		  <td>
		  
		  <table>
		  <tr><td>
		  
		  	  <cfif get.recordcount eq "1">	  				  	  
			  	<cfset st = Dateformat(get.ActionDateStart, CLIENT.DateFormatShow)>
			    <cfset hour = timeformat(get.ActionDateStart,"HH")>
				<cfset minu = timeformat(get.ActionDateStart,"MM")>
			  <cfelse>
			    <cfset st = Dateformat(now(), CLIENT.DateFormatShow)>
				<cfset hour = "08">
				<cfset minu = "00">
			  </cfif>	  
			  
			  <cf_intelliCalendarDate9
					FieldName="ActionDateStart" 
					Manual="True"		
					class="regularxxl"														
					Default="#st#"
					AllowBlank="False">	
				
			</td>
			
			<td style="padding-left:3px"><select name="ActionHourStart" class="regularxxl" 
			    onchange="ptoken.navigate('#session.root#/vactrack/application/candidate/action/setMailMessage.cfm?documentid='+document.getElementById('MailDocumentId').value+'&ObjectId=#Object.ObjectId#&PersonNo=#url.PersonNo#&actioncode=#url.actioncode#&functionid=#function.FunctionId#&objectactionid=#url.actionid#','mail','','','POST','activityform')">
				<cfloop index="hr" list="08,09,10,11,12,13,14,15,16,17,18,19">
					 <option value="#hr#" <cfif hr eq hour>selected</cfif>  >#hr#</option>
	 			</cfloop>
				</select>
			</td>
			
			<td style="padding-left:3px">:</td>
			
			<td style="padding-left:3px"><select name="ActionMinuteStart" class="regularxxl" 
			   onchange="ptoken.navigate('#session.root#/vactrack/application/candidate/action/setMailMessage.cfm?documentid='+document.getElementById('MailDocumentId').value+'&ObjectId=#Object.ObjectId#&PersonNo=#url.PersonNo#&actioncode=#url.actioncode#&functionid=#function.FunctionId#&objectactionid=#url.actionid#','mail','','','POST','activityform')">
				<cfloop index="min" list="00,15,30,45">
					 <option value="#min#" <cfif min eq minu>selected</cfif>>#min#</option>
	 			</cfloop>
				</select>
			</td>
			
			</tr>		
					
			
		   </table>	
		  
		  </td>
		</tr>
		
		<tr><td valign="top" style="padding-top:3px"><cf_tl id="Comment"></td>
			<td><textarea name="ActionMemo" style="font-size:14px;padding:3px;width:99%;height:40px">#get.ActionMemo#</textarea></td>
		</tr>
		
		
		
		<cfquery name="mail" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT      TOP 1 *
		    FROM        OrganizationObjectActionMail
			WHERE       ActionId = '#url.id#'	
			AND         MailType = 'Activity'
			ORDER BY    SerialNo DESC		
		</cfquery>
			
		<cfif mail.recordcount gte "1">	
		
			<tr class="labelmedium line">
			<td colspan="2" style="font-size:20px">
				<table style="width:100%">
				<tr class="labelmedium">
				<td style="font-size:20px;width:20px">
				<a href="javascript:if (confirm('Resend this mail ?')) { ptoken.navigate('#session.root#/Vactrack/Application/Candidate/Action/ActionMailResend.cfm?documentno=#url.documentno#&personno=#url.personno#&actioncode=#url.actioncode#&actionid=#mail.actionid#&objectactionid=#url.actionid#','resend')}"><cf_tl id="Resend"></a>
				</td>
				<td style="font-size:20px;padding-left:3px">
			    - <cf_tl id="Outgoing MAIL Message">
				</td>
				
				<span id="resend"></span>
				</td>
				<td align="right"><font size="2">#dateformat(mail.created,client.dateformatshow)# #timeformat(mail.created,"HH:MM:SS")#</td>
				</tr>
				</table>
			</td>						
			</tr>	
			<tr class="labelmedium  line"><td><cf_tl id="Addressee"></td>
			    <td>#Mail.MailTo#</td>
			</tr>	
			<tr class="labelmedium line"><td><cf_tl id="Subject"></td>
			    <td>#Mail.MailSubject#</td>
			</tr>	
			<tr class="line">
			    <td colspan="2">	
				<iframe src="#session.root#/Vactrack/Application/Candidate/Action/ActionMailBody.cfm?threadid=#mail.threadid#&serialno=#mail.serialno#" width="100%" height="350" frameborder="0"></iframe>				
				</td>
			</tr>	
		
		<cfelseif url.id eq "00000000-0000-0000-0000-000000000000">
		
			<tr><td colspan="2" style="font-size:20px">
			
			   <table style="width:100%">
			   
			   <tr class="labelmedium">
			   
			   	 
			      
				  <cfquery name="getmail" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT    *
						FROM      Ref_EntityActionDocument AS A INNER JOIN
		             			  Ref_EntityDocument AS D ON A.DocumentId = D.DocumentId
						WHERE     A.ActionCode = '#url.actioncode#'				    
						AND       DocumentType = 'mail'
						AND       Operational = '1'
						ORDER BY DocumentOrder
				  </cfquery>	
				  
				  <cfif getMail.recordcount eq "0">
				   
					  <cfquery name="getmail" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT    *
						    FROM      Ref_EntityDocument
							WHERE     EntityCode = '#Entity.EntityCode#' 
							AND       DocumentType = 'mail'
							AND       Operational = '1'
							ORDER BY DocumentOrder
					  </cfquery>	
				  
				  </cfif>
				  
				  <cfif getMail.recordcount lte "2">		
				  
				  	<td align="right">
					
					 <input type="hidden" id="MailDocumentId">	
				  
				  	 <table>
					 <tr class="labelmedium">	
					 				 
					  <td style="font-size:17px;padding-left:8px">
					  <input type="radio"
					     class="radiol" 
						 name="MailDocumentId" 						
						 value="hide" checked
						 onclick="_cf_loadingtexthtml='';document.getElementById('MailDocumentId').value='hide';ptoken.navigate('#session.root#/vactrack/application/candidate/action/setMailMessage.cfm?documentid=hide&ObjectId=#Object.ObjectId#&PersonNo=#url.PersonNo#&actioncode=#url.actioncode#&functionid=#function.FunctionId#&objectactionid=#url.actionid#','mail','','','POST','activityform')">
					  </td>
				  	  <td style="font-size:17px;padding-left:4px;padding-top:3px">No mail</td>
				  
					  <cfloop query="getMail">
					  					  
					  <td style="font-size:17px;padding-left:8px">
					  <input type="radio"
					     class="radiol" 
						 name="MailDocumentId" 
						 id="MailDocumentId" 
						 value="#documentId#" 
						 onclick="_cf_loadingtexthtml='';;document.getElementById('MailDocumentId').value='#documentid#';ptoken.navigate('#session.root#/vactrack/application/candidate/action/setMailMessage.cfm?documentid=#documentid#&ObjectId=#Object.ObjectId#&PersonNo=#url.PersonNo#&actioncode=#url.actioncode#&functionid=#function.FunctionId#&actionid=#url.actionid#&objectactionid=#url.actionid#','mail','','','POST','activityform')">
					  </td>
					  <td style="font-size:17px;padding-left:4px;padding-top:3px">
					  #DocumentDescription#
					  </td>
					  </cfloop>
					  
					  </tr>
					  </table>
					 				  
				  <cfelse>
				  
				  <td style="padding-right:1px">
				  
				 <select name="MailDocumentId" id="MailDocumentId" class="regularxxl" 
				       onchange="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/vactrack/application/candidate/action/setMailMessage.cfm?documentid='+this.value+'&ObjectId=#Object.ObjectId#&PersonNo=#url.PersonNo#&actioncode=#url.actioncode#&functionid=#function.FunctionId#&actionid=#url.actionid#&objectactionid=#url.actionid#','mail','','','POST','activityform')">
					   
					 	<option value="hide" selected><cf_tl id="No Mail, just a comment"></option>
						
						<cfloop query="getMail">
							<option value="#DocumentId#">#DocumentDescription#</option>
						</cfloop>
						<option value=""><cf_tl id="Custom drafted mail"></option>
					
				</select>	
				
				</td>
				
				</cfif>
				
				 <td align="right" style="font-size:20px"><cf_tl id="Outgoing MAIL message"></td>
			
				   			   
			   </tr>
			   
			   </table>
			   
			</td>
			
			</tr>	
			
			<!--- contentbox for mail --->
			<tr><td id="mail" colspan="2" style="height:413px;padding-left:0px"></td></tr>
			
		</cfif>
		
			
		<tr><td colspan="2" align="center">
		
			<table class="formspacing">
				<tr>
					<td><input type="button" class="button10g" value="Close" onclick="ProsisUI.closeWindow('activitybox')"></td>
					<td><input type="button" class="button10g" value="Save and Send" onclick="ptoken.navigate('#session.root#/vactrack/application/candidate/action/actionsubmit.cfm?actionid=#url.id#&documentNo=#url.documentno#&PersonNo=#url.PersonNo#&actioncode=#url.actioncode#&objectactionid=#url.actionid#','actionsubmit','','','POST','activityform')"></td>
				</tr>
			</table>
		
		</td></tr>
		
		<tr><td id="actionsubmit"></td></tr>
			
	</table>
	
	</cfoutput>

</cfform>

<cfset ajaxOnload("doCalendar")>
<cfset ajaxonload("initTextArea")>