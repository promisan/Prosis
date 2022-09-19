  
  <cfparam name="fielddefault" default="">
  <cfparam name="objectUsage" default="">
  
  <table width="100%">
	   <tr class="labelmedium2">
	   	   	   	   
	   <cfif documentMode eq "Step" or documentMode eq "Header" or documentmode eq "-1">
	  
	   <td style="padding-right:4px">Usage:</td>
	   <td>
	   
	   <cfquery name="ObjectList" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Ref_EntityUsage
				WHERE EntityCode = '#URL.EntityCode#' 						
		</cfquery>
		
		<cfset val = ObjectUsage>
		
		<select name="ObjectUsage" type="text">
		 <option value=""><cf_tl id="N/A"></option>
		 <cfoutput query="ObjectList">
		     <option value="#ObjectUsage#" <cfif ObjectUsage eq val>selected</cfif>>#ObjectUsageName#</option>
		 </cfoutput>
		</select>	   
	   
	   </td>
	  	   
	   <cfelse>
	   
	   <input type="hidden" name="ObjectUsage" value="">
	   
	   </cfif>
	   
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
   