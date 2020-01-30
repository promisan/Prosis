

<cfquery name="BroadCast" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT *
	  FROM  Broadcast
	  WHERE BroadcastId = '#URL.ID#' 	 
</cfquery>

<!--- prepares dynamic fields to be parsed --->
<cfinclude template="BroadCastContext.cfm">

<cfquery name="Recipient" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT *
	  FROM  BroadcastRecipient
	  WHERE BroadcastId = '#URL.ID#' 
	  AND   RecipientId = '#URL.recipientid#'	 
</cfquery>

<cf_screentop height="100%" scroll="No" layout="webapp" user="No" label="Mail Preview">

<cfoutput query="recipient">

<table width="95%" cellspacing="0" cellpadding="0" class="formpadding" align="center">
	<tr class="linedotted labelmedium">
		<td>
			<b>To:</b>
		</td>
		<td>#RecipientName# (<b>#eMailAddress#</b>)</td>
	</tr>
	<tr class="linedotted labelmedium">
		<td>
			<b>Subject:</b>
		</td>
		<td>
			#BroadCast.BroadCastSubject#
		</td>
	</tr>

	<tr>
		<td colspan="2" style="padding-left:10px;">
		<!--- loop through the fields  --->
		<cfset body = BroadCast.BroadcastContent>
		<cfinclude template="BroadCastParse.cfm">
		#body#
		</td>
	</tr>
</table>

<cf_screenbottom layout="webapp">

</cfoutput>