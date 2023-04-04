
<cfparam name="mailattachment" default="">
<cfparam name="url.actionid" default="">
<cfparam name="url.objectid" default="">
<cfparam name="url.last"     default="0">

<cfquery name="Mail" 
 	datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 <cfif url.last eq "0">
	 SELECT   *
	 <cfelse>
	 SELECT   TOP 1 *
	 </cfif>
	 FROM     OrganizationObjectActionMail
	 <cfif url.actionid neq "">
	 WHERE    ActionId = '#URL.ActionId#'		
	 <cfelse>
	 WHERE    ObjectId = '#URL.ObjectId#'	
	 </cfif>
	 AND  MailType <> 'Comment'
	 ORDER BY Created DESC
</cfquery>

<cfif Mail.recordcount gte "1">
			
	<table width="96%" border="0" align="center">
	   
 	  <cfoutput query="Mail" group="ThreadId">
	  
	  <cfoutput group="SerialNo">
	  	  				
		<tr class="line">
		
				<td colspan="3" style="height:30px">

				<table cellspacing="0" cellpadding="0">
					<tr><td style="padding-left:4px">
					<img src="#SESSION.root#/Images/Mail-Open.png" height="32" align="absmiddle" alt="eMail document" border="0">
					</td>
					<td style="padding-left:8px;font-size:20px" class="labelmedium">
					#ucase(MailType)# <cf_tl id="recorded on"> <b>#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")# by #Mail.OfficerFirstName# #Mail.OfficerLastName#
					</td>
					</tr>
				</table>
		
		</td>
		</tr>
				
		<cfif MailType neq "Notes">			
						
			<tr class="line fixlengthlist">
				  <td height="20" class="labelit" width="120" style="height:25px;padding-left:10px"><cf_tl id="Addressee">:</td>
				  <td width="85%" style="word-wrap: break-word; word-break: break-all;" class="labelmedium">#MailTo#
				   <!---
				  	<cfoutput group="MailTo">
				  	#MailTo# <cfif currentrow neq recordcount></cfif>
				  	</cfoutput>
				  	--->
				  </td>
			</tr>
					
			<cfif MailCC neq "">			
			<tr  class="line fixlengthlist">
				  <td height="20" width="120" class="labelit" style="height:25px;padding-left:10px">Cc:</td>
				  <td width="85%" class="labelmedium"> #MailCC#
				  <!---
				  <cfoutput group="MailCc">
				  #MailCc#,</cfoutput>
				  --->
				  </td>
			</tr>
			</cfif>
			
			<tr class="line fixlengthlist">
				<td height="20" class="labelit" style="height:25px;padding-left:10px"><cf_tl id="Subject">:</td>
				<td class="labelmedium">#MailSubject#</td>
			</tr>	
			<tr><td colspan="2" class="linedotted"></td></tr>	
		
		</cfif> 
					
		<tr class="fixlengthlist">
			<td height="20" style="padding-top:4px;padding-left:10px" valign="top" class="labelit"><cf_tl id="Body">:</td>			
			<td style="padding-top:5px;padding-bottom:5px" class="labelit">#MailBody#</td>
		</tr>
		
		
														
		<cfif mailattachment neq "">	
					
		<tr class="linedotted fixlengthlist">
			<td valign="top" style="padding-left:10px" class="labelit"><cf_tl id="Attachments">:</td>
			<td colspan="1" class="labelit">
				<cfloop index="att" list="#mailattachment#">- #att#<br></cfloop>
			</td>
		</tr>
				
		</cfif>
				
		</cfoutput>
								
		</cfoutput> 
		
		<cfif url.objectid neq "">
				
			<cfquery name="Object" 
				 	datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT   *
					 FROM     OrganizationObject
					 WHERE    ObjectId = '#URL.ObjectId#'	
			</cfquery>
				
			 <tr class="linedotted fixlengthlist">
				<td valign="top" style="padding-left:10px" class="labelit"><cf_tl id="Attachments">:</td>
				<td colspan="1" class="labelit">
			
			     <cf_filelibraryN
					DocumentPath  = "#Object.EntityCode#"
					SubDirectory  = "#ObjectId#" 
					Filter        = ""
					LoadScript    = "No"
					color         = "f4f4f4"
					AttachDialog  = "No"
					Width         = "100%"
					Box           = "ext_mail"
					rowheader     = "No"
					Insert        = "no"
					Remove        = "no">	
			
				</td>
			</tr>		
		
		</cfif>
		
		</table>
		
</cfif>		
