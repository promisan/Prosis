
<cfparam name="mailattachment" default="">

<cfquery name="Mail" 
 	datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     OrganizationObjectActionMail
	 WHERE    ActionId = '#URL.ActionId#'		
	 ORDER BY Created DESC
</cfquery>

<cfif Mail.recordcount gte "1">
			
	<table width="96%" border="0" align="center" cellspacing="0" cellpadding="0">
	   
 	  <cfoutput query="Mail" group="ThreadId">
	  
	  <cfoutput group="SerialNo">
	  	  				
		<tr class="line">
		
				<td colspan="3" style="height:30px" bgcolor="f1f1f1">

		<table cellspacing="0" cellpadding="0">
			<tr><td style="padding-left:4px">
			<img src="#SESSION.root#/Images/Mail-Open.png" height="32" align="absmiddle" alt="eMail document" border="0">
			</td>
			<td style="padding-left:8px" class="labelmedium">
			#ucase(MailType)# <cf_tl id="recorded on"> <b>#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")# by #Mail.OfficerFirstName# #Mail.OfficerLastName#
			</td>
			</tr>
		</table>
		
		</td>
		</tr>
		
		
		<cfif MailType neq "Notes">		
		
						
			<tr class="line">
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
			<tr  class="line">
				  <td height="20" width="120" class="labelit" style="height:25px;padding-left:10px">Cc:</td>
				  <td width="85%" class="labelmedium"> #MailCC#
				  <!---
				  <cfoutput group="MailCc">
				  #MailCc#,</cfoutput>
				  --->
				  </td>
			</tr>
			</cfif>
			
			<tr class="line">
				<td height="20" class="labelit" style="height:25px;padding-left:10px"><cf_tl id="Subject">:</td>
				<td class="labelmedium">#MailSubject#</td>
			</tr>	
			<tr><td colspan="2" class="linedotted"></td></tr>	
		
		</cfif> 
					
		<tr>
			<td height="20" style="padding-top:4px;padding-left:10px" valign="top" class="labelit"><cf_tl id="Body">:</td>			
			<td style="padding-top:5px;padding-bottom:5px" class="labelit">#MailBody#</td>
		</tr>
												
		<cfif mailattachment neq "">		
		<tr  class="linedotted">
			<td valign="top" style="padding-left:10px" class="labelit"><cf_tl id="Attachments">:</td>
			<td colspan="1" class="labelit">
				<cfloop index="att" list="#mailattachment#">- #att#<br></cfloop>
			</td>
		</tr>
		
		</cfif>
				
		</cfoutput>
		
		<tr><td height="10" colspan="2" style="border-top:1px solid silver"></td>
						
		</cfoutput> 
		
		</table>
		
</cfif>		
