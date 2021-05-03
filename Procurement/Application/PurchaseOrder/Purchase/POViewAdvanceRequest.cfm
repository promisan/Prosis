
<cf_screentop height="100%" 
    scroll="Yes" html="No" jquery="Yes" layout="webapp" banner="gray" line="no"
	label="Purchase Advance" option="record a advance request for this purchase order">

<cf_dialogLedger>

<cfform method="POST" name="entry">

<table width="92%" align="center" class="formpadding formspacing">

	<cfquery name="PO"
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM  Purchase
		WHERE PurchaseNo = '#URL.ID#'				
	</cfquery>	

	<cfif PO.OrgUnitVendor neq "">

		<cfquery name="PurchaseHeader"
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT P.*, O.OrgUnitName as Beneficiary
			FROM  Purchase P, Organization.dbo.Organization O
			WHERE P.OrgUnitVendor = O.OrgUnit
			AND   P.PurchaseNo = '#URL.ID#'				
		</cfquery>	
	
	<cfelse>
	
		<cfquery name="PurchaseHeader"
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT P.*, O.FirstName+ ' '+O.LastName as Beneficiary
			FROM   Purchase P, 
			       Employee.dbo.Person O
			WHERE  P.PersonNo = O.PersonNo
			AND    P.PurchaseNo = '#URL.ID#'				
		</cfquery>	
	
	</cfif>

	<!--- Query returning search results --->
	<cfquery name="Purchase"
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM  PurchaseLine
		WHERE PurchaseNo = '#URL.ID#'		   
	</cfquery>	
	
	<!--- Query returning search results --->
	<cfquery name="Parameter"
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM  Ref_ParameterMission
		WHERE Mission = '#PurchaseHeader.Mission#'		   
	</cfquery>	

	<!--- Query returning search results --->
	<cfquery name="CurrencySelect"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Currency
		WHERE Currency IN (SELECT Currency 
		                   FROM   CurrencyExchange 
						   WHERE  EffectiveDate <= getDate())
				   
		ORDER BY Currency				   
	</cfquery>	
	
<cfoutput>	

<tr><td></td></tr>	
<tr class="labelmedium2">
	<td><cf_tl id="Beneficiary">:</td>
	<td>#PurchaseHeader.Beneficiary#</td>
</tr>	

<tr class="labelmedium2">
	<td><cf_tl id="Source">:</td>
	<td>#PurchaseHeader.PurchaseNo#</td>
</tr>	


<tr class="labelmedium2">
	<td height="23"<cf_tl id="Requester">:</td>
	<td>#SESSION.first# #SESSION.last#</td>
</tr>

<tr class="labelmedium2">
	<td><cf_tl id="ReferenceNo">:</td>
	<td><input type="text" class="regularxxl" name="ReferenceNo" id="ReferenceNo" size="20" maxlength="20"></td>
</tr>

<tr class="labelmedium2">
	<td><cf_tl id="Description">:</td>
	<td><input type="text" class="regularxxl" name="ReferenceName" id="ReferenceName" size="60" maxlength="100"></td>
</tr>		

</cfoutput>
		
<tr class="labelmedium2">
<td><cf_tl id="Currency">:</td>
<td>

	<select name="currency" id="currency" class="regularxxl">
	 <cfoutput query="CurrencySelect">
	    <option value="#Currency#" <cfif Purchase.currency eq currency>selected</cfif>>#Currency#</option>
	 </cfoutput> 
	</select>

</td>

</tr>

<tr class="labelmedium2">
	<td><cf_tl id="Amount">:</td>
	<td><input type="text" class="regularxxl" name="Amount" id="Amount" style="text-align:right" size="10" maxlength="20"></td>

</tr>

<script>

	function applyaccount(acc) {
		   ptoken.navigate('setAccount.cfm?account='+acc,'process')
	}  
  
</script>

<tr class="labelmedium2">

 <td>Debit Account:</td>
          <td align="left">	
		  
		    <cfoutput>	 
			
			<!--- Query returning search results --->
			<cfquery name="Acc"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   Ref_Account
				WHERE  GLAccount = '#Parameter.AdvanceGLAccount#'		   
			</cfquery>	
			
			<table cellspacing="0" cellpadding="0">
				<tr>
					
					<td ><input type="text" class="regularxxl"name="glaccount" id="glaccount" size="6" value="#Acc.GLAccount#"   class="regularxl" readonly style="text-align: center;"></td>
					<td style="padding-left:3px"><input type="text" name="gldescription" id="gldescription"      value="#Acc.Description#" class="regularxxl" size="34" readonly style="text-align: center;"></td>
					<td style="padding-left:3px">
				    <img src="#SESSION.root#/Images/search.png" alt="Select account" name="img3" 
						  onMouseOver="document.img3.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
						  style="cursor: pointer;" width="25" height="25" border="0" align="absmiddle" 
						  onClick="selectaccountgl('#PurchaseHeader.mission#','glaccount','','','applyaccount','');">
					</td>
					<td class="hide" id="process"></td>
				</tr>
			</table>
			
		   </cfoutput>
		   
		  </td>	
		  
</tr>




<tr class="labelmedium2">
	<td><cf_tl id="Memo">:</td>
	<td><input type="text" class="regularxxl" name="Memo" id="Memo" size="60" maxlength="100"></td>
</tr>

<tr><td colspan="2" id="result"></td></tr>

<tr><td colspan="2" align="center" class="line">

  <cfoutput>
	<input type="button" name="Submit" id="Submit" value="Close" class="button10g" style="width:130px" onclick="parent.ProsisUI.closeWindow('myadvance',true)">
	<input type="button" name="Submit" id="Submit" value="Submit" class="button10g" style="width:130px"
			 onclick="ptoken.navigate('POViewAdvanceRequestSubmit.cfm?id=#url.id#','result','','','POST','entry')">
  </cfoutput>
  
</td></tr>

</table>

</cfform>

<cf_screenbottom layout="webapp">
