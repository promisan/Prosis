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
<cfparam name="URL.claimid" default="00000000-0000-0000-0000-000000000000">

<cfquery name="Claim" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     Claim
WHERE    ClaimId = <cfqueryparam
					value="#URL.ClaimId#"
				    cfsqltype="CF_SQL_IDSTAMP">
</cfquery>

<cfif Claim.recordcount eq "0">

	<cf_message message="Sorry, your request can not be completed." return="no">
	<cfabort>

</cfif>


<cfset URL.topic = "trip">

<cfoutput>

<cfdocument 
          format="PDF"
          pagetype="letter"
          margintop="0.25"
          marginbottom="0.25"
          marginright="0.2"
          marginleft="0.2"
          orientation="portrait"
          unit="in"
          encryption="none"
          fontembed="Yes"
          backgroundvisible="Yes">
		  
		  <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
		  
		  <cfset pdf = 1>
		  
		  <cfdocumentitem type="header">
		  <table width="100%" cellspacing="0" cellpadding="0">
		  <tr><td align="left">
		  <b>Travel Claim Portal</b>
		  </td>
		  <td align="right">Another #SESSION.welcome# product</td>
		  </tr>
		  <tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
		  </table>	  
		  </cfdocumentitem>
		  
		  <cfdocumentitem type="footer">
		  <table width="100%" cellspacing="0" cellpadding="0">
		  <tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
		  <tr>
		  	<td align="left">Travel Claim Portal</td>
			<td align="right">Printed on : #dateformat(now(),CLIENT.DateFormatShow)#</td>
		  </tr>
		  </table>	  
		  </cfdocumentitem>		  
				
			<cfquery name="Claim" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Claim, stPerson
				WHERE  ClaimId = '#URL.ClaimId#'
				AND Claim.PersonNo = stPerson.PersonNo
			</cfquery>				
		 
		 <table width="100%" cellspacing="0" cellpadding="0">
		 
		 	 <tr><td height="29" align="left"><font face="Verdana" size="2"><b>1. Claimant</td></tr>
			 <tr><td height="1" bgcolor="d0d0d0"></td></tr>
			 <tr><td height="4"></td></tr>
			 <tr><td>
			 <table width="97%" cellspacing="2" cellpadding="2" align="center">
			  <tr><td width="150">Name:</td><td><b>#Claim.FirstName# #Claim.LastName#</td></tr>
			  <tr><td>Index No:</td><td><b>#Claim.IndexNo#</td></tr>
			 </table>
			 
			</td></tr>
			<tr><td height="10"></td></tr>
				
			<tr><td height="24" align="left"><font face="Verdana" size="2"><b>2. Travel Request</td></tr>
			 <tr><td height="1" colspan="2" bgcolor="d0d0d0"></td></tr>
			<tr><td>		  
			 <cfinclude template="../ClaimEntry/ClaimRequest.cfm">
			</td></tr>
			<tr><td height="10"></td></tr>  			 		 			
			<tr><td height="24" align="left"><font face="Verdana" size="2"><b>3. Travel Claim Summary</td></tr>
			<tr><td height="1" bgcolor="d0d0d0"></td></tr>	 
			<tr><td><table width="98%" align="center"><tr><td> 
				  <cfinclude template="../EventEntry/ClaimEvent.cfm">	
			  </td></tr></table>	  
			</td></tr>
			<tr><td height="1" bgcolor="C0C0C0"></td></tr>
		 
		 </table> 
		  
		  
</cfdocument>  	
</cfoutput>	  