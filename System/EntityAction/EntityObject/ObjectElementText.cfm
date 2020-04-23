  
  <cfparam name="lookupdatasource" default="">
  <cfparam name="lookuptable" default="">
  <cfparam name="lookupselect" default="0">
  <cfparam name="fieldvalidation" default="">
  <cfparam name="fieldlength" default="20">
  <cfparam name="fieldmask" default="">
  <cfparam name="fielddefault" default="">
  <cfparam name="fieldselectmultiple" default="0">
  
  <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
  
         
  	   <tr class="labelmedium">
	   <td width="200">Validation:</td>
	   <td>
	   
	    <select name="fieldvalidation" id="fieldvalidation" class="regularxl">
	      <option value="" <cfif fieldvalidation eq "">selected</cfif>></option>
		  <option value="noblanks" <cfif fieldvalidation eq "noblanks">selected</cfif>>No blanks</option>
		  <option value="url" <cfif fieldvalidation eq "url">selected</cfif>>A valid URL pattern</option>
		  <option value="integer" <cfif fieldvalidation eq "integer">selected</cfif>>Integer value</option>
		  <option value="float" <cfif fieldvalidation eq "float">selected</cfif>>Numeric value</option>
		  <option value="telephone" <cfif fieldvalidation eq "telephone">selected</cfif>>A valid Telephone No</option>
		  <option value="time" <cfif fieldvalidation eq "time">selected</cfif>>A valid time HH:MM:SS</option>
		  <option value="boolean" <cfif fieldvalidation eq "boolean">selected</cfif>>Yes|No True|False</option>
		  <option value="creditcard" <cfif fieldvalidation eq "creditcard">selected</cfif>>A valid credit card No</option>
		  <option value="ssn" <cfif fieldvalidation eq "ssn">selected</cfif>>A valid Social Security Number</option>
		  <option value="zipcode" <cfif fieldvalidation eq "zipcode">selected</cfif>>A Postal code selector</option>
	  </select>
	   	   
	   </td>
	   
	   </tr>	
	   
	   <tr class="labelmedium">
	   <td>Length:</td>
	   <td>
	   
		   <cfinput type="Text"
	       name="fieldlength"
	       validate="integer"
		   value="#FieldLength#"
		   class="regularxl"
	       required="No"
	       visible="Yes"      
	       size="1"
	       maxlength="3">
	   	   
	   </td>
	   
	   </tr>	
	  	   	   
	   <tr class="labelmedium">
	   <td><cf_UIToolTip tooltip="9 = number, A is character">Mask:</cf_UIToolTip></td>
	   <td>
	   
		   <cfinput type="Text"
	       name="fieldmask"	      
		   value="#FieldMask#"
	       required="No"
		   class="regularxl"
	       visible="Yes"      
	       size="20"
	       maxlength="20">
	   	   
	   </td>	   
	  </tr>	
	  
	   <tr class="labelmedium">
	   <td><cf_UIToolTip tooltip="Default value, you may use CF strings and variables like O-SAT-S-000-&Year(now())">Default Value:</cf_UIToolTip></td>
	   <td>
	   
		   <cfinput type="Text"
	       name="fielddefault"	      
		   value="#FieldDefault#"
	       required="No"
		   class="regularxl"
	       visible="Yes"      
	       size="30"
	       maxlength="40">
	   	   
	   </td>	   
	  </tr>		  
  			  
	  <tr class="labelmedium">
	    <td width="100">Lookup Table:</td>
		<td>
		<table cellspacing="0" cellpadding="0"><tr><td>
		
		<cfset ds = "#LookupDataSource#">
		
		<!--- Get "factory" --->
		<CFOBJECT ACTION="CREATE"
		TYPE="JAVA"
		CLASS="coldfusion.server.ServiceFactory"
		NAME="factory">
		
			<CFSET dsService=factory.getDataSourceService()>			
		
			<cfset dsNames = dsService.getNames()>
			<cfset ArraySort(dsnames, "textnocase")> 
		
		    <select name="lookupdatasource" id="lookupdatasource" onchange="javascript:up(this.value)" class="regularxl">
			    <option value="" selected>Not applicable</option>
				<CFLOOP INDEX="i" FROM="1" TO="#ArrayLen(dsNames)#">
					<CFOUTPUT>
						<option value="#dsNames[i]#" <cfif ds eq dsNames[i]>selected</cfif>>#dsNames[i]#</option>
					</cfoutput>
				</cfloop>
			</select>
		
		</td>
				
		<cfif ds eq "">
		  <cfset cl = "hide">
		<cfelse>
		  <cfset cl = "regular">
		</cfif>
		<td>&nbsp;</td>
		<td id="fieldlookup1" class="<cfoutput>#cl#</cfoutput>">
		
		 <cfinput type         = "Text"
	       name                = "lookuptable"
	       value               = "#LookupTable#"
	       autosuggest         = "cfc:service.reporting.presentation.gettable({lookupdatasource},{cfautosuggestvalue})"
	       maxresultsdisplayed = "6"
		   showautosuggestloadingicon="No"
	       typeahead           = "Yes"
	       required            = "No"
	       size                = "30"
	       maxlength           = "30"
		   class               = "regularxl">
		   
		   </td>
		   
		   <td class="labelmedium" style="padding-left:10px" id="fieldlookup2" class="<cfoutput>#cl#</cfoutput>">
		   <input type="radio" class="radiol" name="LookupSelect" id="LookupSelect" value="0" <cfif lookupselect neq "1">checked</cfif>>
		   </td>
		   <td style="padding-left:4px">Auto complete (combo) </td>
		   <td style="padding-left:4px">
		   <input type="radio" class="radiol" name="LookupSelect" id="LookupSelect" value="1" <cfif lookupselect eq "1">checked</cfif>>
		   </td>
		   <td style="padding-left:4px">Dropdown</td>
				   
		   </tr>
		   
	   </table>
	   </td>	   
  			   
	   <tr id="fieldlookup3" class="<cfoutput>#cl#</cfoutput>">
	   
	   <cfparam name="documentId" default="00000000-0000-0000-0000-000000000000">
	   
	   	   <td colspan="2" bgcolor="white">
		   <cfdiv bind="url:../../EntityObject/ObjectElementField.cfm?documentid=#documentid#&fieldtype={fieldtype}&lookupdatasource={lookupdatasource}&lookuptable={lookuptable}" 
		   id="tablefields"/>
		  
		   </td>
		   
	   </tr>
	   
	   <!---
	   
	   <tr>
	   <td>Multiple Select:</td>
  	   <td>
		   <input type="radio" name="FieldSelectMultiple" value="0" <cfif FieldSelectMultiple neq "1">checked</cfif>>No
		   <input type="radio" name="FieldSelectMultiple" value="1" <cfif FieldSelectMultiple eq "1">checked</cfif>>Yes
	   </td> 
	   </tr>
	   
	   --->
	   
  </table>
   