  
  <cfparam name="lookupdatasource" default="">
  <cfparam name="lookuptable" default="">
  <cfparam name="lookupselect" default="0">
          		
	<table cellspacing="0" cellpadding="0">
	
	<tr><td class="labelmedium">
	
	<cfset ds = "#LookupDataSource#">
	
	<!--- Get "factory" --->
	<CFOBJECT ACTION="CREATE"
	TYPE="JAVA"
	CLASS="coldfusion.server.ServiceFactory"
	NAME="factory">
		<CFSET dsService=factory.getDataSourceService()>

	
		<cfset dsNames = dsService.getNames()>
		<cfset ArraySort(dsnames, "textnocase")> 
	
	    <select name="lookupdatasource" id="lookupdatasource" class="regularxl" onchange="javascript:up(this.value)">
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
	
	<td class="labelmedium">.dbo.</td>
	<td id="fieldlookup1" class="<cfoutput>#cl#</cfoutput>">
	
	 <cfinput type="Text"
       name         = "lookuptable"
       value        = "#LookupTable#"
       autosuggest="cfc:service.reporting.presentation.gettable({lookupdatasource},{cfautosuggestvalue})"
       maxresultsdisplayed="6"
	   showautosuggestloadingicon="No"
       typeahead    = "Yes"
       required     = "No"
       size         = "30"
       maxlength    = "30"
	   class="regularxl">
	   
	   </td>
	  
	   <td id="fieldlookup2" class="<cfoutput>#cl#</cfoutput>"></td>
					   
  </tr>   
  
  <tr id="fieldlookup3" class="<cfoutput>#cl#</cfoutput>">
 	
	 <cfparam name="documentId" default="00000000-0000-0000-0000-000000000000">
   
	 <td colspan="4" bgcolor="white">
		<cfdiv bind="url:../../EntityObject/ObjectElementField.cfm?documentid=#documentid#&fieldtype=text&lookupdatasource={lookupdatasource}&lookuptable={lookuptable}" 
		   id="tablefields"/>
	  
	 </td>
	   
     </tr> 
  
  </table>