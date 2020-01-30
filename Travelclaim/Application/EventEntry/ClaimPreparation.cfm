
<cfsilent>
 <proUsr>administrator</proUsr>
 <proOwn>Hanno van Pelt</proOwn>
 <proDes>Annotated the custom method</proDes>
 <proCom></proCom>
 <proCM></proCM>
 <proInfo>
 <table><tr><td>
 1. Provides a standard header for each of the detailed claim entry screen
 2. Determines the claimedit mode 0|1 dependent on the determined user.
 </td></tr></table>
 </proinfo>
</cfsilent>

<link href="../../../print.css" rel="stylesheet" type="text/css" media="print">
		
	<script language="JavaScript">
				
	   function maximizereq(itm){
	 
		 se   = document.getElementsByName(itm)
		 icM  = document.getElementById(itm+"Min")
		 icE  = document.getElementById(itm+"Exp")
		 count = 0
		 
		 if (se[0].className == "regular") {
		 while (se[count]) { 
		    se[count].className = "hide"; 
		    count++
		  }			   
		 icM.className = "hide";
		 icE.className = "regular";
		 } else {
		 while (se[count])
		  {
		    se[count].className = "regular"; 
		    count++
		  }	
		 icM.className = "regular";
		 icE.className = "hide";			
		 }
	  }  
	  
	  function show(itm) {
	  
	  try { 
	  se = document.getElementById(itm)
	  if (se.className == "regular") {
	     se.className = "hide"
	  } else {
	     se.className = "regular"
	  }
	  
	  } catch(e) {} 
	  
	  }
			  
	</script> 

<cfquery name="Claim" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  Claim 
		WHERE ClaimId = '#URL.ClaimId#' 
</cfquery>

<cfquery name="Object" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  OrganizationObject 
		WHERE ObjectKeyValue4 = '#URL.ClaimId#' 
		AND   Operational = 1
</cfquery>

<!--- check if user may edit the claim if the following conditions are met
Active User that opens the screen = Claimant unless the dbo.parameter.enableActorSubmit = 1
--->

<cfif client.personNo neq Claim.PersonNo>

	<cfquery name="Parameter" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM  Parameter		
	</cfquery>
	
	<cfif Parameter.enableActorSubmit eq "1">
		<cfset editclaim = 1>
	<cfelse>
	    <cfset editclaim = 0>  			
	</cfif>
	
<cfelse>
	
	 <!--- user = claimant --->
	 <cfset editclaim = 1>  	
	
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="noprint">
		
	<tr><td>
		<cfset url.hide = 1>
		<cfinclude template="../ClaimEntry/ClaimRequest.cfm">	
	</td></tr>
		
<cfif claim.actionStatus lte "1">
	
	<tr><td bgcolor="silver" height="1"></td></tr>
		<tr><td height="22" class="top4n"><font color="808080"><b>&nbsp; Step 2 of 3 : Claim preparation</font></td></tr>
	<tr><td bgcolor="d4d4d4" height="1"></td></tr>
			
</cfif>

</table>