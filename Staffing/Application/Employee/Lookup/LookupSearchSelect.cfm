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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_screentop height="100%" line="no" bannerheight="4" html="No" title="Find Employee">

<script language="JavaScript">
	window.name = "lookupEmployee"
</script>

<cfif not IsNumeric(URL.OrgUnit)>
	<cfset URL.OrgUnit = "0">
</cfif>	

<cfquery name="Unit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Organization
	WHERE OrgUnit = '#URL.OrgUnit#' 
</cfquery>

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT CODE, NAME 
    FROM Ref_Nation
	WHERE NAME > 'A'
	ORDER BY NAME
</cfquery>

<form action="LookupSearchResult.cfm" method="post">

<cfoutput>
    <INPUT type="hidden" name="Link"           id="Link"           value="#CGI.QUERY_STRING#">
	<INPUT type="hidden" name="FormName"       id="FormName"       value="#URL.FormName#">
	<INPUT type="hidden" name="fldPersonNo"    id="fldPersonNo"    value="#URL.fldPersonNo#">
	<INPUT type="hidden" name="fldIndexNo"     id="fldIndexNo"     value="#URL.fldIndexNo#">
	<INPUT type="hidden" name="fldLastName"    id="fldLastName"    value="#URL.fldLastName#">
	<INPUT type="hidden" name="fldFirstName"   id="fldFirstName"   value="#URL.fldFirstName#">
	<INPUT type="hidden" name="fldFull"        id="fldFull"        value="#URL.fldFull#">
	<INPUT type="hidden" name="fldDob"         id="fldDob"         value="#URL.fldDob#">
	<INPUT type="hidden" name="fldNationality" id="fldNationality" value="#URL.fldNationality#">
	<INPUT type="hidden" name="fnselected" 	   id="fnselected"     value="#URL.fnselected#">
	<INPUT type="hidden" name="showadd"        id="showadd"        value="#URL.showadd#">
	
</cfoutput>

<table width="97%" border="0" align="center" align="center">

<tr><td>
  
<table width="94%" border="0" align="center" class="formpadding formspacing">
    	
	<TR class="labelmedium2">
	<td style="min-width:130px"><cf_tl id="Entity">:</td>
	<TD style="width:70%">
	   <cfif Unit.Mission eq "">
		   <cfif url.mission neq "" and url.mission neq "undefined">
		       <INPUT type="text" name="Mission" id="Mission" value="<cfoutput>#url.Mission#</cfoutput>" size="30" class="regularxxl">	
		   <cfelse>
			   <INPUT type="text" name="Mission" id="Mission" size="30" class="regularxxl">	
		   </cfif>
	   <cfelse>
	   <input type="text" name="Mission" id="Mission" size="30" value="<cfoutput>#Unit.Mission#</cfoutput>" readonly class="regularxxl">	
	   </cfif>
	</TD>
	</TR>
	 
	<TR class="labelmedium2">
	<td height="20" align="left" class="labelmedium"><cf_tl id="Unit class">:</td>
	<TD>
	   <cfif Unit.Mission eq "">
	   	<INPUT type="text" name="OrgUnitClass" id="OrgUnitClass" size="30" class="regularxxl">	
	   <cfelse>
	    <input type="text" name="OrgUnitClass" id="OrgUnitClass" value="<cfoutput>#Unit.OrgUnitClass#</cfoutput>" size="30" readonly class="regularxxl">	
	   </cfif>
	  
	</TD>
	</TR>
	    
	<!--- Field: Staff.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="FullName">
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<TR class="labelmedium2">
	<td align="left"><cf_tl id="Full Name">:<input type="hidden" name="Crit2_Operator" id="Crit2_Operator" value="CONTAINS"></td>
	<TD>
		
	<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="30" class="regularxxl">
   	
	</TD>
	</TR>
	
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="IndexNo">
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR>
	<TD align="left"><cfoutput>#client.IndexNoName#</cfoutput>:<input type="hidden" name="Crit1_Operator" id="Crit1_Operator" value="CONTAINS"></TD>
	<TD>					
	<INPUT type="text" name="Crit1_Value" id="Crit1_Value" class="regularxxl" size="30">    	
	</TD>
	</TR>	
	
	<tr class="labelmedium2">	
		<TD align="left"  class="labelmedium"><cf_tl id="Assignment">: </TD>
		<td>
		<select name="OnBoard" id="OnBoard" style="width:250px" class="regularxxl">
		<option value="1"><cf_tl id="On board"></option>
		<option value="0"><cf_tl id="History"></option>
		<option value="" selected><cf_tl id="All"></option>
		</select>		
		</TD>
	</TR>
		
    <!--- Field: Staff.Gender=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="Gender">
	<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
	<INPUT type="hidden" name="Crit4_Operator" id="Crit4_Operator" value="CONTAINS">
	
	<TR>
		
	<TD align="left"  class="labelmedium"><cf_tl id="Gender">: </TD>
	
	<TD>
	
		<select name="Crit4_Value" id="Crit4_Value" style="width:250px" class="regularxxl">
			<option value="M"><cf_tl id="Male"></option>
			<option value="F"><cf_tl id="Female"></option>
			<option value="" selected><cf_tl id="All"></option>
		</select>	
		   	
	</TD>
	</TR>
	   
	<TR class="labelmedium2">
	<TD align="left"><cf_tl id="Nationality">:</TD>
	
	<TD>
    	<select name="Nationality"  id="Nationality" size="1" style="width:250px" class="regularxxl">
			<option value="" selected>[<cf_tl id="All">]</option>
		    <cfoutput query="Nation">
				<option value="'#Code#'">#Name#</option>
			</cfoutput>
	    </select>
		</TD>
	</TR>		

</TABLE>

</td>
</tr>

<tr><td height="1" class="line"></td></tr>

<tr><td colspan="2" style="padding-left:10px">
		<cf_tl id="Search" var="1">
		<input type="submit" value="<cfoutput>#lt_text#</cfoutput>" style="width:200px;height:27px" class="button10g">
	</td></tr>

</table>
	
</FORM>

<cf_screenbottom>
