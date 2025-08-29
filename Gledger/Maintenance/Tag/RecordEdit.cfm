<!--
    Copyright © 2025 Promisan B.V.

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
			  title="Edit Financial Tag" 
			  label="Edit Financial Tag" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfoutput>

<cf_ajaxRequest>

<script language="JavaScript">

function selected(val,mde) {
				
	url = "ObjectSelect.cfm?ts="+new Date().getTime()+"&id1=#url.id1#&val="+val+"&mode="+mde;

	AjaxRequest.get(
	
	{
        'url':url,
        'onSuccess':function(req){ 
	document.getElementById("object").innerHTML = req.responseText;},
					
        'onError':function(req) { 
	document.getElementById("object").innerHTML = req.responseText;}	
         }
	 );					 
}

</script>

</cfoutput>
  
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Category
WHERE Code = '#URL.ID1#'
</cfquery>

<cfquery name="Class" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_CategoryClass
</cfquery>

<cfquery name="MissionSelect" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ParameterMission
</cfquery>

<cfquery name="Entity" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Entity
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="94%" align="center" class="formpadding">
	
    <cfoutput>
	
	 <tr><td></td></tr>	
	
	 <TR>
	 <TD width="80" class="labelmedium2">Entity:&nbsp;</TD>  
	 <TD width="80%">
	 	<select name="EntityCode" class="regularxxl">
		<cfloop query="entity">
		<option value="#EntityCode#" <cfif entitycode eq get.entityCode>selected</cfif>>#EntityDescription#</option>
		</cfloop>
		</select>
	 </TD>
	 </TR>
	 
	 <TR>
	 <TD width="80" class="labelmedium2">Mission:&nbsp;</TD>  
	 <TD width="80%">
	 	<select name="Mission" class="regularxxl">
		<option value=""></option>
		<cfloop query="missionSelect">
		<option value="#Mission#" <cfif mission eq get.mission>selected</cfif>>#Mission#</option>
		</cfloop>
		</select>
	 </TD>
	 </TR>
	 	 
	 <TR>
	 <TD width="80" class="labelmedium2">Class:&nbsp;</TD>  
	 <TD width="80%">
	 	<select name="CategoryClass" class="regularxxl">
		<cfloop query="Class">
		<option value="#Code#" <cfif code eq get.categoryClass>selected</cfif>>#Description#</option>
		</cfloop>
		</select>
	 </TD>
	</TR>
	
	<TR>
	 <TD class="labelmedium2">Code:&nbsp;</TD>  
	 <TD>
	 	<input type="Text" name="Code" value="#get.Code#" size="20" maxlength="20" class="regularxxl">
		<input type="hidden" name="CodeOld" value="#get.Code#" size="20" maxlength="20"class="regular">
	 </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium2">Description:&nbsp;</TD>
    <TD>
  	  	<input type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
	</TD>
	</TR>
	
    <TR>
    <TD class="labelmedium2">Relative&nbsp;Order:</TD>
    <TD>
  	  	<cfinput type="Text" name="Listingorder" value="#get.ListingOrder#" message="Please enter a valid number" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="3" maxlength="3" class="regularxl">
	</TD>
	</TR>
	
	<TR>
    <TD class="labelit">Operational:&nbsp;</TD>
	
	<TD class="labelmedium">
	    <input type="radio" class="radiol" name="Operational" value="1" <cfif get.Operational is "1">checked</cfif>>
		Yes
		<input type="radio" class="radiol" name="Operational" value="0"  <cfif get.Operational is "0">checked</cfif>>
		No
    </TD>
	
	<tr><td class="labelmedium2">Show for:&nbsp;</td>	
	    <td id="object"><cfinclude template="ObjectSelect.cfm"></td>		
	</tr>	
		
	</cfoutput>

	<tr><td height="1"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
  
	<tr>	
	<td colspan="2" height="35" align="center">	
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		
		<cfquery name="CountRec" 
	     datasource="AppsLedger" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT    *
	     FROM     FinancialObjectAmountCategory
	     WHERE    Category = '#URL.ID1#' 
		 </cfquery>
		
	    <cfif CountRec.recordCount eq 0 >
			<input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
		</cfif>
		<input class="button10g" type="submit" name="Update" value=" Update ">
		
	</td>	
	</tr>
	
</TABLE>
	
<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record?")) {
		return true 
	}
	return false	
}	

</script>

</cfform>
