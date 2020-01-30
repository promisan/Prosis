
<table width="99%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <tr><td height="3"></td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
    <tr>
		<td height="26" colspan="2" align="center">
		
		   <cf_tl id="Close" var="1">
		   <input type="button" name="Cancel" value="<cfoutput>#lt_text#</cfoutput>" class="button10g" onClick="javascript:cl()">
		   
		</td>
	</tr>	
	<tr><td height="1" colspan="2"class="linedotted"></td></tr>  

	<cfoutput>
	<tr><td id="box#url.activityid#">
	
		<cfinclude template="../../Activity/Progress/ActivityProgressOutput.cfm">
	
	</td></tr>
	</cfoutput>	

</table>