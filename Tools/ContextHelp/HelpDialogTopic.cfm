
	<cfquery name="HelpId" 
		datasource="AppsSystem"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  HelpProjectTopic
			WHERE TopicId   = '#URL.TopicId#' 
	</cfquery>
	  
	<cfoutput query="helpid">
		
	<table width="98%" border="0" align="center">	  	
		<tr><td colspan="2">	
			<input type="hidden" name="topicid" id="topicid" value="#url.topicid#">		
			<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">		
				<tr><td colspan="2" align="center">
					<cfdiv bind="url:HelpDialogFeedback.cfm?topicid=#url.topicid#" id="feedback"/>		
				</td></tr>			
				<tr><td class="linedotted"></td></tr>						
				<tr><td>#HelpId.UITextQuestion#</td></tr>		
				<cfif HelpId.UITextAnswer neq "">
					<tr><td>#HelpId.UITextAnswer#</td></tr>
				</cfif>		
			</table>		
		</td></tr>	
		<tr><td colspan="2" height="1" class="linedotted"></td></tr>				
	</table>
	
	</cfoutput>