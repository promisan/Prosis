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

<cfif URL.ID eq "">
   <cfset URL.ID = "{000000000-0000-0000-0000-000000000000}">
</cfif>

<cfparam name="URL.Status" default="0">
<cfparam name="URL.borrow" default="0">

<cfquery name="UserReport" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  *
  FROM    Ref_ReportControl
  WHERE   ControlId = '#URL.ID#'
</cfquery>

<cfif url.status eq "1">
 <cfset dis = "disabled">
 <cfset ena = "no">
<cfelse>
 <cfset dis = ""> 
 <cfset ena = "yes">
</cfif>

<cfquery name="Borrow" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     DISTINCT C.CriteriaName, C.CriteriaDescription
	FROM       Ref_ReportControlCriteria C INNER JOIN
	           Ref_ReportControl R ON C.ControlId = R.ControlId
	WHERE      R.SystemModule = '#UserReport.SystemModule#'
	GROUP BY   C.CriteriaDescription, C.CriteriaName
</cfquery>

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ReportControlCriteria 
	WHERE ControlId = '#URL.ID#'
	AND CriteriaName = '#URL.ID1#'
</cfquery>

<table width="95%" align="center" class="formpadding"> 

<tr><td height="2"></td></tr>

<tr><td valign="top">

<CFFORM method="post" 
	 onsubmit="return false"
	 name="dialog">

<table width="100%" align="center" class="formpadding">
	 
<input type="hidden" name="ControlId" id="ControlId" value="<cfoutput>#URL.ID#</cfoutput>">

 <tr><td height="2" class="xxxhide" id="target"></td></tr>
 
 <cfif UserReport.FunctionClass neq "System">
 
 	<!--- not applicable for global definition --->
 
	 <cfif URL.ID1 eq "" and Borrow.recordcount gte "1">
	 <TR>
	    <TD class="labelmedium">Borrow from:</TD>
	    <TD> 
		    <select class="regularxl" name="borrow" id="borrow" #dis# onChange="javascript:copy(this.value,'<cfoutput>#UserReport.SystemModule#</cfoutput>')">
			<option value=""></option>
			<cfoutput query="Borrow">
			   <option value="#CriteriaName#">#CriteriaDescription# - #CriteriaName#</option>		
			</cfoutput>
			</select>
		</TD>
	 </TR>	  
	 </cfif> 
	 
 </cfif>	 

 <TR>
    <TD class="labelmedium">Name:</TD>
    <TD class="labelmedium"> 
	    
		<input type="hidden" name="criterianameold" 
		                     id="criterianameold" value="<cfoutput>#get.CriteriaName#</cfoutput>">
	
			<cfif url.status eq "0">
		
				<cfinput type="Text"
		       name      = "criterianame"
		       value     = "#get.CriteriaName#"
		       message   = "Please enter a valid criteria name"
		       validate  = "noblanks"
		       required  = "Yes"
		       visible   = "Yes"
		       enabled   = "false"		   
		       size      = "20"
		       maxlength = "30"
		       onchange  = "javascript:check(this.value,criteriadescription.value)"
		       class     = "regularxl">
		   
		   <cfelse>
		   
			   <input type="Text"
			   disabled
		       name      = "criterianame"
			   id        = "criterianame"
		       value     = "<cfoutput>#get.CriteriaName#</cfoutput>"
		       size      = "20"
		       maxlength = "30"	       
		       class     = "regularxl">
		   		   
		   </cfif>
		
		<cftry>
				
			<cfif UserReport.ReportRoot eq "Application" or UserReport.ReportRoot eq "">
			   <cfset rootpath  = "#SESSION.rootpath#">
			<cfelse>
			   <cfset rootpath  = "#SESSION.rootReportPath#">
			</cfif>
		
			<cffile action = "read"
		 	  file = "#rootpath#\#UserReport.ReportPath#\#UserReport.TemplateSQL#"
			  variable = "sql">  
			  
			<cfif not FindNoCase("Form.#get.CriteriaName#", "#sql#") and get.CriteriaName neq "">	 
			   <cfoutput>
			   <font color="FF0000">&nbsp;
			   <b>Attention, criteria</b>&nbsp;FORM.#get.CriteriaName# not used in SQL.cfm!
			   </font>
			   </cfoutput>
			</cfif>
			
			  <cfcatch></cfcatch>
		
		</cftry>
		<cf_UIToolTip tooltip="Disables this criteria on the interface">
		<input type="radio" name="operational" class="radiol" id="operational" <cfoutput>#dis#</cfoutput> value="1" <cfif get.operational neq "0">checked</cfif>>Enabled
		<input type="radio" name="operational" class="radiol" id="operational" <cfoutput>#dis#</cfoutput> value="0" <cfif get.operational eq "0">checked</cfif>>Disabled
		</cf_UIToolTip>
		
	</TD>
 </TR>
    
 <TR>
    <TD class="labelmedium" width="120">Description:</TD>
    <TD width="82%"> 
	
	    <cfif url.status eq "0">

		<cfinput type="Text" class="regularxl" name="criteriadescription" value="#get.CriteriaDescription#" 
		message="Please enter a description" validate="noblanks" required="Yes" size="50" maxlength="50" onChange="javascript:check(criterianame.value,this.value)">
		
		<cfelse>
		
			<cfoutput>
			<input type="Text" class="regularxl" name="criteriadescription" id="criteriadescription" value="#get.CriteriaDescription#" 
			 size="50" maxlength="50" #dis#>
			</cfoutput> 
				
		</cfif>
		
	</TD>
 </TR>
  
 <TR>
    <TD class="labelmedium"><cf_tl id="Tooltip">:</TD>
    <TD> 
		<cfif url.status eq "0">
		
			<cfinput 
			    type      = "Text" 
			    class     = "regularxl" 
			    name      = "CriteriaMemo" 
			    value     = "#get.CriteriaMemo#" 
			    message   = "Please enter a description" 
				required  = "No" 
				size      = "60" 
				maxlength = "100">
							
		<cfelse>
			<cfoutput>
			<input type="Text" class="regularxl" name="CriteriaMemo" id="CriteriaMemo" value="#get.CriteriaMemo#" size="60" maxlength="100" #dis#>
			</cfoutput>
		</cfif>	
		
	</TD>
 </TR>
 
 <cfif userreport.functionClass eq "System">
 	 <cfset cl = "hide">
 <cfelse>
 	 <cfset cl = "regular"> 
 </cfif>
 
 <TR class="<cfoutput>#cl#</cfoutput>">
    <TD class="labelmedium">Parameter Class:</TD>
    <TD> 
	    <table><tr>
		<td class="labelmedium"><input type="radio" class="radiol" name="criteriaclass" id="criteriaclass" <cfoutput>#dis#</cfoutput> value="Selection" <cfif Get.CriteriaClass eq "Selection" or #get.CriteriaClass# eq "">checked</cfif>></td>
		<td class="labelmedium">Filter</td>
		<td class="labelmedium"><input type="radio" class="radiol" name="criteriaclass" id="criteriaclass" <cfoutput>#dis#</cfoutput> value="Layout" <cfif Get.CriteriaClass eq "Layout">checked</cfif>></td>
		<td class="labelmedium">Presentational Setting</td>
		<td><input type="radio" name="criteriaclass" class="radiol" id="criteriaclass" <cfoutput>#dis#</cfoutput> value="Condition" <cfif Get.CriteriaClass eq "Condition">checked</cfif>></td>
		<td class="labelmedium">Condition</td>
		</tr>
		</table>
	</TD>
 </TR>
 	
<TR>
    <TD class="labelmedium">Grid Position:</TD>
    <TD>
	<table><tr><td style="width:130">
	<cfif Get.CriteriaOrder eq "">
	<!---value="0" message="Please enter a valid order" required="Yes" size="2" maxlength="3" class="regularxl amount">
		   value="0" message="Please enter a valid order" validate="integer" required="Yes" size="3" maxlength="3" class="regularxl amount">---->
	 <cfinput type="Text" name="CriteriaOrder" 
	   value="0" message="Please enter a valid order" validate="integer" required="Yes" size="2" maxlength="2" class="regularxl amount">
	<cfelse>
	 <cfinput type="Text" name="CriteriaOrder" value="#Get.CriteriaOrder#" 
	   message="Please enter a valid order" validate="integer" required="Yes" size="2" maxlength="2" class="regularxl amount">
	</cfif>  
	</td>
	<td class="labelmedium" width="80">Width:</td>
    <TD>
	<cfif Get.CriteriaOrder eq "">
	 <cfinput type="Text" name="CriteriaWidth" 
	   value="30" message="Please enter a width" validate="integer" required="Yes" size="3" maxlength="3" class="regularxl amount">
	<cfelse>
	 <cfinput type="Text" name="CriteriaWidth" value="#Get.CriteriaWidth#" 
	   message="Please enter a width" validate="integer" required="Yes" size="3" maxlength="3" class="regularxl amount">
	</cfif>   
    </TD>
	</tr>
	</table> 
    </TD>
	</TR>
		
<TR>
    <TD class="labelmedium">Obligatory:</TD>
    <TD> 
	<table><tr><td style="width:130" class="labelmedium">
	  <input type="radio" class="radiol" name="CriteriaObligatory" id="CriteriaObligatory" <cfoutput>#dis#</cfoutput> value="0" <cfif #Get.CriteriaObligatory# eq "0" or #Get.CriteriaObligatory# eq "">checked</cfif>>No
	  <input type="radio" class="radiol" name="CriteriaObligatory" id="CriteriaObligatory" <cfoutput>#dis#</cfoutput> value="1" <cfif #Get.CriteriaObligatory# eq "1">checked</cfif>>Yes
	  </td>
	  <cfif get.CriteriaName eq "mission">
	  <td width="80" class="labelmedium"><cf_UIToolTip  tooltip="Selection is filtered for mission/entities to which the user has been granted role access">Filter content on role:</cf_UIToolTip></td>
	  <td class="labelmedium">
	  <input type="radio" class="radiol" name="CriteriaRole" id="CriteriaRole"   <cfoutput>#dis#</cfoutput> value="0" <cfif Get.CriteriaRole eq "0">checked</cfif>>No
	  <input type="radio" class="radiol" name="CriteriaRole" id="CriteriaRole"   <cfoutput>#dis#</cfoutput> value="1" <cfif Get.CriteriaRole eq "1">checked</cfif>>Yes		  
	  </td>
	  <cfelse>
	  <input type="hidden" name="CriteriaRole" value="0">
	  </cfif>
	</TD>
    </TR>
	</table>
	</td>
</tr>	
	 
<TR>
    <TD class="labelmedium">Error message:</TD>
    <TD> 
	
		<cfif url.status eq "0">
		
			<cfinput type="Text" class="regularxl" name="CriteriaError" value="#get.CriteriaError#" 
		message="Please enter a description" validate="noblanks" required="No" size="60" maxlength="80">
			
		<cfelse>
			<cfoutput>
			<input type="Text" class="regularxl" name="CriteriaError" id="CriteriaError" value="#get.CriteriaError#" disabled size="60">
			</cfoutput>
		</cfif>	
	
	</TD>
</TR>
	 
<TR>
    <TD class="labelmedium">Help text:</TD>
    <TD> 
	
		<cfif url.status eq "0">
		
			<cfinput type="Text" class="regularxl" name="CriteriaHelp" value="#get.CriteriaHelp#" 
			message="Please enter a description" required="No" size="60" maxlength="100">
			
		<cfelse>
		
			<cfoutput>
			<input type="Text" class="regularxl" name="CriteriaHelp" id="CriteriaHelp" value="#get.CriteriaHelp#" disabled size="60">
			</cfoutput>
			
		</cfif>	
		
	</TD>
</TR>
	 
    <cfif get.CriteriaDescription eq "" and get.CriteriaName eq "">
	  <cfset s = "Disabled">
	<cfelse>
	  <cfset s = "">
	</cfif>
 	
<TR>
    <td width="100" class="labelmedium">Parameter type:</td>
    <TD height="25" class="labelmedium"> 
	
	  <cfif URL.Status eq "0">
	  
		  <cfset var="">
		
		  <cfif UserReport.FunctionClass neq "System">
			  <select name="criteriatype" id="criteriatype" class="regularxl" onChange="show('draft','reset')" <cfoutput>#s#</cfoutput>>
			     <cfif get.CriteriaType eq "">
				   <option value="" <cfif Get.CriteriaType eq "">selected</cfif>>--Select--</option>
				 </cfif>
				  <option value="text" <cfif Get.CriteriaType eq "text" or Get.CriteriaType eq "integer"><cfset var="0">selected</cfif>>Input/Text</option>
				  <option value="textarea" <cfif Get.CriteriaType eq "textarea"><cfset var="1">selected</cfif>>Input Area</option>
				  <!---
			  	  <option value="integer" <cfif Get.CriteriaType eq "integer"><cfset var="2">selected</cfif>>Integer (deprecated)</option>
				  --->
			  	  <option value="date" <cfif Get.CriteriaType eq "date"><cfset var="3">selected</cfif>>Date</option>
				  <option value="list" <cfif Get.CriteriaType eq "list"><cfset var="4">selected</cfif>>List [Manual]</option>
				  <option value="lookup" <cfif Get.CriteriaType eq "lookup"><cfset var="5">selected</cfif>>List [Single field selection]</option>
				  <option value="extended" <cfif Get.CriteriaType eq "extended"><cfset var="6">selected</cfif>>List [Multiple field selection]</option>
				  <option value="tree" <cfif Get.CriteriaType eq "tree"><cfset var="7">selected</cfif>>List Tree [if authorised]</option>
				  <option value="unit" <cfif Get.CriteriaType eq "unit"><cfset var="8">selected</cfif>>List Unit [if authorised]</option>
			  </select>
			  
			  <cfoutput>
			  <input type="hidden" name="criteriatypeold" id="criteriatypeold" value="#var#">
			  </cfoutput>
		  
	  		<cfelse>
			    <select name="criteriatype" id="criteriatype" class="regularxl" onChange="show('draft','')" <cfoutput>#s#</cfoutput>>
				 <cfif get.CriteriaType eq "">
				   <option value="" <cfif Get.CriteriaType eq "">selected</cfif>>--Select--</option>
				 </cfif>
				  <option value="text"     <cfif Get.CriteriaType eq "text">selected</cfif>>Text</option>
				  <option value="textlist" <cfif Get.CriteriaType eq "textlist">selected</cfif>>Text List</option>
			  	  <option value="integer"  <cfif Get.CriteriaType eq "integer">selected</cfif>>Integer</option>
			  	</select>
		  </cfif>
	  
	  <cfelse>
	  
		  <cfoutput>
		  <input type="hidden" name="Get.CriteriaType" id="Get.CriteriaType" value="#Get.CriteriaType#">
		  <b>#Get.CriteriaType#</b>
		  </cfoutput>
		  
	  </cfif>	  
	
	</TD>
	</TR>		
		
		
<cfinclude template="CriteriaEditFormType.cfm">
	  
<tr><td height="5" ></td></tr>
<tr><td height="1" colspan="2" class="linedotted"></td></tr>

<cfif url.id1 neq "" and get.criteriatype neq "">  
	 <tr>
		<td height="34" colspan="2" align="center" class="labelmedium">

		<cfif URL.Status eq "0">
		
			<cfif URL.ID1 neq "" and get.CriteriaName neq "" and url.borrow eq "0">
				<input class="button10g"  style="width:120;height:25" type="button" name="Delete" id="Delete" value="Delete" onclick="save('delete')">
			</cfif>
			<cfif url.borrow eq "1">
				<input class="button10g"  style="width:120;height:25" type="button" name="ClearMe" id="ClearMe" value="Back" onclick="save('clearme')">
			</cfif>			
			<input class="button10g"  style="width:120;height:25" type="button" name="update" id="update" value="Update" onclick="save('update')">
			<input class="button10g"  style="width:120;height:25" type="button" name="UpdateClose" id="UpdateClose" onclick="save('updateclose')" value="Save & Close">
			
		<cfelseif URL.Status neq "0">
		
		    <font size="2" color="FF0000"><b>Attention:</b></font> <font size="2" color="FF0000">Report deployed. Changes can and will not be saved.	
			
		</cfif>
	   </td>  
	 </tr>
</cfif> 
     
</table>

 </CFFORM>

</td></tr>
</table>



