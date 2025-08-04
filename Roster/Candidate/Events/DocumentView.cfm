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

<cf_screentop height="100%" jquery="Yes" scroll="Yes" html="No">

<cfset URL.ID  = "">
<cfset URL.ID1 = "">

<!--- Search form --->
<cfform method="POST" name="myform">

<table width="100%" border="0">
<tr class="line">
<td height="20" style="height:30px;padding-left:10px" class="labellarge">Search for Candidate events</td>
</tr>
</table>

<cfquery name="Status" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_PersonStatus
</cfquery>

<cfquery name="Category" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_EventCategory
</cfquery>

<cfquery name="Nationality" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   System.dbo.Ref_Nation
	WHERE Code IN (SELECT Nationality 
	               FROM Applicant A, ApplicantEvent E
	               WHERE A.PersonNo = E.PersonNo)
</cfquery>

<cfoutput>

<script>

function reloadForm(page) {
   ptoken.navigate('DocumentViewListing.cfm?ID=#URL.ID#&ID1=#URL.ID1#&Page=' + page,'result');
}
  
function documentedit(id){
    w = #CLIENT.width# - 100;
    h = #CLIENT.height# - 150;
	ptoken.open("DocumentEdit.cfm?mode=view&refer=workflow&id="+id, "eventdialog", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=no");
	
} 
	
</script>	
</cfoutput>

<cf_dialogStaffing>
		
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr class="line"><td>
<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

	<!--- Field: Pur_head.OrderType=CHAR;20;TRUE --->
		
	<TR class="labelmedium">
	<TD><cf_tl id="Category">:</TD>
			
	<td align="left" valign="top">
	<select class="regularxl" name="EventCategory" size="1">
	    <option value="" selected>All</option>
	    <cfoutput query="Category">
		<option value="#Code#">#Description#</option>
		</cfoutput>
    </select>
	</td>	
		
	<TD><cf_tl id="Assessment">:</TD>
			
	<td align="left" valign="top">
	<select name="PersonStatus"  class="regularxl" size="1">
	    <option value="" selected>All</option>
	    <cfoutput query="Status">
		<option value="#Code#">#Description#</option>
		</cfoutput>
	    </select>
	</td>	
	<TD>
	
	</TR>
	
	<!--- Field: Pur_head.OrderType=CHAR;20;TRUE --->
	
	<TR class="labelmedium">
	<TD>First name:</TD>
	<td colspan="1">	
	<input  class="regularxl" type="text" class="regular" name="FirstName" value="" size="20">
	</td>
	<TD>Last name:</TD>
	<TD>	
	<input  class="regularxl" type="text" class="regular" name="LastName" value="" size="20">
	</TD>
	</tr>
	
	</TR>
		
	<TR class="labelmedium">
	<TD>Nationality:</TD>
			
	<td align="left">
	<select  class="regularxl" name="nationality" size="1">
	    <option value="" selected>All</option>
	    <cfoutput query="Nationality">
		<option value="#Code#">#Name#</option>
		</cfoutput>
    </select>
	</td>	
		
	<TD>Gender:</TD>
			
	<td align="left" class="labelmedium">
			<table>
			<tr class="labelmedium">
			<td style="padding-left:0px"><input type="radio" name="Gender" value="M"></td>
			<td style="padding-left:3px"><cf_tl id="Male"></td>
			<td style="padding-left:4px"><input type="radio" name="Gender" value="F"></td>
			<td style="padding-left:3px"><cf_tl id="Female"></td>
			<td style="padding-left:4px"><input type="radio" name="Gender" value="" checked></td>
			<td style="padding-left:3px"><cf_tl id="Either"></td>
			</tr>
			</table>
		</td>	
			
	</TR>
	
	<!--- Field: Pur_head.VendorName=CHAR;80;FALSE --->
	<TR class="labelmedium">
	<TD><cf_tl id="Age">:</TD>
			
	<td align="left" valign="top">
	between
	<cfinput type="Text" class="regularxl" name="agefrom" validate="integer" style="text-align: center;" required="No" size="2"> -
	<cfinput type="Text" class="regularxl" name="ageto" validate="integer" style="text-align: center;" required="No" size="2"> years
	</td>	
	<TD>Index No:</TD>
			
	<td align="left" valign="top">
	   <cfinput type="Text" class="regularxl" name="IndexNo" style="text-align: center;" required="No" size="10">
	</td>	
		
	</tr>
		

</TABLE>
</td></tr>

<tr><td align="center">
    <cfoutput>
	<input type="reset"  class="button10g" value="Reset">
	<input type="button" name="Submit" value="Search" class="button10g"	
	onclick="ptoken.navigate('DocumentViewPrepare.cfm?ID=#URL.ID#&ID1=#URL.ID1#','result','','','POST','myform')">
	</cfoutput>
</td></tr>

<tr><td>
	<cfdiv id="result">
</td></tr>

</table>

</CFFORM>


