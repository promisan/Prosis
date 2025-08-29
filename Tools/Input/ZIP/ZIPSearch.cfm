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
<cf_screentop layout="webapp" jquery="yes" html="No">

<script>

  function zipsearch() {
     _cf_loadingtexthtml='';	
     ptoken.navigate('ZIPSearchResult.cfm','zipresult','','','POST','zipform')
  }
  
  function zipselected(zip,city,country) {
       parent.zipapply(zip,city,country)	         		
  }
		
</script>

<form name="zipform" method="post" width="100%" height="98%">

<cfparam name="URL.FormName"   default="">
<cfparam name="URL.fldzip"     default="">
<cfparam name="URL.fldcity"    default="">
<cfparam name="URL.fldcountry" default="">
<cfparam name="URL.country"    default="">

<cfoutput>
<INPUT type="hidden" name="FormName"          id="FormName"           value="#URL.FormName#">
<INPUT type="hidden" name="AddressPostalCode" id="AddressPostalCode"  value="#URL.fldzip#">
<INPUT type="hidden" name="AddressCity"       id="AddressCity"        value="#URL.fldcity#">
<INPUT type="hidden" name="Country"           id="Country"            value="#URL.fldcountry#">
<INPUT type="hidden" name="PCountry"          id="PCountry"           value="#URL.country#">

	<table width="100%" height="100%" align="center">
	
	<!---
	<tr class="line">
	<td style="height:50;font-weight:200;font-size:21px;padding-left:5px" class="labelmedium">
	<img src="#SESSION.root#/Images/zipcode.png" alt="" width="45" height="45" border="0" align="absmiddle">
	<cf_tl id="Postal code search">
	</td></tr>
	--->
	
	</cfoutput>
	
	<tr><td height="30">
	
	    <table width="100%" align="center" class="formpadding">
				
		<TR>
		<TD style="padding-left:10px" class="labelit"><cf_tl id="Code">:</TD>	
		<TD>		
		<input type="text" name="PostalCode" id="PostalCode" size="50" class="regularxl" onKeyUp="zipsearch()"> 	
		</TD>
		</TR>
	 	
		<TR>
		<TD style="padding-left:10px" class="labelit"><cf_tl id="Location">:</TD>	
		<TD>		
		<input type="text" name="Location" id="Location" size="50" class="regularxl" onKeyUp="zipsearch()"> 	
		</TD>
		</TR>
		
		<!---
				
		<cfquery name="Area" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT PostalAreaName
		    FROM Ref_PostalCode
			<cfif URL.Country neq "">
				WHERE Country = '#URL.Country#'
			</cfif>	
		   	ORDER BY PostalAreaName
		</cfquery>	
	
		<TR>
		<TD style="padding-left:10px" class="labelit">Area:</TD>
		<TD>
		
			<select name="Area" id="Area" class="regularxl" onchange="zipsearch()">
			    <option value="">--------  <cf_tl id="select">  -------</option>
				<cfoutput query="Area">
				<option value="#PostalAreaName#">#PostalAreaName#</option>
				</cfoutput>
			</select>
			
		</TD>
		</TR>
		
		--->
		
		<tr><td height="2"></td></tr>			
				
		<tr><td height="25" colspan="3" align="center">
		
			<cf_tl id="Submit Search" var="1">
			<cfoutput>
				<input class="button10g" style="width:97%" type="button" onclick="zipsearch()" name"Search" id="Search" value="#lt_text#">
			</cfoutput>
		
		</td></tr>
		
		<tr><td height="5"></td></tr>
		
		</table>
			
	</td>
	</tr>
	
	<TR>
	     <TD height="100%" style="padding-left:10px;padding-right:10px" valign="top">
		 
		 <cf_divscroll id="zipresult">
		 			
				<table width="100%" height="100%">
				<tr><td align="center" class="labelmedium">
				<cf_tl id="Please enter your criteria and press Submit">......
				</td></tr>
				</table>
				
		</cf_divscroll>		
					
		 </TD>
	</TR>	
	</table>

</FORM>
