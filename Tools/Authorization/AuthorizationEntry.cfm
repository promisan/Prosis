
<cfoutput>
<table width="100%">
     <tr>
	    <td>
		<input type="password" id="authorizationcode" name="AuthorizationCode" class="regularxxl" style="width:200px;text-align:center" onKeyUp   = "search(event)">
		
		</td>
		<td><input type="button" class="button10g" id="autsubmit" name="Submit" value="Submit" onclick="setauthorization('#url.mission#','#url.systemfunctionid#','#url.object#','#url.objectclass#',document.getElementById('authorizationcode').value)"></td>
	 </tr>
</table>
</cfoutput>

<!--- dialog which has module and mission as reference --->