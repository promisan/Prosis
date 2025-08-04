<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="URL.ID" default="">

<cfset currrow = 0>

<cfquery name="History" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT *
	  FROM  Broadcast
	  WHERE OfficerUserId = '#SESSION.acc#'
	  ORDER BY Created DESC
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
 <tr height="20" class="labelmedium2 line fixlengthlist">
     <td width="20" align="center"></td>
     <td align="center">No.</td>
     <td>Audience</td>
	 <td>Description</td>
	 <td>Subject</td>
	 <td>Initiated</td>
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
 
 <tr bgcolor="#color#" id="r#currentrow#" class="labelmedium2 navigation_row line fixlengthlist">
	
	<td width="25" align="center">
		<cfif broadcaststatus eq "0" and url.id neq broadcastid>
		  <cf_img icon="open" navigation="Yes" onclick="broadcastreload('#broadcastid#')">
		<cfelseif broadcaststatus eq "1" and url.id neq broadcastid>
		  <cf_img icon="select" navigation="Yes" onclick="broadcastreload('#broadcastid#')">		
		</cfif>
	</td>
    <td align="center">#currentrow#</td>
	<TD>#BroadcastRecipient#</TD>
	<TD>#BroadcastReference#</TD>
	<TD>#BroadcastSubject#</TD>
	<TD>#dateformat(Created,client.dateformatshow)#</TD>
	<td><cfif broadcaststatus eq "1">
	      #dateformat(broadcastSent,CLIENT.DateFormatShow)# #timeformat(broadcastSent,"HH:MM:SS")#
	    <cfelse>
	      <font color="gray">Pending</font>
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
