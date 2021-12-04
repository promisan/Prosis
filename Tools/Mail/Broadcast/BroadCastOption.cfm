
<cfform name="formoption" method="POST" onSubmit="return false;">	
	
	<cfif url.id neq "">
		
		<cfquery name="Broadcast" 
		   datasource="AppsSystem" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			  SELECT *
			  FROM  Broadcast
			  WHERE BroadcastId = '#URL.ID#'
		</cfquery>
	
	<cfelse>
		
		<cfquery name="Broadcast" 
		   datasource="AppsSystem" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			  SELECT TOP 1 *
			  FROM  Broadcast
			  WHERE OfficeruserId = '#SESSION.acc#'
			  ORDER BY Created DESC
		</cfquery>
		
		<cfset url.id = Broadcast.BroadcastId>	
	
	</cfif>
	
	<cfquery name="qOwner" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
			SELECT Owner
			FROM Applicant.dbo.RosterSearch
			WHERE SearchId = '#Broadcast.BroadcastReferenceNo#'
	</cfquery>		
	
	
	<cfquery name="qEmails" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT eMailAddress,FailToMailAddress
	  	FROM Organization.dbo.Ref_AuthorizationRoleOwner 
		WHERE Code = '#qOwner.Owner#'
	</cfquery>
	
	
	<cfif qEmails.eMailAddress neq "">
		<cfset vBroadCastFrom = qEmails.eMailAddress>
		<cfset vBroadCastReply = qEmails.eMailAddress>
	<cfelse>	
		<cfset vBroadCastFrom = broadcast.broadcastFrom>
		<cfset vBroadCastReply = broadcast.broadcastReplyTo>
	</cfif>	
	
	<cfif qEmails.FailToMailAddress eq "">
		<cfset vBroadCastFail = qEmails.FailToMailAddress>
	<cfelse>	
		<cfset vBroadCastFail = broadcast.broadcastFailTo>
	</cfif>	
	
	<cfif Broadcast.recordcount eq "0">
		<script>
		alert("Broadcast was removed. Action aborted")
		ptoken.navigate('BroadCastHistory.cfm?mode=#url.mode#','contentbox2')
		window.close()
		</script>
		<cfabort>
	</cfif>
	
	<cfoutput>
	
	<table width="100%" bgcolor="ffffff" align="center" cellspacing="0" cellpadding="0">
	
	<tr><td height="12"></td></tr>
	
	<tr><td>
	
	<table width="96%" border="0" align="center" class="formpadding formspacing" cellspacing="0" cellpadding="0">
	
	<cfif Broadcast.BroadcastStatus eq "0">
		
		<tr class="fixlengthlist">
			<td class="labelmedium2" height="20"><cf_tl id="Schedule">:</td>
			<td>
				
			<table cellspacing="0" cellpadding="0"><tr><td class="labelmedium2">
			<input type="radio" name="Schedule" id="Schedule" class="radiol" value="0" checked></td><td style="padding-left:5px" class="labelmedium2">Immediate</td>
			<td style="padding-left:15px"><input type="radio" class="radiol" disabled name="Schedule" id="Schedule" value="1"></td><td style="padding-left:5px" class="labelmedium2">Date:</td>
			</td><td style="padding-left:5px">
				<cf_intelliCalendarDate9
						FieldName="BroadcastDate" 
						Default="#broadcast.broadcastDate#"
						AllowBlank="True"
						Class="regularxxl">	
				</td>				
			</tr></table>	
							
			</td>
		</tr>
		
	</cfif>
	
	<tr  class="fixlengthlist">
		<td class="labelmedium2" height="20" width="120">Sent by:</td>
		<td height="20" width="80%" class="labelmedium2">
		
		  <cfif Broadcast.BroadcastStatus eq "0">
		
		  	<cfif isValid("email",vBroadCastFrom)>
				  
			   <cfinput type="Text"
			       name="BroadcastFrom"
			       required="No"
			       visible="No"
			       enabled="Yes"
				   value="#vBroadCastFrom#"
			       showautosuggestloadingicon="False"
				   validate="email"
	   			   message="Please enter a valid Sent By address."
			       typeahead="No"
				   class="regularxxl"
				   maxlength="50"
			       size="40">
			   
			<cfelse>
				   
				   <cfinput type="Text"
			       name="BroadcastFrom"
			       required="No"
			       visible="No"
			       enabled="Yes"
				   value="#client.eMailDefault#"
			       showautosuggestloadingicon="False"
				   message="Please enter a valid Sent By address."
	  			   validate="email"
			       typeahead="No"
				   class="regularxxl"
				   maxlength="50"
			       size="40">
			   		   
			</cfif>
			   
		  <cfelse>
		  
		    #broadcast.broadcastFrom#
			
		  </cfif> 
		   
		</td>
	</tr>
	
	<tr  class="fixlengthlist">
		<td class="labelmedium2">Reply address:</td>
		<td height="20" class="labelmedium2">
		 <cfif Broadcast.BroadcastStatus eq "0">
			<cfinput type="Text"
	       name="BroadcastReplyTo"
	       required="No"
	       visible="No"
	       enabled="Yes"
		   value="#vBroadCastReply#"
	       showautosuggestloadingicon="False"
		   message="Please enter a valid Repply To address"
	       typeahead="No"
		   class="regularxxl"
		   validate="email"
		   maxlength="50"
	       size="40">
		   <cfelse>
		    #broadcast.broadcastReplyTo#
		  </cfif> 
		</td>
	</tr>
	
	<tr class="fixlengthlist">
		<td class="labelmedium2">Fail to:</td>
		<td height="20" class="labelmedium2">
		 <cfif Broadcast.BroadcastStatus eq "0">
		  <cfinput type="Text"
	       name="BroadcastFailTo"
	       validate="email"
	       required="No"
		   value="#vBroadCastFail#"
	       visible="No"
	       enabled="Yes"
	       showautosuggestloadingicon="False"
	       typeahead="No"
		   message="Please enter a valid Fail To address"
		   class="regularxxl"
		   maxlength="50"
	       size="40">
		   <cfelse>
		    #broadcast.broadcastFailTo#
		  </cfif> 
		   </td>
	</tr>
	
	<tr class="fixlengthlist">
		<td class="labelmedium2">Priority:</td>
		<td height="20" class="labelmedium2">
		<cfif Broadcast.BroadcastStatus eq "0">
			<table class="formspacing">
			<tr>
			<td><input type="radio" class="radiol" name="BroadcastPriority" id="BroadcastPriority" <cfif broadcast.broadcastpriority eq "1">checked</cfif> value="1"></td><td class="labelmedium2">High</td>
			<td style="padding-left:4px"><input type="radio" class="radiol" name="BroadcastPriority" id="BroadcastPriority" <cfif broadcast.broadcastpriority eq "3" or Broadcast.broadcastpriority eq "">checked</cfif> value="3"></td><td class="labelmedium2">Normal</td>
			<td style="padding-left:4px"><input type="radio" class="radiol" name="BroadcastPriority" id="BroadcastPriority" <cfif broadcast.broadcastpriority eq "5">checked</cfif> value="3"></td><td class="labelmedium2">Low</td>
			</tr>	
			</table>
		<cfelse>	  
		   
		   <cfif broadcast.broadcastpriority eq "1">High
		   <cfelseif broadcast.broadcastpriority eq "3">Normal
		   <cfelse>Low
		   </cfif>
		
		</cfif>	
		
		
		</td>
	</tr>
	
	<tr class="fixlengthlist">
		<td class="labelmedium2">Mailer Id:</td>
		<td height="20" class="labelmedium2">
		<cfif Broadcast.BroadcastStatus eq "0">
		<input type="text" class="regularxxl" value="#broadcast.broadcastMailerId#" name="BroadcastMailerId" id="BroadcastMailerId" size="30" maxlength="30">
		<cfelse>
		#broadcast.broadcastMailerId#
		</cfif>
		
		</td>
	</tr>
	
	<tr class="fixlengthlist">
		<td class="labelmedium2">Recipients:</td>
		<td class="labelmedium2" style="height:30px">
		
		  <cfquery name="Recipient" 
		   datasource="AppsSystem" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			  SELECT *
			  FROM  BroadcastRecipient
			  WHERE BroadcastId = '#URL.ID#' 
			  AND Selected = 1
		  </cfquery>
		  <cfoutput>#recipient.recordcount#</cfoutput>
		  
		</td>
	</tr>
	
	<tr class="fixlengthlist">
		<td class="labelmedium2" height="20" style="padding-right:40px">eMail Confirmation:</td>
		<td class="labelmedium2">
		<cfif Broadcast.BroadcastStatus eq "0">
		<input type="checkbox" class="radiol" name="BroadcastBCC" id="BroadcastBCC" <cfif broadcast.broadcastbcc eq "1">checked</cfif> value="1">
		<cfelse>
		  <cfif broadcast.broadcastbcc eq "1">Yes<cfelse>No</cfif>
		</cfif>
		</td>
	</tr>
	
	
	<tr class="fixlengthlist">
		<td class="labelmedium2" height="20">Additional CC address:</td>
		<td height="20" class="labelmedium2">
		
		 <cfif Broadcast.BroadcastStatus eq "0">
			
			<cfinput type="Text"
		       name="BroadcastCC"
		       validate="email"
		       required="No"
		       visible="No"
		       enabled="Yes"
			   message="Please enter a valid eMail address"
			   value="#broadcast.broadcastCC#"    
			   class="regularxxl"
			   maxlength="50"
		       size="40">
			   <cfelse>
			    #broadcast.broadcastCC#
		  </cfif> 
		  
		</td>
	</tr>
	
	<tr class="fixlengthlist">
		<td class="labelmedium2" height="20">Memo:</td>
		<td class="labelmedium2">
		<cfif Broadcast.BroadcastStatus eq "0">
		<input type="text" class="regularxxl" name="BroadcastMemo" id="BroadcastMemo" value="#broadcast.broadcastmemo#" style="width:99%" size="70" maxlength="100">
		<cfelse>
		#broadcast.broadcastmemo#
		</cfif>
		</td>
	</tr>
	
	<tr class="fixlengthlist">
		<td valign="top" style="padding-top:6px" class="labelmedium2" height="25">Attachments:</td>
		<td class="labelmedium2">
		<cf_securediv bind="url:BroadcastAttachment.cfm?id=#url.id#">	
		</td>
		
	</tr>
	
	<tr><td height="4"></td></tr>
	<tr><td colspan="2" height="1" class="line"></td></tr>
	
	<cfif Broadcast.Broadcaststatus eq "0">
	
	<tr><td colspan="2" align="center" height="30">		  
	  	<input type="button" style="width:140px" name="Save" id="Save" value="Save" class="button10g" onclick="saveSettings();">		  
	    </td>
	</tr>
	  
	</cfif>  
			  
	<tr><td height="10"></td></tr>
	
	</table>
	
	</table>
	
	</cfoutput>
	
</cfform>

<cfset ajaxonload("doCalendar")>
