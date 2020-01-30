<cfquery name="Get" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   C.*
	FROM     Claim C
	WHERE    C.ClaimId = '#URL.claimId#' 	
</cfquery>	


<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding" align="center">
<cfform method="POST" name="briefs" action="../Briefs/BriefsSubmit.cfm?claimid=#url.claimid#">
<tr><td class="line"></td></tr>
<tr><td height="100%">

<cftextarea name="ClaimMemo"
   toolbaronfocus="Yes"
   enabled="Yes"
   visible="Yes"		  
   richtext="Yes"	   
   toolbar="Basic"       
   skin="silver"
   class="regular">
	 <cfoutput>#get.ClaimMemo#</cfoutput>
</cftextarea>
			 
				 <!--- toolbar="Basic" --->

</td></tr>
<tr><td colspan="2" class="line"></td></tr>
<tr><td align="center" height="30">
<input value="Save" type="submit" class="button10g" name="Save">
</td></tr>
</cfform>
</table>

