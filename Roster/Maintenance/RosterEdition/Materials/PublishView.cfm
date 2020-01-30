

<cfparam name="Object.ObjectKeyValue1" default="">
<cfparam name="url.submissionedition" default="#Object.ObjectKeyValue1#">

<cfparam name="Action.ActionId" default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.ActionId" default="#Action.ActionId#">

<table width="94%" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td class="labellarge" style="height:35px;padding-left:20px">Generated Edition Job Profiles</td></tr>
	
	<tr><td class="linedotted"></td></tr>
	<tr><td  style="height:30;padding-left:10px;padding-right:10px;padding-bottom:10px" align="center" id="documentscontent">	
		<cfinclude template="PublishDocument.cfm">
	</td></tr>

	<cfoutput>
	
	<TR>
		<TD height="30" style="width:95%;height:40px;padding:5px;padding-left:5px;border:1px solid silver" align="center" id="setdocument">	
		
		  <cfset buttonValue = "Prepare Job Profiles">
		  
		  <cfif DirectoryExists("#SESSION.rootDocumentPath#/RosterEdition/#url.submissionedition#") eq "Yes">
		  		<cfset buttonValue = "Refresh Job Profiles">
		  </cfif>
			
			<input type="button" 
			       id="Send" 
				   name="Send" 
				   value="#buttonValue#" 
				   class="button10g"
			       style="height:28;width:210" 
				   onclick="doPrepare('#url.submissionedition#','#url.actionid#')">			

			<cfset Session.Status = 0>
			
			<cfprogressbar name="pBar" 
			    style="height:40px;bgcolor:silver;progresscolor:black;border:0px" 					
				height="20" 
				bind="cfc:service.Authorization.AuthorizationBatch.getstatus()"				
				interval="1000" 
				autoDisplay="false" 
				width="506"/> 
				   
		</TD>		
	</TR>
	
	</cfoutput>
	<!---
	<tr><td class="linedotted"></td></tr>
	
	<tr>
		<td colspan="3" height="100%">	
		<cfset url.scope = "workflow">
		<cf_divscroll id="contentbox">
			<cfinclude template="PublishTextContent.cfm">
		</cf_divscroll>			
		</td>	
	</tr>
	--->
</table>