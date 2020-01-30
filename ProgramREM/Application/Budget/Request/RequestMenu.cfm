
<cfoutput>

<table width="99%" cellspacing="0" cellpadding="0">

<tr>
   	
    <td height="25" align="left" style="padding-left:10px">
	<!---
	<cf_tl id="Reload" var="1">	
	<input type="button" name="Refresh" value="#lt_text#" style="width:110;height:25;font-size:12px" 
	   class="button10g" onclick="reload(document.getElementById('ObjectSelect').value)">
	--->
	</td>	
	
	<cfinvoke component="Service.Process.Program.ProgramAllotment"  <!--- get access levels based on top Program--->
			Method         = "RequirementStatus"
			ProgramCode    = "#URL.ProgramCode#"
			Period         = "#URL.Period#"	
			EditionId      = "#URL.editionID#" 
			ReturnVariable = "RequirementLock">	
			 	 			
	<cfif RequirementLock eq "0">			
	
		<cfif Object.recordcount gte "1">
	    <td style="padding-left:2px">
		
		 	<cf_tl id="Add New" var="1">
			<input type="button" 
			    name="Add" 
				value="#lt_text#" 
				style="width:110;height:25;font-size:11px" 
				class="button10g" 
				onclick="Prosis.busy('yes');alldetinsert('#url.editionid#_#url.objectcode#','#url.editionid#',ObjectSelect.value,'','add','dialog')">
			
		</td>	
		</cfif>
		
		<td style="padding-left:2px">
		
			<cf_ProgramPeriodEdition mission="#program.unitMission#" period="#url.period#" editionid="#url.editionid#">
					
			<select name="EditionSelect" class="regularxl" style="width:150px" onchange="period(this.value,document.getElementById('ObjectSelect').value)">
			<cfloop query="Edition">
				<option value="#Editionid#" <cfif editionid eq url.editionid>selected</cfif>>#Description#</option>
			</cfloop>
			</select>		
		
		</td>
				
		<td style="padding-left:2px">	
				
			<!-- <cfform> -->	
			<cfselect name="ObjectSelect" 
			   group="Category" 
			   value="Code" 
			   query="Object"
			   display="Description" 
			   selected="#url.objectcode#" 
			   visible="Yes" 
			   enabled="Yes" 
			   style="width:250px"
			   onchange="object(this.value);" 
			   id="ObjectSelect" 
			   class="regularxl"/>		
			  <!-- </cfform> --> 
		</td>
	
	</cfif>   
		
	<td id="selected" class="hide">
		<input type="text" id="selectme" name="selectme" value="#url.objectcode#">
	</td>
	
	<td width="80%" align="right" style="padding-right:10px;font-weight:300" class="labelmedium"><cf_tl id="Officer">:&nbsp;<font color="808080">#SESSION.last# #SESSION.first#</font></td>
				
</tr>
</table>

</cfoutput>
