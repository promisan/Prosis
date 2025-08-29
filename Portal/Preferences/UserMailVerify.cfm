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
<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Parameter
</cfquery>

<cfoutput>
 
<cftry>
	
	<cfexchangeconnection action="OPEN"
          connection   = "mycon"
          server       = "#get.ExchangeServer#"
          username     = "#url.mailbox#"
          mailboxname  = "#url.mailbox#"
          password     = "#url.mailpassword#"         
          protocol     = "https"
		  serverversion= "#get.ExchangeServerVersion#">
		  
		<cf_tl id="Valid Mail box" var="1">		 		  
	    <img style="cursor:pointer" src="#SESSION.root#/Images/check_mark2.gif" align="absmiddle" alt="#lt_text#" border="0">
	   	&nbsp;Success !
		
		<script>
		document.getElementById('verify').className = "hide"
		</script>
			
	<cfcatch>
		
		  <table><tr><td width="40">
		  <cf_tl id="Mail box is not accessible" var="1">
		    	  	
	      <img style="cursor:pointer" src="#SESSION.root#/images/warning.gif" align="absmiddle" alt="#lt_text#" border="0">
		  </td><td class="labelit"><font face="Calibri" size="2">
		  &nbsp;<cf_tl id="Please verify if your"> #url.mailbox# <cf_tl id="account is the same as the Active Directory account of your MS Exchange 2013 Mailbox">
		  <b>(#url.mailbox#)</b>
		  </td></tr></table>	
	  
	</cfcatch>  	  

</cftry>

</cfoutput>
