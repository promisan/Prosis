<!--
    Copyright © 2025 Promisan B.V.

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
<cf_screentop height="100%" 
    jquery="Yes" html="No" scroll="No" layout="webapp" banner="blue" label="Process new Staffing Period">

<cfoutput>
<script language="JavaScript">
	function process(st) {
	    ptoken.navigate('MandateProcessAction.cfm?Mission=#URL.ID#&MandateNo=#URL.ID1#&Status=' + st,'processbox')
	}
</script>
</cfoutput>

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr>
		<td height="50" colspan="3">
		<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/monitoring2.gif" alt="" width="42" height="38" border="0">
		</td>	
	</tr>

	<tr><td colspan="3"><cfdiv id="processbox"></td></tr>

	<tr><td colspan="3" class="line" height="1"></td></tr>

	<tr><td height="5" valign="top" class="Header"></td></tr>
	<tr>
	 <td width="160" class="labelmedium" valign="top">&nbsp;Entity/Tree:</td>
	 <td width="10"></td>
	 <td class="labelmedium"><cfoutput>#URL.ID#</cfoutput>
	 </td>
	</tr>
	
	<tr>
	 <td width="130" class="labelmedium" valign="top">&nbsp;Staffing Period</td>
	 <td width="10"></td>
	 <td class="labelmedium"><cfoutput>#URL.ID1#</cfoutput></td>
	</tr>

	<tr>
	 <td width="130" class="labelmedium">&nbsp;Analyse</td>
	 <td width="10"></td>
	 <td class="labelmedium">This function will compare the assignments made for the current mandate with the prior mandate. The differences found will then
	be logged and categorized as new assignment, ending assignment, extensions etc..
	 </td>
	</tr>
	
	
	<tr>
	 <td width="160" valign="top" class="label"></td>
	 <td width="10" class="Regular"></td>
	 <td class="regular"><input type="button" name="analyse" value="  Analyse  " class="button10g" onClick="javascript:process('5')">
	 </td>
	</tr>
	
	<tr><td height="10"></td></tr>

	<tr>
	 <td width="160" class="labelmedium">&nbsp;Lock new mandate</td>
	 <td width="10"></td>
	 <td class="labelmedium">See analyse. 
	 </td>
	</tr>

	<tr><td height="10" class="Header"></td></tr>
	<tr>
	 <td width="160" valign="top" class="Header"></td>
	 <td width="10" class="Regular"></td>
	 <td class="labelmedium"><font color="gray">In addition this function will set the status of the mandate and its assignments to <b>[Confirmed]</b>. This will mean that subsequent
	changes made to assignments will be logged individually and will require separate and individual approval. I will then also allow to loan positions.
	 </td>
	</tr>

	<tr><td height="5" class="Header"></td></tr>
	<tr><td height="10"></td></tr>
	<tr>
	 <td width="160" valign="top" class="Header"></td>
	 <td width="10" class="Regular"></td>
	 <td class="regular">
	 <input class="button10g" type="button" name="confirm" value="Confirm" onClick="process('1')">
	 </td>
	</tr>
	<tr><td height="10"></td></tr>

</table>

<cf_screenbottom layout="webapp">



