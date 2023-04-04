
<cfset url.ajaxid = Object.ObjectKeyValue1>

<cfoutput>

<cf_tl id="Identify candidates" var="1">

<table style="width:100%">
<tr><td style="padding:5px" align="center">

<input type="button" name="Identify" onclick="rostersearch('#Action.actioncode#','#Action.actionId#','urldetail1','#url.wParam#')" value="#lt_text#" class="button10g" style="height:30px;font-size:16px;width:360px"></td>
</tr>

<!--- refresh button --->

<tr class="hide">
<td id="workflowbutton_#url.ajaxid#" onclick="javascript:ptoken.navigate('#session.root#/Vactrack/Application/Document/DocumentCandidate.cfm?mode=step&ajaxid=#url.ajaxid#&wparam=#url.wparam#','urldetail1')"></td>
</tr>

<cfset url.mode = "step">

<tr><td id="urldetail1" style="width:100%"><cfinclude template="../../Document/DocumentCandidate.cfm"></td></tr>

<tr><td style="font-size:16px">		

						  
	    <cfinclude template="../../../../Tools/EntityAction/Report/DocumentAttach.cfm">			
		<cfset setattachment = "1"> 
		
		</td>
	</tr>	


</table>

</cfoutput>
