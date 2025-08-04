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

<script language="JavaScript">
	
	function address(fld,val) {
	se = parent.document.getElementById(fld)
	if (se.value == "")
	    {se.value = val}
	else { se.value = se.value+","+val }
	}
	
</script>

<cfquery name="System" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Parameter	
</cfquery>  

<cfquery name="User" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     UserNames
	 WHERE    Account = '#SESSION.acc#'
</cfquery>			

<cfif System.ExchangeServer neq "" and User.MailServerAccount neq "">	

	<cfexchangeconnection action="OPEN"
	          connection  = "ConExch"
	          server      = "#System.ExchangeServer#"
		      username    = "#User.MailServerAccount#"
	          password    = "#User.MailServerPassword#"
			  serverversion="2016"
	          protocol    = "https">

		<cfexchangecontact action="get"
	          connection  = "ConExch"
			  name        = "Address"> 
			  
			  <cfif url.name neq "">
			  <cfexchangefilter name="LastName" value="#URL.Name#">			
			  </cfif>
			  
		</cfexchangecontact>	  
			  
	<cfexchangeconnection action="close" connection="ConExch">			  

<cfelse>
	
	<cfquery name="Address" 
	datasource="AppsSystem">
	
	    SELECT  TOP 50 LastName,FirstName,eMailAddress as EMail1 <!--- ,AccountGroup --->
	    FROM    UserNames
		WHERE   eMailAddress > ''
		AND     (LastName LIKE '#URL.Name#%' OR FirstName LIKE '#URL.Name#%')
		
		UNION
		SELECT   TOP 50 LastName,FirstName,eMailAddress as eMail1 <!--- ,AccountGroup --->
		FROM     AddressBook
		WHERE    (LastName LIKE '#URL.Name#%' OR FirstName LIKE '#URL.Name#%' OR FullName LIKE '#URL.Name#%')
		ORDER BY LastName
		
	</cfquery>
	
</cfif>	

<table width="97%" class="navigation_table formpadding">

<cfoutput query="Address">

	<cfif eMail1 neq "">
		<cfset mail = replaceNoCase(eMail1,'"','','ALL')>
		<tr class="line labelmedium navigation_row">
		   <td style="padding-left:6px" rowspan="2"><input type="button" name="To"  id="To"  value="To"  class="button10g" onclick="javascript:address('mailto','#Mail#')" style="width: 40px;"></td>
		   <td rowspan="2"><input type="button" name="Cc"  id="Cc"  value="Cc"  class="button10g" onclick="javascript:address('mailcc','#Mail#')" style="width: 40px;"></td>
		   <td rowspan="2"><input type="button" name="Bcc" id="Bcc" value="Bcc" class="button10g" onclick="javascript:address('mailbcc','#Mail#')" style="width: 40px;"></td>
		   <td rowspan="2">&nbsp;</td>
		   <td width="70%">#FirstName# #LastName# <!--- (#AccountGroup#) ---></td>
		</tr>
		<tr class="labelmedium line navigation_row_child">   
		   <td width="70%" style="padding-left:30px"><font color="0080C0">#Mail#</td>
		</tr>		
	</cfif>
	
</cfoutput>
</table>

<cfset ajaxonload("doHighlight")>
