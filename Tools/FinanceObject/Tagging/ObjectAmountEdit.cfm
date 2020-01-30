
<cfquery name="Amount" 
 datasource="AppsLedger"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM  FinancialObjectAmount OA
 WHERE OA.Objectid = '#URL.ObjectId#'
 AND   OA.SerialNo = '#URL.SerialNo#'
</cfquery>

<cfoutput>

<input type="Text" 
	name="tagamount#URL.SerialNo#"
	id="tagamount#URL.SerialNo#" 
	value="#numberFormat(Amount.Amount,"__.__")#" 
	size="8" 
	class="regularxl"
	style="text-align: right;" 
	onChange="saveamount('#URL.ObjectId#','#URL.SerialNo#')">
	
</cfoutput>	


		

