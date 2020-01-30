
<cfset link = "BroadCastRecipientLine.cfm?id=#url.id#">

<table width="98%" align="center" cellspacing="0" cellpadding="0">
 <tr><td height="10"></td></tr>
  
<cfquery name="Check" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Broadcast
	  WHERE  BroadcastId     = '#URL.Id#'   
</cfquery>

<cfif Check.broadcaststatus eq "0">
	
	<cfif check.SystemFunctionId eq "">
	
	 <tr><td class="labelmedium" style="font-weight:200;padding-left:17px">
	 
			   <cf_selectlookup
			    class    = "User"
			    box      = "recipient"
				title    = "Add a Mail Recipient"				
				link     = "#link#"			
				dbtable  = "System.dbo.BroadcastRecipient"
				des1     = "Account">
						
			</td>
			</tr> 
	 
	 </td></tr>
	</cfif> 

</cfif>
 
<tr><td>

<cfdiv bind="url:#link#" id="recipient"/>
 
</td></tr>

</table>




