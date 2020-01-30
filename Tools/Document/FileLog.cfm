
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
			
<table width="93%" border="0" cellspacing="0" align="right">

	<tr><td height="1"></td></tr>
	
	<tr>
	  <td width="30"></td> 
	  <td width="120" class="labelsmall"><cf_tl id="Timestamp"></td>
	  <td width="160" class="labelsmall"><cf_tl id="Name"></td>
	  <td width="130" class="labelsmall"><cf_tl id="Action"></td>
	  <td width="45%" class="labelsmall"><cf_tl id="Memo"></td>	 
	</tr>	
	<tr><td colspan="5" class="linedotted"></td></tr>
		
	<cfoutput query="Action">
		
		<tr>
		  <td height="18" class="labelit">#currentRow#.&nbsp;</td> 
		  <cfif (FileAction eq "Insert" or FileAction eq "update")>
		  
		  <cfif att.server eq "document">
		    <cfset svr = "#SESSION.rootdocumentpath#">
		  <cfelse>
		     <cfset svr = "#att.server#">
		  </cfif> 		
		  			  	
		  <td class="labelit" onclick="showfilelog('#attachmentid#','#serialno#')">
		      <cfif FileExists("#svr#\#att.serverpath#\Logging\#att.attachmentid#\[#serialno#]_#att.fileName#")>	    
			  <a href="##"><font color="0080FF">#DateFormat(Created,CLIENT.DateFormatShow)# #TimeFormat(Created,"HH:MM")#</font></a>
			  <cfelse>
			  #DateFormat(Created,CLIENT.DateFormatShow)# #TimeFormat(Created,"HH:MM")#	  	
			  </cfif>		  	
		  </td>
		  <cfelse>
		  <td class="labelit">
		 	#DateFormat(Created,CLIENT.DateFormatShow)# #TimeFormat(Created,"HH:MM")#	  	
		  </td>
		  </cfif>
		  <td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
		  <td class="labelit">#FileAction#</td>
		  <td class="labelit">#FileActionMemo#</td>		
		</tr> 
				
	</cfoutput>		
		
</table>