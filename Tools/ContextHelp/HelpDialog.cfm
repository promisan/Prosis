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

<cfparam name="URL.topicid" default="00000000-0000-0000-0000-000000000000">

<cfif url.topicid eq "">
	<table width="100%" height="100%"><tr><td bgcolor="D4d4d4">
	<cf_message message="Problem, context help could not be located">
	</td></tr>
	</table>
	<cfabort>
</cfif>

<cfajaximport tags="cfform,cfmenu,cftree,cfdiv">

<cfquery name="HelpTopic" 
		datasource="AppsSystem"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  HelpProjectTopic
			WHERE TopicId   = <cfqueryparam
					value="#URL.TopicId#"
				    cfsqltype="CF_SQL_IDSTAMP">
</cfquery>

<cfif HelpTopic.recordcount eq "0">
		
	<cfquery name="HelpTopic" 
			datasource="AppsSystem"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  HelpProjectTopic
				WHERE SystemFunctionId  = <cfqueryparam
						value="#URL.TopicId#"
					    cfsqltype="CF_SQL_IDSTAMP">
				ORDER BY ListingOrder		
	</cfquery>
	
	<cfset url.systemfunctionid = helptopic.systemfunctionid>	
	<cfset url.mode = "systemmodule">			
		
<cfelse>

	<cfset url.mode = "project">	
	<cfset url.systemfunctionid = helptopic.systemfunctionid>

</cfif>

<cfoutput>

<script language="JavaScript">

    function showcontent() {	
		ColdFusion.Layout.showArea('container','left')
		ColdFusion.navigate('HelpDialogTree.cfm?projectcode=#HelpTopic.projectcode#','left')	
	}
		
	function search() {	
		ColdFusion.Layout.showArea('container','left')
		ColdFusion.navigate('HelpDialogSearch.cfm?projectcode=#HelpTopic.projectcode#','left')	
	}
		
	function check() {
		 
	 if (window.event.keyCode == "13")
		{	document.getElementById("searchicon").click() }						
    }
	
	function feedback(id,rating) {
		ColdFusion.navigate('HelpDialogFeedbackEntry.cfm?topicid='+id+'&rating='+rating,'feedback')	
	}
	
	function feedbackreturn(id) {
		ColdFusion.navigate('HelpDialogFeedback.cfm?topicid='+id,'feedback')	
	}
	
	function find(val) {	
		ColdFusion.navigate('HelpDialogSearchResult.cfm?mode=#url.mode#&projectcode=#HelpTopic.projectcode#&systemfunctionid=#HelpTopic.SystemFunctionid#&val='+val,'findme')	
	}
	
	function printpdf() {
	id = document.getElementById('topicid').value
	if (id != '') {
	window.open("HelpDialogPrint.cfm?TopicId="+id,"helppdf","width=800, height=735, status=no, toolbar=no, scrollbars=no, resizable=yes, modal=yes")
	}
	}
	
	function reloadtext(id) {
	ColdFusion.navigate('HelpDialogTopic.cfm?topicid='+id,"textbox",mycallBack,myerrorhandler)
	}
	
	function mycallBack(text) { }
	
	<!-- alert("Callback: " + text); -->
		
	var myerrorhandler = function(errorCode,errorMessage){
			alert("[In Error Handler]" + "\n\n" + "Error Code: " + errorCode + "\n\n" + "Error Message: " + errorMessage);
	}	
	
</script>	

</cfoutput>

<cfsavecontent variable="option">
	
	<table  height="100%" width="100%" cellspacing="0" cellpadding="0">
	<tr>
	<td><a href="javascript:printpdf()"><font color="black">Print Topic</a></td>
	</tr>
	</table>	

</cfsavecontent>

<cf_screentop height="100%" 
    jQuery="Yes" banner="gray" bannerforce="yes" band="No" border="0" 
	option="#option#" 
	html="Yes" 
	label="#HelpTopic.ProjectCode# - #HelpTopic.TopicName#" 
	layout="webapp">
	
	<cfset projectName = "#HelpTopic.ProjectCode#">
	<cfset url.projectcode = HelpTopic.projectcode>
	
	<table width="100%" height="100%" bgcolor="ffffff" align="right" height="100%" cellspacing="0" cellpadding="0">
	   
		<tr>
		  <td valign="top" bgcolor="e6e6e6" height="100%" id="left" width="220" style="border-right:1px solid silver">
		    
			<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			
				<tr><td height="10">			
				  <cfinclude template="HelpDialogSearch.cfm">			
				</td></tr>
						
				<tr><td bgcolor="ffffff">		
				    <cf_divscroll style="height:100%">	
				    <cfinclude template="HelpDialogSearchResult.cfm">
					</cf_divscroll>
				</td></tr>			
			
			</table>		    
			
		  </td>
		  
		  <td id="textbox" valign="top" align="center" width="70%">		
		     <cf_divscroll style="height:100%">	 
			  	 <cfinclude template="HelpDialogTopic.cfm">
			 </cf_divscroll>
		  </td>
		</tr>
	
	</table>	

<cf_screenbottom layout="Innerbox">


