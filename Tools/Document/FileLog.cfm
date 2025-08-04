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

<cfquery name="Att" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
    FROM      Attachment
	WHERE     AttachmentId = '#url.id#'   	
</cfquery>

<cfquery name="Action" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    TOP 30 *
    FROM      AttachmentLog
	WHERE     AttachmentId = '#url.id#'   
	ORDER BY  Created DESC	
</cfquery>

<cfparam name="client.logattachment" default="0">
			
<table width="93%" align="right" class="navigation_table">
		
	<tr class="labelmedium line fixlengthlist">
	  <td></td> 
	  <td style="min-width:100px"><cf_tl id="Timestamp"></td>
	  <td style="width:100%"><cf_tl id="Actor"></td>
	  <td style="min-width:80px"><cf_tl id="Action"></td>
	  <td style="min-width:200px"><cf_tl id="Memo"></td>	 
	</tr>	
		
	<cfoutput query="Action">
		
		<tr class="labelmedium <cfif currentrow neq recordcount>line</cfif> navigation_row fixlengthlist" style="height:20px">
		  <td>#currentRow#.</td> 
		  <cfif (FileAction eq "Insert" or FileAction eq "update")>
		  
		  <cfif att.server eq "document">
		    <cfset svr = "#SESSION.rootdocumentpath#">
		  <cfelse>
		     <cfset svr = "#att.server#">
		  </cfif> 		
		  			  	
		  <td onclick="showfilelog('#attachmentid#','#serialno#')">		
		      <cfif FileExists("#svr#\#att.serverpath#\Logging\#att.attachmentid#\[#serialno#]_#att.fileName#")>	    
			  <a href="##">#DateFormat(Created,CLIENT.DateFormatShow)# #TimeFormat(Created,"HH:MM")#</a>
			  <cfelse>
			  #DateFormat(Created,CLIENT.DateFormatShow)# #TimeFormat(Created,"HH:MM")#	  	
			  </cfif>		  	
		  </td>
		  <cfelse>
		  <td>
		 	#DateFormat(Created,CLIENT.DateFormatShow)# #TimeFormat(Created,"HH:MM")#	  	
		  </td>
		  </cfif>
		  <td>#OfficerFirstName# #OfficerLastName#</td>
		  <td>#FileAction#</td>
		  <td>#FileActionMemo#</td>		
		</tr> 
				
	</cfoutput>		
			
</table>

<cfset ajaxonload("doHighlight")>
