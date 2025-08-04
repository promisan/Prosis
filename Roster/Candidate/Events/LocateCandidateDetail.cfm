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

<cfset condition = "">

<cfif Form.LastName neq "">
  <cfset condition = "#condition# AND A.LastName LIKE '%#Form.LastName#%'">
</cfif>

<cfif Form.FirstName neq "">
  <cfset condition = "#condition# AND A.FirstName LIKE '%#Form.FirstName#%'">
</cfif>

<cfif Form.Nationality neq "">
  <cfset condition = "#condition# AND A.Nationality = '#Form.Nationality#'">
</cfif>

<cfif Form.Gender neq "">
  <cfset condition = "#condition# AND A.Gender = '#Form.Gender#'">
</cfif>

<cfif Form.AgeFrom neq ''>
    <cfset condition = "#condition# AND DateDiff(month, A.DOB, getdate())/12 >= '#Form.AgeFrom#' ">	
</cfif>

<cfif Form.AgeTo neq ''>
    <cfset condition = "#condition# AND DateDiff(month, A.DOB, getdate())/12 <= '#Form.AgeTo#' ">		
</cfif>

<cfif Form.IndexNo neq "">
  <cfset condition = "#condition# AND A.IndexNo LIKE '%#Form.IndexNo#%'">
</cfif>

<!--- disabled based on the 700 record rule below 
<cfif condition eq "">
   <cf_message message="You must select at least one search criteria" return="no">
   <cfabort>
</cfif>
--->

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  count(*) as total
	FROM    Applicant A
	WHERE   1=1
	#preserveSingleQuotes(condition)# 
</cfquery>

<cfif Check.total gt "1000">
    <script>
		Prosis.busy('no')
	</script>
   <cf_message 
     message="Your search resulted in more than 1000 candidates. Please narrow down your search."
	 return="no">
   <cfabort>
</cfif>

<cfquery name="Searchresult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Applicant A
	WHERE   1=1
			#preserveSingleQuotes(condition)# 
	ORDER BY A.LastName, A.FirstName
</cfquery>

<table style="width:98.5%" align="center" bgcolor="white"><tr><td>

<table width="100%"  align="center" class="navigation_table">

<TR class="line labelmedium fixrow fixlengthlist">
    <TD></TD>
    <TD><cf_tl id="Last name"></TD>
	<TD><cf_tl id="Middle name"></TD>
    <TD><cf_tl id="First name"></TD>
    <TD align="center"><cf_tl id="Nat"></TD>
    <TD align="center">S</TD>
    <TD align="center"><cf_tl id="DOB"></TD>
    <TD align="center"><cf_tl id="IndexNo"></TD>
    <TD align="center"></TD>
    <TD align="center"><cf_tl id="Entered"></TD>
	<td width="25"></td>
 </TR>
 
 <tr class="fixrow2"><td height="20" colspan="11" class="labelmedium line" style="font-size:21px;padding-left:3px;height:45"><a href="javascript:addCandidate('')"><cf_tl id="Record Candidate"></a></td></tr>
 
<CFOUTPUT query="SearchResult">

<TR class="navigation_row line labelmedium fixlengthlist" style="height:17px" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F6F6F6'))#">

    <cfif url.mode eq "Event">
	<td style="padding-left:5px;padding-top:4px;padding-right:5px">  
		<cf_img icon="select" navigation="Yes" onClick="documentadd('#PersonNo#')">
	</td>
	<cfelse>
	<td style="padding-left:5px;padding-top:4px;padding-right:5px">  
		<cf_img icon="select" onClick="parent.candidateApply('#PersonNo#')">
	</td>
	</cfif>
	<TD><a href="javascript:ShowCandidate('#PersonNo#')" title="Profile"><font color="6688aa">#LastName#</a></TD>
	<TD>#MiddleName#</TD>
	<TD>#FirstName#</TD>
	<TD align="center">#Nationality#</TD>
	<TD align="center">#Gender#</TD>
	<td align="center">#DateFormat(DOB, CLIENT.DateFormatShow)#</td>
	<TD align="center">#IndexNo#</A></TD>
	<TD align="center"><!---#Description#---></TD>
	<td align="center">#DateFormat(Created, CLIENT.DateFormatShow)#</td>
	<td>
		<cfif eMailAddress is not ''>
			<a href="javascript:email('#eMailAddress#','','','','Applicant','#PersonNo#')">
			<img src="#SESSION.root#/Images/mail5.gif" alt="Mail" border="0"></A>
		</cfif>
	</td>		
</TR>

</CFOUTPUT>

</TABLE>

</td></tr>

</table>

<cfset ajaxonload("doHighlight")>

<script>
	Prosis.busy('no')
</script>

