
<cf_divscroll>

<cfform 
	action="#session.root#/programrem/application/program/activityProgram/ActivitySchemaSubmit.cfm?programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&refresh=1" 
	method="POST" 
	name="ActivityEntry">

	<table width="97%" align="center">
		<TR class="labelmedium">
	    <td valign="top" style="padding-top:10px;">
			<cfinclude template="ActivitySchemaView.cfm">	
		 </td>
	   </tr>	
	  	  
	   <tr><td height="38" colspan="2" align="center">
	   	 <cfoutput>
			<cf_tl id="Save"   var="vSave">
		    <input class="button10g" type="submit" name="Submit" value="#vSave#" onclick="Prosis.busy('yes');">	  
		 </cfoutput>
	   </td></tr>
	  
	  </table>
	   
	 </td></tr>
	 
	 </table>
 
</cfform>

</cf_divscroll>