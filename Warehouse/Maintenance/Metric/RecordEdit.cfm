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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Metric" 
			  option="Maintaing Metric - #url.id1#" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_Metric
		WHERE 	Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT  TOP 1 Metric
		FROM 	AssetItemActionMetric
		WHERE 	Metric  = '#URL.ID1#' 
		
		UNION
		
		SELECT  TOP 1 Metric
		FROM 	ItemSupplyMetric
		WHERE 	Metric  = '#URL.ID1#'
		
		UNION
		
		SELECT  TOP 1 Metric
		FROM 	Ref_AssetActionMetric
		WHERE 	Metric  = '#URL.ID1#'
		
</cfquery>

<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this metric?")) {	
		return true 	
		}	
		return false	
	}	

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="95%" align="center" class="formpadding formspacing">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
		<cfif CountRec.recordCount eq 0>
  	   		<cfinput type="text" name="code" value="#get.Code#" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxxl">
		<cfelse>
		   <input type="hidden" name="Code" id="Code" value="#get.Code#">
			#get.Code#
		</cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
	   <cfinput type="text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>UoM:</TD>
    <TD>
  	   <cfinput type="text" name="MeasurementUoM" value="#get.MeasurementUoM#" message="Please enter a valid uom" required="No" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <td>Measurement:</td>
    <TD>
		<select name="measurement" id="measurement" class="regularxxl">
			<option value="Cumulative" <cfif lcase(get.measurement) eq "cumulative">selected</cfif>>Cumulative
			<option value="Increment" <cfif lcase(get.measurement) eq "increment">selected</cfif>>Increment
		</select>
    </td>
    </tr>
	
	<TR>
    <td class="labelit">Operational:</td>
    <TD class="labelit">
		<input type="radio" name="operational" id="operational" class="radiol" value="1" <cfif get.operational eq 1>checked</cfif>>Yes
		<input type="radio" name="operational" id="operational" class="radiol" value="0" <cfif get.operational eq 0>checked</cfif>>No		
    </td>
    </tr>
		
	</cfoutput>
	
	<tr><td height="6"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td height="6"></td></tr>
	
			
	<tr>
		
	<td align="center" colspan="2">	
	
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<cfif CountRec.recordCount eq 0>
    <input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	</cfif>
    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	</tr>
	
</TABLE>

</cfform>
	
<cf_screenbottom layout="innerbox">
