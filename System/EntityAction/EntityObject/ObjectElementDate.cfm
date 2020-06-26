  
  <cfparam name="fielddefault" default="">
  
  <table width="100%">
	   <tr>
	   <td width="20%" align="right"><cf_UIToolTip  tooltip="Default value, you may use CF strings and variables like O-SAT-S-000-&Year(now())">Default Value:</cf_UIToolTip></td>
	   <td width="10%" align="right">
			Today's date
		</td>
		<td width="5%" align="right">
			<cfif fielddefault eq "">
			    <cfset val = "">
			    <input type="checkbox" name="Today" id="Today" value="0">
			<cfelseif fielddefault eq "now()">
			    <cfset val = dateformat(now(),CLIENT.DateFormatShow)>
			    <input type="checkbox" name="Today" id="Today" value="1" checked>	  
			<cfelse>
				  <cfset val = fielddefault>
			      <input type="checkbox" name="Today" id="Today" value="0">
			</cfif>		
		</td>	   
	   <td width="20%" align="left">

		<cfif IsValid("date",val)>
	  		<cf_intelliCalendarDate9
				FieldName="datedefault"
				Default="#val#"
				Class="regularxl"
				AllowBlank="True">	
		<cfelse>
	  		<cf_intelliCalendarDate9
				FieldName="datedefault"
				Default=""
				Class="regularxl"
				AllowBlank="True">						
		</cfif>		
											  
	   	   
	   </td>
	   <td width="45%"></td>	   
	  </tr>	
  </table>
   