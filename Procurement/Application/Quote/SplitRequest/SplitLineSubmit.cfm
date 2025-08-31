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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<!--- steps
1. Verify if total amount <= previous amount
2. disable req line old : 9
loop through lines 1 -14
3. insert new line from old line (requsitionNo : "old-#row#")
4. copy requisitionline actor
5. copy requisitionline action
6. copy requisitionline funding
--->

<cf_tl id="REQ061" var="1">
<cfset vReq061=#lt_text#>

<cf_tl id="REQ062" var="1">
<cfset vReq062=#lt_text#>

<cf_tl id="REQ063" var="1">
<cfset vReq063=#lt_text#>

<cf_tl id="REQ064" var="1">
<cfset vReq064=#lt_text#>

<cf_tl id="REQ065" var="1">
<cfset vReq065=#lt_text#>

<cf_tl id="Operation not allowed." var="1">
<cfset vONA=#lt_text#>


<cfoutput>

<!--- 1. Verify if total amount <= previous amount --->
<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM RequisitionLine
	WHERE RequisitionNo = '#URL.ID#' 
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#Line.Mission#' 
</cfquery>

<cfset total = 0>
<cfset cnt   = 0>

<cfloop index="Rec" from="1" to="#Form.row#" step="1">

  <cfset des      = Evaluate("FORM.requestdescription_" & #Rec#)>
  <cfset amt      = Evaluate("FORM.requestamountbase_" & #Rec#)>
  <cfif amt neq "" and des neq "">

  	<cfif LSisNumeric(amt)>
    	 <cfset total = total + amt>
		 <cfset cnt = cnt +1>
	<cfelse>
		 <cf_message message = "#vReq061# Operation not allowed."
		  return = "back">
		 <cfabort>
	</cfif>
  </cfif>

</cfloop>

<cfif NumberFormat(total,"__.__") gt NumberFormat(Line.RequestAmountBase,"__.__")>

	 <cf_alert message = "#vReq062# [#NumberFormat(total,",__.__")#] #vReq063# [#NumberFormat(Line.RequestAmountBase,",__.__")#]. #vONA#"
	  return = "back">
	 <cfabort>

</cfif>

<cfif NumberFormat(total,"__.__") lt NumberFormat(Line.RequestAmountBase*0.9,"__.__")>

	 <cf_alert message = "#vReq062# [#NumberFormat(total,",__.__")#] #vReq064# [#NumberFormat(Line.RequestAmountBase,",__.__")#]. #vONA#"
	  return = "back">
	 <cfabort>
</cfif>

<cfif cnt lt "2">
	 <cf_alert message = "#vReq065# <p></p> #vONA#"
	  return = "back">
	 <cfabort>
</cfif>

</cfoutput>

<!--- prepare files --->

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SplitReq"> 
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SplitReqActor">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SplitReqAction">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SplitReqFund">
		
<cfquery name="SelectRequisition" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   INTO   userQuery.dbo.#SESSION.acc#SplitReq
   FROM   RequisitionLine
   WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="SelectActor" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   INTO   userQuery.dbo.#SESSION.acc#SplitReqActor
   FROM   RequisitionLineActor
   WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="SelectAction" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   INTO   userQuery.dbo.#SESSION.acc#SplitReqAction
   FROM   RequisitionLineAction
   WHERE  RequisitionNo = '#URL.ID#'
</cfquery>
		
<cfquery name="SelectFund" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   INTO   userQuery.dbo.#SESSION.acc#SplitReqFund
   FROM   RequisitionLineFunding
   WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cftransaction> 

<!--- 2. disable req line old : 0z --->

<cfquery name="Reset" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE RequisitionLine
	SET    ActionStatus = '0z', 
	       JobNo = NULL
	WHERE  RequisitionNo = '#URL.ID#'
</cfquery>
			
<!--- loop through lines --->

<cfloop index="Rec" from="1" to="#Form.row#">

  <cfset des      = Evaluate("FORM.requestdescription_" & #Rec#)>
  <cfset uom      = Evaluate("FORM.requestuom_" & #Rec#)>
  <cfset qty      = Evaluate("FORM.requestquantity_" & #Rec#)>
  <cfset prc      = Evaluate("FORM.requestcostprice_" & #Rec#)>
  <!---
  <cfset cpr      = Evaluate("FORM.requestcurrencyprice_" & #Rec#)>
  ---> 
  <cfset cpr      = prc>
  <cfset amt      = Evaluate("FORM.requestamountbase_" & #Rec#)>
    
  <cfif amt neq "" and des neq "">
      
  	<cfif LSisNumeric(amt)>
	
	<!--- insert line --->
	
	<cfquery name="UpdateRequisition" 
	   datasource="AppsPurchase" 
   	   username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       UPDATE userQuery.dbo.#SESSION.acc#SplitReq 
       SET RequisitionNo = '#URL.ID#_#Rec#'
    </cfquery>
			
	<cfquery name="InsertRequisition" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  INSERT INTO RequisitionLine
	  SELECT *
	  FROM   userQuery.dbo.#SESSION.acc#SplitReq
	</cfquery>
			
	<cfquery name="UpdateRequisition" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">		
	   UPDATE RequisitionLine 
	   SET    RequestDescription   = '#des#',
			  RequestQuantity      = '#qty#',
			  QuantityUoM          = '#uom#',
			  RequestCostPrice     = '#prc#',
			  RequestCurrency      = '#APPLICATION.BaseCurrency#',
			  RequestCurrencyPrice = '#cpr#',
			  RequestAmountBase    = '#amt#',
			  ParentRequisitionNo  = '#URL.ID#'
		WHERE RequisitionNo = '#URL.ID#_#Rec#'
	</cfquery>
	
	<!--- insert actor --->
	
	<cfquery name="UpdateActor" 
	   datasource="AppsPurchase" 
   	   username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       UPDATE userQuery.dbo.#SESSION.acc#SplitReqActor 
       SET    RequisitionNo = '#URL.ID#_#Rec#'
    </cfquery>
			
	<cfquery name="InsertActor" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  INSERT INTO RequisitionLineActor
	  SELECT *
	  FROM   userQuery.dbo.#SESSION.acc#SplitReqActor
	</cfquery>
	
	<!--- insert actor --->
	
	<cfquery name="UpdateAction" 
	   datasource="AppsPurchase" 
   	   username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       UPDATE userQuery.dbo.#SESSION.acc#SplitReqAction 
       SET    RequisitionNo = '#URL.ID#_#Rec#'
    </cfquery>
			
	<cfquery name="InsertAction" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  INSERT INTO RequisitionLineAction
	  SELECT *
	  FROM   userQuery.dbo.#SESSION.acc#SplitReqAction
	</cfquery>
	
	<!--- insert fund --->
	
	<cfquery name="UpdateFunding" 
	   datasource="AppsPurchase" 
   	   username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       UPDATE userQuery.dbo.#SESSION.acc#SplitReqFund 
       SET    RequisitionNo = '#URL.ID#_#Rec#'
    </cfquery>
			
	<cfquery name="InsertFunding" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  INSERT INTO RequisitionLineFunding
	  SELECT  *
	  FROM    userQuery.dbo.#SESSION.acc#SplitReqFund
	</cfquery>
	
		<!--- create blank quotation records --->
		
		<cfif Line.JobNo neq "">
			
			<!--- 1. define entries in JobVendor --->
		
			<cfquery name="Vendor" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT *
				 FROM JobVendor
				 WHERE JobNo = '#Line.JobNo#'
			</cfquery>
			
			<!--- 2. loop insert requisitionline in linequote for each vendor --->
			
			<cfloop query="Vendor">
			
				<cfquery name="Insert" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 INSERT INTO RequisitionLineQuote
					        (RequisitionNo, JobNo, OrgUnitVendor, VendorItemDescription, QuoteTax, QuotationQuantity, QuotationUoM, Currency)
					 SELECT RequisitionNo, '#JobNo#', '#OrgUnitVendor#', RequestDescription, '#Parameter.TaxDefault#', RequestQuantity, QuantityUoM, '#APPLICATION.BaseCurrency#'
					 FROM   RequisitionLine 
					 WHERE  RequisitionNo = '#URL.ID#_#Rec#'
				</cfquery>
				
			</cfloop>
	
		</cfif>
													
	</cfif>
			
  </cfif>

</cfloop>

</cftransaction> 

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SplitReq"> 
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SplitReqActor">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SplitReqAction">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SplitReqFund">

<script>
	 parent.parent.ProsisUI.closeWindow('mysplit')	
	 try {
	 parent.parent.document.getElementById('menu1').click()
	 } catch(e) {}
</script>





