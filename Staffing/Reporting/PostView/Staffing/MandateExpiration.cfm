<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_screentop height="100%" scroll="No" html="No" jquery="yes">

<cfinvoke component = "Service.Access"  
   method           = "staffing" 
   mission          = "#URL.Mission#"
   mandate          = "#URL.Mandate#"
   returnvariable   = "mandateAccessStaffing">	
   
<cfinvoke component = "Service.Access"  
   method           = "position" 
   mission          = "#URL.Mission#"
   mandate          = "#URL.Mandate#"
   returnvariable   = "mandateAccessPosition">	   

<cfif mandateAccessStaffing eq "NONE" and mandateAccessPosition eq "NONE">

	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">

		<tr><td align="center" class="labelmedium" style="padding-top:40px"><font color="FF0000">You have no access to this staffing period.<br>Please contact your administrator</td></tr>
	
	</table>	

<cfelse>
	
	<table width="98%" align="center" height="100%" border="0" cellspacing="0" cellpadding="0">
	 
	  <tr><td height="4"></td></tr>
	  
	 <tr>
	     <td style="padding-left:10px" class="labelmedium"><font color="red">Expired : Parent Positions which have fallen of from the workforce table as its expiration date was reached.</font></td>
	 </tr>
	 
	 <tr><td height="4"></td></tr>
		
	 <tr>
	  <td height="100%" valign="top">
	  
	  <cfset url.dte = dte>
	  <cf_listingscript>
	  <cfinclude template="MandateExpirationContent.cfm">	
		
	  </td>
	 </tr>
						  
	</table>   
	
</cfif>	