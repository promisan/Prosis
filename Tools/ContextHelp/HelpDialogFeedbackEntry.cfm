<cfoutput>

<cfform action="HelpDialogFeedbackSubmit.cfm?topicid=#url.topicid#&rating=#url.rating#">
	
	<table cellspacing="0" cellpadding="0" width="100%" class="formpadding">
	    <tr><td width="30">
		<cfswitch expression="#url.rating#">
		<cfcase value="1"><cfset i = "Positive"></cfcase>
		<cfcase value="2"><cfset i = "Normal"></cfcase>
		<cfcase value="3"><cfset i = "Negative"></cfcase>
		</cfswitch>
		<img alt="useful" src="<cfoutput>#SESSION.root#</cfoutput>/Images/rate#i#.gif" 
			border="0">
		</td>
		<td width="95%" class="labelit">Tell us what you think.</td>
		</tr>
		<tr><td colspan="2">
			<textarea style="border-radius:5px;padding:3px;font-size:12px;height:50;width:98%" class="regular" name="Remarks"></textarea>
		</td></tr>
		<tr><td align="center" colspan="2">
			<input type="submit" value="Submit" name="Submit" id="Submit" class="button10g">
			<input type="button" value="Cancel" name="Cancel" id="Cancel" class="button10g" onclick="feedbackreturn('#url.topicid#')">
		</td></tr>   
	</table>

</cfform>

</cfoutput>