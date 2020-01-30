
<cf_textareascript>

<cf_screentop layout="webapp" jquery="Yes" height="100%" scroll="no" label="#url.purchaseno# Clause Edit Form">
  
<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   PurchaseClause
WHERE  ClauseCode = '#URL.ClauseCode#' 
AND    PurchaseNo = '#URL.PurchaseNo#'
</cfquery>

<!--- Entry form --->

<cfoutput>
<FORM action="POViewClauseEditSubmit.cfm?mode=#url.mode#&purchaseno=#url.purchaseNo#&clausecode=#url.clausecode#" 
   target="result" method="post">
	
	<table width="98%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	    <tr><td></td></tr>
		<tr class="hide"><td><iframe name="result" id="result"></iframe></td></tr>
	     <!--- Field: Description --->
	    <TR>
	    <TD class="labelmedium" width="100" height="20">Code:</TD>
	    <TD class="labelmedium">
	  	   <cfoutput>#URL.ClauseCode#</cfoutput>
	    </TD>
		
	    <TD class="labelmedium">Description:</TD>
	    <TD>
	  	    <cfloop query="get">		
				<input type="Text" class="regularxl" name="ClauseName" value="#ClauseName#" message="Please enter a description" required="Yes" size="30" maxlength="30">
			</cfloop>
	    </TD>
		</TR>
	  
	    <!--- Field: Capacity --->
	    <TR>
	    <td height="100%" colspan="4" style="padding-top:10px"> 						
		 <cf_textarea name="clausetext" init="yes" height="94%" toolbar="full" color="ffffff"><cfoutput>#Get.ClauseText#</cfoutput></cf_textarea>				
		</TD>
		</TR>	
		
		<tr><td colspan="4" align="center" height="37">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">	
		<input class="button10g" type="submit" name="Update" id="Update" value="Update">
		</td></tr>
		
	</TABLE>

</FORM>
</cfoutput>
