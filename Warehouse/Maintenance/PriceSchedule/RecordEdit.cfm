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
			  label="Price Schedule" 
			  option="Maintaing Price Schedule - #url.id1#" 
			  banner="yellow"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT 	*
FROM 	Ref_PriceSchedule
WHERE 	Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
   datasource="appsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
      SELECT PriceSchedule
      FROM   CustomerSchedule
      WHERE  PriceSchedule  = '#URL.ID1#'
	  UNION
	  SELECT PriceSchedule
      FROM   ItemUoMPrice
      WHERE  PriceSchedule  = '#URL.ID1#'
	  UNION
	  SELECT PriceSchedule
      FROM   WarehouseCategoryPriceSchedule
      WHERE  PriceSchedule  = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this price schedule?")) {	
	return true 	
	}	
	return false	
}	

</script>


<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelmedium">
	   <b>#get.Code#</b>
  	   <input type="hidden"   name="Code" id="Code" value="#get.Code#" size="20" maxlength="10"class="labelit">
	   <input type="hidden"   name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="10"class="labelit">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="Description" 
		   value="#get.Description#" 
		   message="please enter a description" 
		   requerided="yes" 
		   size="30" 
	       maxlength="50" 
		   class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Acronym:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="Acronym" 
		   value="#get.Acronym#" 
		   message="Please enter an acronym" 
		   requerided="no" 
		   size="10" 
	       maxlength="10" 
		   class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Order:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="ListingOrder" 
		   value="#get.ListingOrder#" 
		   message="Please enter a numeric order" 
		   validate="integer"
		   requerided="yes" 
		   size="2" 
	       maxlength="3" 
		   class="regularxl" 
		   style="text-align:center;">
    </TD>
	</TR>
	
	<!--- Field: FieldDefault --->
    <TR>
    <TD class="labelit">Default Schedule:&nbsp;</TD>
    <TD class="labelit">
		<cfif get.FieldDefault eq 1>
	  	  	<b>Yes</b>
			<input type="Hidden" name="FieldDefault" id="FieldDefault" value="1">
		<cfelse>
			<input type="Checkbox" class="radiol" name="FieldDefault" id="FieldDefault">
		</cfif>
				
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr><td height="6"></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td height="6"></td></tr>	
			
	<tr>
		
	<td align="center" colspan="2">
		<cfif CountRec.recordCount eq 0 and get.FieldDefault neq 1>
		    <input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">
		</cfif>
    	<input class="button10g" type="submit" name="Update" id="Update" value="Update">
	</td>	
	</tr>
	
</TABLE>

</CFFORM>
	
<cf_screenbottom layout="innerbox">
