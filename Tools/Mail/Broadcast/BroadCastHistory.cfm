
<cfparam name="URL.ID" default="">

<cfset currrow = 0>

<cfquery name="History" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT *
	  FROM  Broadcast
	  WHERE OfficerUserId = '#SESSION.acc#'
	  ORDER BY BroadCastStatus, Created DESC
</cfquery>

<cfparam name="URL.page" default="1">
	
<cfset counted = history.recordcount>
<cf_PageCountN count="#history.recordcount#" show="22">
<cfset per = URL.Page*20-20>
<cfset perT = "">
<cfset link = "BroadCastHistory.cfm">

<table width="94%" align="center" class="navigation_table">
 <tr><td height="7" id="select"></td></tr>
 <tr><td colspan="7"><cfinclude template="BroadCastNavigation.cfm"></td></tr>
 <tr height="20" class="labelmedium line">
     <td width="20" align="center"></td>
     <td align="center">No.</td>
     <td>Audience</td>
	 <td>Description</td>
	 <td>Subject</td>
	 <td>Sent</td>
	 <td width="20"></td>
 </tr>
 
 <cfoutput query="history">
 
 <cfset currrow = currrow + 1>
			
 <cfif currrow gte first and currrow lte last>
 
 <cfif url.id eq broadcastid>
   <cfset color = "ffffaf">
 <cfelse>
   <cfset color = "transparent">  
 </cfif>
 
 <tr bgcolor="#color#" id="r#currentrow#" class="labelmedium2 navigation_row line">
	
	<td width="25" align="center">
		<cfif broadcaststatus eq "0" and url.id neq broadcastid>
		  <cf_img icon="edit" navigation="Yes" onclick="broadcastreload('#broadcastid#')">
		<cfelseif broadcaststatus eq "1" and url.id neq broadcastid>
		  <cf_img icon="open" navigation="Yes" onclick="broadcastreload('#broadcastid#')">		
		</cfif>
	</td>
    <td align="center">#currentrow#</td>
	<TD>#BroadcastRecipient#</TD>
	<TD>#BroadcastReference#</TD>
	<TD>#BroadcastSubject#</TD>
	<td><cfif broadcaststatus eq "1">
	      #dateformat(broadcastSent,CLIENT.DateFormatShow)# #timeformat(broadcastSent,"HH:MM:SS")#
	    <cfelse>
	      <font color="6688aa">Pending
	    </cfif></td>
	<td align="right" style="padding-right:4px;padding-top:3px">
	<!---
	<cfif broadcaststatus eq "0" and url.id neq broadcastid>
	--->
	 <cf_img icon="delete" onclick="#ajaxLink('BroadCastHistoryDelete.cfm?del=#broadcastid#&id=#url.id#&page=#url.page#')#">
	
	<!---	 
	</cfif>
	--->
	</td>	
 </tr>
  
 </cfif>
 
 </cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>	
