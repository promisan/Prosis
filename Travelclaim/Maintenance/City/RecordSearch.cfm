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
<HTML><HEAD>
    <TITLE>City search</TITLE>
</HEAD>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<script>

	function check() {
		if (window.event.keyCode == "13")
			{ search() }
	}	
		
</script>		

<body onLoad="window.CitySelect.focus()">
  
<cf_divscroll>
  
<cfinclude template="CityScript.cfm">	

<cfset Header = "Travel claim purpose">
<cfset page="0">
<cfset add="0">
<cfinclude template="../HeaderTravelClaim.cfm"> 	

<table width="100%" cellspacing="0" cellpadding="0" align="center" >

<tr><td colspan="2">

    <table width="97%" cellspacing="1" cellpadding="1" align="center" class="formpadding">
		
	<tr><td height="5"></td></tr>
 	
	<tr>
	<td class="labelit">City name:</td>
	
	<td>
	<input type="text" onKeyUp="check()" name="CitySelect" id="CitySelect" size="50"> 	
	</td>
	</tr>
	
	<tr>
	<td class="labelit">City code:</td>
	
	<td>
	<INPUT type="text" onKeyUp="check()" name="CityCodeSelect" id="CityCodeSelect" size="4"> 	
	</td>
	</tr>
	
	<cfquery name="Country" 
		datasource="AppsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
	    FROM System.dbo.Ref_Nation
	    WHERE Code IN (SELECT LocationCountry FROM Ref_CountryCity)
		ORDER BY Name
	</cfquery>	

	<tr>
	<td class="labelit">Country:</td>
	<td>
	
		<select name="CountrySelect" id="CountrySelect">
		    <option value="">-------------  All  ------------</option>
			<cfoutput query="country">
			<option value="#code#">#Name#</option>
			</cfoutput>
		</select>
		
	</td>
	</tr>
	
	<tr><td height="34" colspan="2" align="center">
	  <input class="button10g" type="button" name"Submit" value="Search" onclick="search()">
 	</td></tr>
	
	<tr><td height="1" colspan="3" class="linedotted"></td></tr>
	<tr><td height="2" colspan="3" align="right"></td></tr>
	<tr id="searching" class="hide">
		<td align="center" colspan="3"><b>I am searching now ..</td>
	</tr>
	<tr><td colspan="3" id="result"></td></tr>
		
</table>	

</cf_divscroll>

</BODY></HTML>