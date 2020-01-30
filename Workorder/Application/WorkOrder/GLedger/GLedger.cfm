
<cfquery name="Ledger" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AreaGledger
	ORDER BY ListingOrder
</cfquery>

<table width="100%" align="center" class="formspacing">

	<cfoutput query="Ledger">
	
		<tr>
		   <td class="labelit" style="padding-left:5px"><cf_tl id="#Description#">:<cf_space spaces="40"></td>
		   <td width="93%">
		   
				<cfquery name="Account" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   WorkOrderGLedger A, 
				           Accounting.dbo.Ref_Account B,
						   Ref_AreaGledger G
					WHERE  A.GLAccount = B.GLAccount
					AND    A.WorkorderId = '#URL.workorderid#'	
					AND    G.Area   = A.Area   
					AND    A.Area   = '#Area#'
					ORDER BY ListingOrder
				</cfquery>
				
				<cfif area neq "Income" and area neq "Return" and BillingEntry eq "0">
				   <cfset filter = "balance">
				   <cfset field = "AccountClass">		   				   
				<cfelse>  
				   <cfset filter = "result">
				   <cfset field = "AccountClass">				
				</cfif>
			
			    <img src="#SESSION.root#/Images/search.png" alt="Select" name="img3#area#" 
					onMouseOver="document.img3#area#.src='#SESSION.root#/Images/contract.gif'" 
					onMouseOut="document.img3#area#.src='#SESSION.root#/Images/search.png'" style="border:1px solid gray;border-radius:3px;"
					style="cursor: pointer;" width="24" height="23" border="0" align="absmiddle" 
					onClick="selectaccountgl('#get.mission#','#field#','#filter#','','applyaccount','#area#');">

				<cfset vReq = "No">	
				<cfif lcase(area) eq "stock">
					<cfset vReq = "Yes">
				</cfif>
				
			    <cfinput type="text"   name="#area#glaccount"  id="#area#glaccount"  size="13" value="#Account.GLAccount#"  class="regularxl" readonly style="text-align: left;" message="Please, enter a valid account for #area# area." required="#vReq#">
				
			    <input type="text"     name="#area#gldescription" id="#area#gldescription"  value="#Account.Description#" class="regularxl" size="40" readonly style="text-align: left;">
			   	<input type="hidden"   name="#area#debitcredit"   id="#area#debitcredit">
			   	   
		   </td>
		</tr>		
							
	</cfoutput>
	
	<tr><td colspan="2" class="line">
	<table><tr><td style="height:30px">
	<cfoutput>
	<input type="button" 
	     id="glprocess" 
		 class="button10g"
		 style="width:100px"
		 value="Save"
		 onclick="ColdFusion.navigate('../GLedger/GledgerSubmit.cfm?workorderid=#url.workorderid#','ledgerbox','','','POST','workorderform')">
	</cfoutput>	 
	</td><td id="ledgerbox"></td></tr></table>
	</td></tr>
		   
</table>
