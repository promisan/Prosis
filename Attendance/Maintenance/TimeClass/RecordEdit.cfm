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

<cfset vOpt = "Maintain Time Class - #url.id1#">
<cfif url.id1 eq "">
	<cfset vOpt = "Create Time Class">
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Time Class" 			 
			  banner="yellow"
			  menuAccess="Yes" 
			  jquery="yes"
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_TimeClass
		WHERE 	TimeClass = '#URL.ID1#'
</cfquery>

<cf_colorScript>

<script language="JavaScript">

	function askDelete() {
		if (confirm("Do you want to remove this time class?")) {	
		return true 	
		}	
		return false	
	}


</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#" method="POST" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" class="formpadding formspacing" align="center">
	
	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD class="labelmedium">
  	   <cfif url.id1 eq "">
	   
	   		<cfinput type="text" 
		       name="TimeClass" 
			   value="#get.TimeClass#" 
			   message="Please enter a code"
			   required="yes" 
			   size="20" 
		       maxlength="20" 
			   class="regularxxl">
	   	
	   <cfelse>
	   
	   		<b>#get.TimeClass#</b>
	   		<input type="Hidden" name="TimeClass" id="TimeClass" value="#get.TimeClass#">
			
	   </cfif>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD class="labelmedium">
  	   
	    <cfinput type="text" 
	       name="Description" 
		   value="#get.Description#" 
		   message="Please enter a description"
		   required="yes" 
		   size="40" 
	       maxlength="50" 
		   class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Short">:</TD>
    <TD class="labelmedium">
  	   
	    <cfinput type="text" 
	       name="DescriptionShort" 
		   value="#get.DescriptionShort#" 
		   message="Please enter a short description"
		   required="no" 
		   size="20" 
	       maxlength="20" 
		   class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Order">:</TD>
    <TD class="labelmedium">
  	   
	    <cfinput type="text" 
	       name="ListingOrder" 
		   value="#get.ListingOrder#" 
		   message="Please enter a numeric order" 
		   validate="integer"
		   required="yes" 
		   size="1" 
	       maxlength="3" 
		   class="regularxxl" style="text-align:center;">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Color">:</TD>
    <TD class="labelmedium">
  	   
		<cf_color 	name="ViewColor" 
					value="#get.ViewColor#"
					style="cursor: pointer; font-size: 0; border: 1px solid gray; height: 20; width: 20; ime-mode: disabled; layout-flow: vertical-ideographic;">
			
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Show in Attendance">:</TD>
    <TD class="labelmedium">
  	   	<input type="radio" class="radiol" name="ShowInAttendance" id="ShowInAttendance" value="1" <cfif get.ShowInAttendance eq "1" or url.id1 eq "">checked</cfif>>Yes
		<input type="radio" class="radiol" name="ShowInAttendance" id="ShowInAttendance" value="0" <cfif get.ShowInAttendance eq "0">checked</cfif>>No
    </TD>
	</TR>
			
	</cfoutput>
	
		<tr><td colspan="2" class="linedotted"></td></tr>	
				
	<tr>
		
	<td align="center" colspan="2">	
    	<input class="button10g" type="submit" name="Update" id="Update" value=" Save ">
	</td>	
	</tr>
		
</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">
