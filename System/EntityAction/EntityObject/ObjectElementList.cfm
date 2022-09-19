   
  <cfparam name="fieldselectmultiple" default="0">
   <cfparam name="ObjectUsage" default="">
  
  <table class="formpadding">
     	   
	   <tr class="fixlengthlist">
	   
	   <cfif documentMode eq "Step" or documentMode eq "Header" or documentmode eq "-1">
	  
	   <td>Usage:</td>
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
	   
	   <td class="labelmedium2">Multiple Select:</td>
  	   <td><input type="radio" class="radiol" name="FieldSelectMultiple" id="FieldSelectMultiple" value="0" <cfif FieldSelectMultiple neq "1">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelit">No</td>
	   <td><input type="radio" class="radiol" name="FieldSelectMultiple" id="FieldSelectMultiple" value="1" <cfif FieldSelectMultiple eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelit">Yes</td>
	   
	   </tr>
	   
  </table>
   