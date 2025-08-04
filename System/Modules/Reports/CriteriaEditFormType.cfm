<!--
    Copyright © 2025 Promisan

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

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  *
  FROM    Ref_Mission
</cfquery>

<CFOUTPUT>

	<cfif get.CriteriaType eq "unit">
		<cfset cl = "regular"> 
	<cfelse>
	    <cfset cl = "hide"> 
	</cfif>		
		
    <tr class="#cl#"><td height="2"></td></tr>
	
	<TR class="#cl#">
	
		<td height="26" class="labelmedium">Key field:</td>
	
		<td>
		    <table cellspacing="0" cellpadding="0"><tr>
			
			<td>		
			<input type="radio" name="LookupUnitTreeKey" id="LookupUnitTreeKey" <cfoutput>#dis#</cfoutput> value="OrgUnit" <cfif get.lookupfieldvalue eq "OrgUnit" or get.lookupfieldvalue eq "">checked</cfif>>&nbsp;</td>
			<td class="labelmedium">f:OrgUnit</td>
			<td><input type="radio" name="LookupUnitTreeKey" id="LookupUnitTreeKey" <cfoutput>#dis#</cfoutput> value="OrgUnitCode" <cfif get.lookupfieldvalue eq "OrgUnitCode">checked</cfif>>&nbsp;</td>
			<td class="labelmedium">f:OrgUnitCode</td>
			<td><input type="radio" name="LookupUnitTreeKey" id="LookupUnitTreeKey" <cfoutput>#dis#</cfoutput> value="HierarchyCode" <cfif get.lookupfieldvalue eq "HierarchyCode">checked</cfif>>&nbsp;</td>
			<td class="labelmedium">f:HierarchyCode</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td><td>&nbsp;</td>
			<td class="labelmedium">Show only Parent Unit Level:</td>			
			<td><input type="checkbox" name="LookupUnitParent" id="LookupUnitParent" value="1" <cfif get.LookupUnitParent eq"1">checked</cfif>></td>
			
			</TR>	
			</table>
		</td>
	</tr>	
		
	
	<cfif get.CriteriaType eq "list">
		<cfset cl = "regular"> 
	<cfelse>
	    <cfset cl = "hide"> 
	</cfif>		
		
	<TR class="#cl#">
    <td height="26" class="labelmedium">Presentation:</td>
    <TD> 
      <input type="radio" class="radiol" name="CriteriaInterface" id="CriteriaInterface" <cfoutput>#dis#</cfoutput> value="List" <cfif Get.CriteriaInterface eq "List" or #Get.CriteriaInterface# eq "" or #Get.CriteriaInterface# eq "Standard">checked</cfif>>List/Dropdown
	  <input type="radio" class="radiol" name="CriteriaInterface" id="CriteriaInterface" <cfoutput>#dis#</cfoutput> value="Checkbox" <cfif Get.CriteriaInterface eq "Checkbox">checked</cfif>>Checkbox/Radio
	</TD>
    </TR>
	
	
	
	
	<tr class="#cl#"><td height="2"></td></tr>
	<TR class="#cl#">
    <td height="19" class="labelmedium" valign="top">List values:</td>
    <TD>
	      <cfoutput>
		    <iframe src="CriteriaList.cfm?now=#now()#&id=#URL.ID#&Status=#URL.Status#&ID1=#URL.ID1#" name="ilist" id="ilist" width="100%" height="10" marginwidth="0" marginheight="0" hspace="0" vspace="0" align="left" scrolling="no" frameborder="0"></iframe>
		  </cfoutput>
	</td>
	</TR>
	
	<cfif get.CriteriaType eq "lookup" 
	   or get.CriteriaType eq "Extended" 
	   or get.CriteriaType eq "Text" 
	   or get.CriteriaType eq "TextList">
		<cfset cl = "regular"> 
	<cfelse>
	    <cfset cl = "hide"> 
	</cfif>		
	
	<TR class="#cl#">
    <td height="28" class="labelmedium">CF Datasource Alias:</td>
    <TD> 
	
		<cfset ds = "#Get.LookupDataSource#">
		<cfif ds eq "">
		 <cfset ds = "AppsSystem">
		</cfif>
				
		<CFOBJECT ACTION="CREATE"
		TYPE="JAVA"
		CLASS="coldfusion.server.ServiceFactory"
		NAME="factory">
		<!--- Get datasource service --->
		<CFSET dsService=factory.getDataSourceService()>		
		<cfset dsNames = dsService.getNames()>
		<cfset ArraySort(dsnames, "textnocase")> 
		
		
		<select class="regularxl" name="lookupdatasource" id="lookupdatasource" <cfoutput>#dis#</cfoutput>>
			
			<option value="" selected >--- select ---</option>
			
			<CFLOOP INDEX="i"
				FROM="1"
				TO="#ArrayLen(dsNames)#">
			
				<CFOUTPUT>
				<option value="#dsNames[i]#" <cfif #ds# eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
				</cfoutput>
			
			</cfloop>
			
		</select>
		
	
	</TD>
    </TR>
	
	
	
	
			
	<TR class="#cl#">
	
	<cfif get.CriteriaType eq "lookup" or get.CriteriaType eq "Extended">
		<td class="labelmedium">
		<cfselect name="LookupMode" class="regularxl" 
		   tooltip="Enter the name of a table or view to provide data to your lookup" 
		   visible="Yes" 
		   enabled="Yes"
		   onchange="viewscript(this.value)">
			<option value="Table" 
			 <cfif get.lookupmode neq "view">selected</cfif>>Table</option>
			<option value="View" 
			 <cfif get.lookupmode eq "view">selected</cfif>>View</option>
		</cfselect>	Name:
		</td>
	<cfelse>
	    <td class="labelmedium">Auto Suggest Table:</td>
		<input type="hidden" name="lookupmode" id="lookupmode" value="Table">
	</cfif>		
    <TD>
	
	<table cellspacing="0" cellpadding="0">
	
	   <tr><td>
	  
	   <cfif url.status eq "0">
		
		  <cfinput type="Text"
		       name="lookuptable"
		       value="#get.LookupTable#"
		       autosuggest="cfc:service.reporting.presentation.gettable({lookupdatasource},{cfautosuggestvalue})"
		       maxresultsdisplayed="7"
			   showautosuggestloadingicon="No"
		       typeahead="No"
		       required="No"
		       visible="Yes"
		       enabled="Yes"      
		       size="60"
		       maxlength="70"
		       class="regularxl">
			   
		<cfelse>
		
			<cfoutput>
				<input type="Text" class="regularxl" name="lookuptable" id="lookuptable" value="#get.LookupTable#" disabled size="60">
			</cfoutput>
				
		</cfif>		   	   
		   
	   </td></tr>
	   
	</table>    
	</TD>
    </TR>	
	
	<!---
	zzzzzzzzzzzzzzzzzzzzzzzzz
	<cfabort>
	--->
		
	<cfif get.LookupMode eq "Table">
	   <cfset vw = "hide">
	<cfelse>
	   <cfset vw = "regular"> 
	</cfif>
	
	<tr class="#vw#" id="viewscript">
	    <td></td>
		<td>
			<table width="100%" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<textarea class="regular" style="font-size:12px;padding;2px;width:97%;height:80" 
					   name="lookupviewscript">#Get.LookupViewScript#</textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="font-size:10px;" class="labelmedium">
					<b>Note:</b> GUID columns must be declared as <b>CONVERT(VARCHAR(36), GUID) as [Alias]</b> in your view.
				</td>
			</tr>
			<tr><td height="5"></td></tr>
			<tr>
				<td width="100">
				<cfif url.status eq "0">
				<input type="button" 
				   style="width:150px" 
				   name="createview" 
				   id="createview"
				   value="Create View on Server" 
				   class="button10g" 
				   onclick="doCreateView('#URL.ID#','#URL.Status#','#URL.ID1#','#get.LookupMultiple#')">
				 </cfif>
				</td>
				<td id="viewresult" align="right"></td>
			</tr>
			</table>		
		</td>
	</tr>
		   	
	<tr class="#cl#" id="b1">
	   <td height="2"></td>
    </tr>
	
	<TR class="#cl#" id="b2">
	
		<td></td>
		<td> 
		   <cf_securediv id="lookup" 
		       bind="url:CriteriaEditField.cfm?id=#URL.ID#&Status=#URL.Status#&ID1=#URL.ID1#&ID2={lookuptable}&multiple=#Get.LookupMultiple#&ds={lookupdatasource}">		
		</td>
		
	</TR>
	
	<cfif get.CriteriaType eq "extended">
		<cfset cl = "regular"> 
	<cfelse>
	    <cfset cl = "hide"> 
	</cfif>		
		    	
	<tr class="#cl#"><td height="3"></td></tr>

	<TR class="#cl#">
		<td valign="top" align="left">
		<table cellspacing="0" cellpadding="0">
		<tr><td height="3"></td></tr>
		<tr><td class="labelmedium" valign="top" style="padding-top:0px">
		<cf_UIToolTip tooltip="Select the fields to be used to search for the key value">
			<a href="##">Selection Fields:&nbsp;</a>
		</cf_UIToolTip>
		</td></tr>
		</table>
		</td>
        <td>
		<cf_securediv id   = "isubfield" 
		       bind = "url:CriteriaSubField.cfm?id=#URL.ID#&Status=#URL.Status#&ID1=#URL.ID1#&table={lookuptable}&multiple=#Get.LookupMultiple#&ds={lookupdatasource}&keyfld=#Get.LookupFieldValue#">

	    </td>
	</TR>				
		    
	<tr class="#cl#"><td height="1"></td></tr>
	
	<cfquery name="ParentCriteria" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ReportControlCriteria 
	WHERE    ControlId    = '#URL.ID#'
    AND      CriteriaName != '#URL.ID1#'	
	AND      Operational = 1
	AND      CriteriaType NOT IN ('list','unit') 
	<!--- do not allow recursive dependency for ajax loading --->
	AND      CriteriaName IN (SELECT CriteriaName 
	                              FROM   Ref_ReportControlCriteria 
								  WHERE  ControlId = '#URL.ID#'								  
								  AND    (CriteriaNameParent = '' OR CriteriaNameParent is NULL)) 
	</cfquery>
	
	<cfif get.CriteriaType eq "Lookup" or get.CriteriaType eq "extended" or get.CriteriaType eq "Unit">
		<cfset cl = "regular"> 
		
	<cfelse>
	    <cfset cl = "hide"> 
	</cfif>		
	
	<tr id="myparent" class="#cl#">
	
	<td height="26" class="labelmedium">
		<cf_UIToolTip tooltip="Define the value of the parent criteria that will be passed to a dynamic condition (subquery). <br> You must hereto add the following condition to the box below (unless this is a field type Unit) like :<br><br> WHERE [tablefield] IN (@parent). <br><br>Note: <b>[tablefield]</b> reflects a value that can be matched.">
			<a href="##">Runtime Filter:&nbsp;</a>
		</cf_UIToolTip>
	</td>
	
    <TD>
		<table><tr><td>						
		<cfquery name="Verify" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT  *
			  FROM    Ref_ReportControlCriteria 
			  WHERE   ControlId          = '#URL.ID#'
			  AND     CriteriaNameParent = '#URL.ID1#'  
		</cfquery>
		
		<cfif Verify.recordcount gte "1">
		
		<font color="808040">This criteria is a parent for #verify.recordcount# criteria.
		<input type="hidden" name="CriteriaNameParent" id="CriteriaNameParent" value="">
		
		<cfelse>
	
	    <select class="regularxl" name="CriteriaNameParent" id="CriteriaNameParent" <cfoutput>#dis#</cfoutput> onchange="<cfif get.CriteriaType eq 'Unit'>if (this.value == '') { document.getElementById('treeselect').className = 'regular' } else { document.getElementById('treeselect').className = 'hide'}</cfif>">
			<option value="">n/a</option>
			<cfloop query="ParentCriteria">
			   <option value="#CriteriaName#" <cfif get.CriteriaNameParent eq criteriaName>selected</cfif>>#CriteriaName#</option>		
			</cfloop>
		</select>
		
		</cfif>
						 
	    <TD id="treeselect" class="<cfif get.CriteriaType neq 'Unit' or get.CriteriaNameParent neq "">hide<cfelse>regular</cfif>">
						
			<select class="regularxl" name="lookupunittree" id="lookupunittree" <cfoutput>#dis#</cfoutput>>
			<cfloop query="Mission">
			    <option value="#Mission#" <cfif Get.LookupUnitTree eq "#Mission#">selected</cfif>>#Mission#</option>
			</cfloop>
			</select>
					
	    </TD>
				
		</TR>
		
		</table>
		
	</td>	
		
	</tr>			
				
	<cfif get.CriteriaType eq "extended" or get.CriteriaType eq "Lookup">
		<cfset cl = "regular"> 
	<cfelse>
	    <cfset cl = "hide"> 
	</cfif>		
					
	<tr id="cond" class="#cl#">

	<td colspan="2">
	
	<table width="100%">
	
	<tr>
	
		<td valign="top" width="100">
		   <table cellspacing="0" cellpadding="0">
		    <tr><td height="3"></td></tr><tr><td height="5"></td><td class="labelmedium">
			<cf_UIToolTip tooltip="Script for additional query condition on the selected table like a WHERE and or ORDER BY statement">
				Condition:&nbsp;<br>
			</cf_UIToolTip>
			</td></tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td style="padding-left:20px">	
		   <textarea style="font-size:14px;padding;2px;width:99%" <cfoutput>#dis#</cfoutput> rows="6" name="CriteriaValues" wrap="hard" class="regular"><cfoutput>#Get.CriteriaValues#</cfoutput></textarea>
	    </TD>	
	</TR>
	
	<tr>
		<td colspan="2" align="right" style="padding-right:6px" class="labelmedium">
			
			@userid = .acc&nbsp; @manager= .isAdministrator
					
		</td>
	</tr>
		
	</table>
	
	</td>
	</tr>
			
	<cfif  get.CriteriaType eq "lookup" or 
	       <!--- get.CriteriaType eq "Extended" or  --->
		   get.CriteriaType eq "List" or 
		   get.CriteriaType eq "Unit" or 
		   get.CriteriaType eq "Tree">
		<cfset cl = "regular"> 
	<cfelse>
	    <cfset cl = "hide"> 
	</cfif>		
	
    <TR class="#cl#">
    <TD align="left" class="labelmedium">Selection:&nbsp;</TD>
    <TD>
	  <table cellspacing="0" cellpadding="0">
	  <cfoutput>
	  <tr>
	  
	   <cfif get.criteriatype eq "Extended">
			 <cfset dialogs = "document.getElementById('lookupenableAll').disabled=true;document.getElementById('combobox').disabled=false">
			 <cfset dialogr = "document.getElementById('lookupenableAll').disabled=false;document.getElementById('combobox').disabled=true;document.getElementById('combobox').checked=false">
	   <cfelse>
			 <cfset dialogs = "document.getElementById('lookupenableAll').disabled=true;">
			 <cfset dialogr = "document.getElementById('lookupenableAll').disabled=false">
	   </cfif>
	  	
	   <cfif get.CriteriaType eq "Lookup" or get.CriteriaType eq "Extended">
						
			<td class="labelmedium">
				<input type="radio" class="radiol"
				    name="lookupmultiple" 
					id="lookupmultiple"
					value="1" <cfoutput>#dis#</cfoutput>
					onClick="#dialogs#;extended('#url.id1#',lookuptable.value,'1',lookupdatasource.value,lookupfieldvalue.value);" <cfif Get.LookupMultiple eq "1" or get.CriteriaType eq "">checked</cfif>>Multiple (N)
			</td> 
		  	<td class="labelmedium">
			
			  	<input type="radio" class="radiol"
				     name="lookupmultiple" 
					 id="lookupmultiple"
					 value="0" <cfoutput>#dis#</cfoutput>
					 onClick="#dialogr#;extended('#url.id1#',lookuptable.value,'0',lookupdatasource.value,lookupfieldvalue.value);" <cfif Get.LookupMultiple eq "0">checked</cfif>>One (1)
					 
			</td>
		
		<cfelse>
		
			<td class="labelmedium">
			<input type="radio" class="radiol" 
			    name="lookupmultiple" 
				id="lookupmultiple"	
				onclick="#dialogs#"	<cfoutput>#dis#</cfoutput>		
				value="1" <cfif Get.LookupMultiple eq "1" or get.CriteriaType eq "">checked</cfif>>Multiple (N) 
			</td> 
			
		  	<td class="labelmedium">
			
		  	<input type="radio" class="radiol"
			     name="lookupmultiple" 
				 id="lookupmultiple"
				 onclick="#dialogr#" <cfoutput>#dis#</cfoutput>
				 value="0" <cfif Get.LookupMultiple eq "0">checked</cfif>>One (1)
		  	</td>
		
		
		</cfif>
	
	  <cfif dis eq "">

		  <cfif Get.LookupMultiple eq "1">
		      <cfset dis = "disabled">
		  <cfelse>
		      <cfset dis = ""> 
		  </cfif>
		  
	  </cfif>	  
	  
	  <td id="allow" class="labelmedium">
	  &nbsp;&nbsp;- Include option <b>SELECT ALL</b>&nbsp;:
	  <input class="radiol" type="checkbox" name="lookupenableAll" id="lookupenableAll" <cfoutput>#dis#</cfoutput> value="1" <cfif Get.LookupEnableAll eq "1">checked</cfif>>
	  
	  </td>
	  </tr>
	  </cfoutput>
	  </table>
	  
	</TD>
    </TR>
		
	<cfif get.CriteriaType eq "lookup" or get.CriteriaType eq "Extended" or get.CriteriaType eq "Unit">
		<cfset cl = "regular"> 
	<cfelse>
	    <cfset cl = "hide"> 
	</cfif>		
	
	<TR class="#cl#">
    <TD class="labelmedium">Presentation:&nbsp;</TD>
	
	<td>
	
		<table>
			<tr>
				<td class="labelmedium">Field selection dialog (allows hibrid selection) :</td>
				<td style="padding-right:5px">
				<cfif url.status eq "0">
				
					<!--- <cfif get.CriteriaType eq "Extended" and Get.LookupMultiple eq "0">
						<cfset dis = "disabled">						--->
						
					<cfif Verify.recordcount gte "1">
					    <cfset dis = "disabled">							
					<cfelse>					  
					    <cfset dis = "">
					</cfif>	
					
				</cfif>
								
				  	<input type="checkbox" class="radiol"
				      name="combobox" id="combobox" #dis#
					  value="Combo" <cfif Get.CriteriaInterface eq "Combo">checked</cfif>>					  
					  
				</TD>
				
				<cfif get.CriteriaType eq "lookup" or get.CriteriaType eq "Unit">
					<cfset cl = "regular"> 
				<cfelse>
				    <cfset cl = "hide"> 
				</cfif>		
								
				<td class="labelmedium" class="#cl#">&nbsp;Show both <b>Keyfield</b> and <b>display</b> field:</td>
				<td class="#cl#">
				  	<input type="checkbox" #dis# class="radiol"
				       name="LookupFieldShow" id="LookupFieldShow"
					   value="1" <cfif Get.LookupFieldShow eq "1">checked</cfif>>&nbsp;
				</TD>			
		    </TR>
		</table>
		
	</td>
	</tr>
						
    <cfif Get.CriteriaType eq "Extended"  and Get.CriteriaInterface eq "Combo">
	  <cfset cl = "Hide"> 
	  <cfset ot = "regular">	 
	<cfelse>	
	  <cfset cl = "Regular">
	   <cfset ot = "Hide">	  
	</cfif>
	
    <TR class="#cl#">
    <TD class="labelmedium">Cluster:</TD>
    <TD> 
		<cfinput type="Text" class="regularxl" name="criteriacluster" value="#get.CriteriaCluster#" 
		required="No" size="20" maxlength="20"> <b> : One selection for grouped parameter (XOR)</b>
	</TD>
    </TR>	 
  
    <tr class="#ot#"><td height="4"></td></tr>
 
	<cfif Get.CriteriaType eq "Text" or Get.CriteriaType eq "TextList">
	  <cfset cl = "Regular">
	<cfelse>
	  <cfset cl = "Hide"> 
	</cfif>
 	
    <TR class="#cl#">
    	<TD class="labelmedium">Mask:</TD>
	    <TD> 
	   	<cfinput type="Text" class="regularxl" name="criteriamask" value="#get.CriteriaMask#" 
		required="No" size="30" maxlength="30"> 
		&nbsp;Length:&nbsp;
		<cfinput type="Text" name="criteriamasklength" value="#get.CriteriaMaskLength#" message="Please enter a valid length" validate="integer" required="No" size="2" maxlength="2" class="regular" style="text-align: center;"> 
		</TD>
	 </TR>	
 
	<TR class="#cl#">
	    <TD></TD>
	    <TD> 
		  <table border="0" cellspacing="0" cellpadding="0" class="formpadding">
		   <tr><td colspan="2"></td></tr>
		   <tr><td class="labelmedium">A</td><td>= A-Z, a-z</td></tr>
		   <tr><td class="labelmedium">X</td><td>= A-Z, a-z, 0-9</td></tr>
		   <tr><td class="labelmedium">9</td><td>= 0-9</td></tr>
		   <tr><td class="labelmedium">?</td><td>= Any</td></tr>
		   <tr><td class="labelmedium">Other</td><td>= Insert literal character</td></tr>
		  </table> 
		</TD>
   </TR>	
  
   <TR class="<cfoutput>#cl#</cfoutput>">
    <TD class="labelmedium">Validation:</TD>
    <TD class="labelmedium">
	  <select class="regularxl" name="criteriavalidation" id="criteriavalidation" onChange="javascript:regex(this.value)" <cfoutput>#dis#</cfoutput>>
	      <option value="" <cfif Get.criteriavalidation eq "">selected</cfif>></option>
		  <option value="noblanks" <cfif #Get.criteriavalidation# eq "noblanks">selected</cfif>>No blanks</option>
		  <option value="url" <cfif Get.criteriavalidation eq "url">selected</cfif>>A valid URL pattern</option>
		  <option value="integer" <cfif Get.criteriavalidation eq "integer">selected</cfif>>Integer value</option>
		  <option value="float" <cfif Get.criteriavalidation eq "float">selected</cfif>>Numeric value</option>
		  <option value="email" <cfif Get.criteriavalidation eq "email">selected</cfif>>A valid eMail address</option>
		  <option value="telephone" <cfif Get.criteriavalidation eq "telephone">selected</cfif>>A valid Telephone No</option>
		  <option value="time" <cfif Get.criteriavalidation eq "time">selected</cfif>>A valid time HH:MM:SS</option>
		  <option value="boolean" <cfif Get.criteriavalidation eq "boolean">selected</cfif>>Yes|No True|False</option>
		  <option value="creditcard" <cfif Get.criteriavalidation eq "creditcard">selected</cfif>>A valid credit card No</option>
		  <option value="ssn" <cfif Get.criteriavalidation eq "ssn">selected</cfif>>A valid Social Security Number</option>
		  <option value="zipcode" <cfif Get.criteriavalidation eq "zipcode">selected</cfif>>A Postal code selector</option>
		  <option value="regex" <cfif Get.criteriavalidation eq "regex">selected</cfif>>Regular Expression [HTML only]</option>
	  </select>
	   
	</TD>
 </TR>	
   
 <cfif get.criteriavalidation eq "regex" and get.criteriatype eq "text">
    <cfset vis = "regular">
 <cfelse>
    <cfset vis = "hide">
 </cfif> 
 
  <TR id="b21" class="#vis#">
    <TD class="labelmedium">Reg Expression: <br>(HTML only)</TD>
    <TD> 
	   	<cfinput type="Text" class="regularxl" name="criteriapattern" value="#get.CriteriaPattern#" 
		required="No" size="50" maxlength="50"> 
	</TD>
 </TR>	
 
   <TR id="b22" class="#vis#">
    <TD></TD>
    <TD> 
	  <table border="0" cellspacing="0" cellpadding="0" bordercolor="f4f4f4" class="formpadding">	  
	   <tr><td>a{2,4}</td><td>= aa, aaa or aaaa</td></tr>
	   <tr><td>[1-9]</td><td>= 1 or 2 or 3 etc.</td></tr>
	   <tr><td>^</td><td>= Field must BEGIN with a string that matches the pattern</td></tr>
	   <tr><td>$</td><td>= Field must END with a string that matches the pattern</td></tr>
	   <tr><td>.</td><td>= Any character</td></tr>
	   <tr><td>\c</td><td>= Must match literal character 'c'</td></tr>
	  </table> 
	</TD>
 </TR>	
 
 <cfif Get.CriteriaType eq "Date">
	  <cfset dt = "Regular">
	  <cfset ot = "Hide">
	<cfelse>
	  <cfset dt = "Hide"> 
	  <cfset ot = "regular">
</cfif>
 
 <TR class="#ot#">
    <TD height="22" class="labelmedium">Default value:</TD>
    <TD class="labelmedium"> 
		<cfinput type="Text" class="regularxl" name="criteriadefault" value="#get.CriteriaDefault#" 
		required="No" size="50" maxlength="70"> <b> : optional</b>
	</TD>
 </TR>
 
 <cfif Get.CriteriaType eq "Date" or Get.CriteriaType eq "Text">
	  <cfset dt = "Regular">	 
	<cfelse>
	  <cfset dt = "Hide"> 	 
</cfif>
 
 <TR class="#dt#"> 
 <TD height="25" class="labelmedium">Entry Mode:</TD>
    <TD class="labelmedium"> 
	
	<cfif Get.CriteriaType eq "Date">
	
	    <input type="radio" class="radiol" name="CriteriaDatePeriod" id="CriteriaDatePeriod" value="0" <cfif get.CriteriaDatePeriod eq "0">checked</cfif>> 
		<cf_UIToolTip  tooltip="Allows the user to enter a single selection date">Selection Date</cf_UIToolTip>
		
		<input type="radio" class="radiol" name="CriteriaDatePeriod" id="CriteriaDatePeriod" value="1" <cfif get.CriteriaDatePeriod eq "1">checked</cfif>> 
		<cf_UIToolTip  tooltip="Allows the user to enter a date as start- and end date">Period</cf_UIToolTip>
		
	<cfelse>
	
	    <input type="radio" class="radiol" name="CriteriaDatePeriod" id="CriteriaDatePeriod" value="0" <cfif get.CriteriaDatePeriod eq "0">checked</cfif>> 
		<cf_UIToolTip  tooltip="Allows the user to enter a single value">Single Input</cf_UIToolTip>
		
		<input type="radio" class="radiol" name="CriteriaDatePeriod" id="CriteriaDatePeriod" value="1" <cfif get.CriteriaDatePeriod eq "1">checked</cfif>> 
		<cf_UIToolTip  tooltip="Allows the user to enter a range (start-end">Range</cf_UIToolTip>
	
	</cfif>	
			
	 </td>	
 </TD>
 </tr>
  
 <cfif Get.CriteriaType eq "Date">
	  <cfset dt = "Regular">	 
	<cfelse>
	  <cfset dt = "Hide"> 	 
</cfif>
  
 <TR class="#dt#"> 
 <TD height="22" class="labelmedium">Default value:</TD>
    <TD class="labelmedium"> 
	
	    <cfif get.CriteriaDefault eq "today">
		  <cfset d = "hide">
		<cfelse>
		  <cfset d = "regularxl">  
		</cfif>
		
		<cfinput type="Text" name="defaultDate" value="#get.CriteriaDefault#" 
			size="20" maxlength="70" class="#d#" style="text-align: left;" tooltip="Comma separate if you want to set default dates for the entry mode=period. <br><br> <b>Example:</b> <i>01/01/1991,01/12/1992">		
		
			<input type="checkbox" name="defaultToday" id="defaultToday" value="1" onClick="javascript:today(this.checked)" <cfif get.CriteriaDefault eq "today">checked</cfif>> 
			<cf_UIToolTip  tooltip="Take today's date at the moment of preparing the report as the default">
			Today		
			</cf_UIToolTip>
					
		<input type="checkbox" <cfif get.criteriadefault neq "today">disabled</cfif> name="criteriadaterelative" id="criteriadaterelative" value="1" <cfif get.criteriadaterelative eq "1">checked</cfif>> 
		<cf_UIToolTip  tooltip="Once you select [today], check this box to allow definition of a range in respect today's date.">
		Relative date
		</cf_UIToolTip>
					
	 </td>	
 </TD>
 </tr>
 
</CFOUTPUT>