
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
		
	<tr class="labelmedium line">
	  <td width="30"></td> 
	  <td width="120"><cf_tl id="Timestamp"></td>
	  <td width="160"><cf_tl id="Name"></td>
	  <td width="130"><cf_tl id="Action"></td>
	  <td width="45%"><cf_tl id="Memo"></td>	 
	</tr>	
		
	<cfoutput query="Action">
		
		<tr class="labelmedium line navigation_row" style="height:20px">
		  <td style="padding-left:4px">#currentRow#.</td> 
		  <cfif (FileAction eq "Insert" or FileAction eq "update")>
		  
		  <cfif att.server eq "document">
		    <cfset svr = "#SESSION.rootdocumentpath#">
		  <cfelse>
		     <cfset svr = "#att.server#">
		  </cfif> 		
		  			  	
		  <td class="labelit" onclick="showfilelog('#attachmentid#','#serialno#')">
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
