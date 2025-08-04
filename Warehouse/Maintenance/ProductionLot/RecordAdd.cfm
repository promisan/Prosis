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
			  label="Production Lot" 
			  option="Add Lot" 
			  banner="gray"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cf_dialogOrganization>
<cf_calendarScript>

<cf_PreventCache>

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <TR>
    <TD class="labelit"><cf_tl id="Entity">:</TD>
    <TD class="labelit">
  	   	<cfquery name="missionlist"
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT	*
				FROM	Ref_ParameterMission
			</cfquery>
			
		<cfselect name="mission" id="mission" query="missionlist" value="mission" display="mission" required="Yes" message="please select a mission">
		</cfselect>
		
    </TD>
	</TR>
	
	<tr class="hide">
		<td colspan="2">
			<cfdiv id="divVendorTree" bind="url:VendorTree.cfm?mission={mission}">
		</td>
	</tr>
	
	<TR>
    <TD class="labelit"><cf_tl id="Lot">:</TD>
    <TD class="labelit">
  	  
	   <cfinput type="text" 
	       name="TransactionLot" 
		   message="please enter a lot" 
		   required="yes" 
		   size="10" 
	       maxlength="10" 
		   class="regular">
	   
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Date">:</TD>
    <TD class="labelit">
		<cfset vDate = now()>
		
		<cf_intelliCalendarDate9
			FieldName="TransactionLotDate" 
			Default="#dateformat(vDate, '#CLIENT.DateFormatShow#')#"
			AllowBlank="False">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Vendor">:</TD>
    <TD class="labelit">
		<cfoutput>
			<img src="#SESSION.root#/Images/contract.gif" alt="Select vendor" name="img1" 
			onMouseOver="document.img1.src='#SESSION.root#/Images/button.jpg'" 
			onMouseOut="document.img1.src='#SESSION.root#/Images/contract.gif'"
			style="cursor: pointer;" alt="" width="17" height="18" border="0" align="absmiddle" 
			onClick="selectorgsinglemission('dialog','referenceorgunit','orgunitcode1','mission1','referencename1','orgunitclass1','',document.getElementById('vendorTree').value,'')">
			
			<cfinput type="text"  name="referencename1" class="regular" value="" size="46" maxlength="60" required="Yes" message="please select a valid vendor." readonly>
			<input type="hidden" name="referenceorgunit" id="referenceorgunit" value="">
			
			<input type="hidden" name="mission1" id="mission1" class="disabled" size="20" maxlength="20" readonly>		   	   
			<input type="hidden" name="orgunitcode1" id="orgunitcode1">
			<input type="hidden" name="orgunitclass1" id="orgunitclass1">
		</cfoutput>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Reference">:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="Reference" 
		   message="please enter a reference" 
		   required="no" 
		   size="30" 
	       maxlength="20" 
		   class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Memo">:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="Memo" 
		   message="please enter a memo" 
		   required="no" 
		   size="30" 
	       maxlength="80" 
		   class="regular">
    </TD>
	</TR>
	
	
	<tr><td height="6"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr>
	<tr><td height="6"></td></tr>
	<tr>	
		
	<tr>
		
	<td colspan="2" align="center">
	    <input class="button10g" type="submit" name="Insert" id="Insert" value="Save">	
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">