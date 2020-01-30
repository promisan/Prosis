
<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Parameter
</cfquery>

<cfoutput>
 
<cftry>

	<!----- Guat3mala09 ---->
	<cfexchangeconnection action="OPEN"
          connection   = "mycon"
          server       = "#get.ExchangeServer#"
          username     = "#url.mailbox#"
          mailboxname  = "#url.mailbox#"
          password     = "#url.mailpassword#"
          port         = "636"
          protocol     = "https"
		  serverversion= "2013">
		  
		<cf_tl id="Valid Mail box" var="1">		 		  
	    <img style="cursor:pointer" src="#SESSION.root#/Images/check_mark2.gif" align="absmiddle" alt="#lt_text#" border="0">
	   	&nbsp;Success !
			
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
