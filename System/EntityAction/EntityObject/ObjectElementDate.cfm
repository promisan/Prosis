  
  <cfparam name="fielddefault" default="">
  
  <table width="100%">
	   <tr>
	   <td width="20%" align="right">Default Value:</td>
	   <td style="min-width:90px" align="right">
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
		<td style="padding-left:4px;padding-right:4px">or</td>
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
   