<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->
<cfif ParameterExists(Form.Submit)> 

<cfloop index="rec" from="1" to="#Form.Rows#">

  <cfparam name="FORM.fund_#Rec#" default="">
  
  <cfset fund        = Evaluate("FORM.fund_" & #Rec#)>
  
  <cfif fund neq "">
  
	  <cfset programcode = Evaluate("FORM.programcode_" & #Rec#)>
	  <cfset objectcode  = Evaluate("FORM.objectcode_" & #Rec#)>
	  <cfset amount      = Evaluate("FORM.amount_" & #Rec#)>
	  <cfset fundref1    = Evaluate("FORM.FundingReference1_" & #Rec#)>
	  <cfset fundref2    = Evaluate("FORM.FundingReference2_" & #Rec#)>
	  <cfset fundref3    = Evaluate("FORM.FundingReference3_" & #Rec#)>
	  <cfset fundref4    = Evaluate("FORM.FundingReference4_" & #Rec#)>
	  
	  <cfif fundref1 neq "">
	    
		  <cfquery name="Verify" 
		   datasource="AppsPurchase" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT *
		   FROM  PurchaseFunding
		   WHERE PurchaseNo   = '#URL.ID1#'
		   AND   Fund         = '#fund#'
		   AND   ProgramCode  = '#programcode#'
		   AND   ObjectCode   = '#ObjectCode#'
		 </cfquery>
		 
		 <cfif Verify.recordcount eq "1">
		 
			 <cfquery name="Update" 
			   datasource="AppsPurchase" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   UPDATE PurchaseFunding
				   SET Amount = '#Amount#',
					   FundingReference1 = '#FundRef1#',
					   FundingReference2 = '#FundRef2#',
					   FundingReference3 = '#FundRef3#',
					   FundingReference4 = '#FundRef4#',
					   OfficerUserId = '#SESSION.acc#',
					   OfficerLastName = '#SESSION.last#',
					   OfficerFirstName = '#SESSION.first#',
					   Created = getDate()
			   WHERE   PurchaseNo   = '#URL.ID1#'
		  		 AND   Fund         = '#fund#'
			     AND   ProgramCode  = '#programcode#'
				 AND   ObjectCode   = '#ObjectCode#'
			 </cfquery>
		   
		 <cfelse>
		 
		   <cfquery name="Insert" 
			   datasource="AppsPurchase" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   INSERT INTO PurchaseFunding
			        (PurchaseNo, Fund, ProgramCode, ObjectCode, Amount, FundingReference1,
			   	  	 FundingReference2, FundingReference3, FundingReference4,
				     OfficerUserId, OfficerLastName, OfficerFirstName, Created)
			   VALUES ('#URL.ID1#','#Fund#','#ProgramCode#', '#ObjectCode#', '#Amount#',
					   '#FundRef1#','#FundRef2#','#FundRef3#','#FundRef4#','#SESSION.acc#',
					   '#SESSION.last#','#SESSION.first#', getDate())
			 </cfquery>
		 	 
		 </cfif>
	 
 	</cfif>
 
 </cfif>
 
</cfloop> 

</cfif>

<cfif ParameterExists(Form.Submit)> 

	<!--- check status of funding --->
	
	<cfquery name="Funded" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT Sum(Amount) as Amount
	  FROM   PurchaseFunding
	  WHERE  PurchaseNo   = '#URL.ID1#'
	</cfquery>
	
	<cfquery name="Lines" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT Sum(OrderAmountBase) as Amount
	  FROM   PurchaseLine
	  WHERE  PurchaseNo   = '#URL.ID1#'
	</cfquery>
	
	<cfif #Funded.Amount# eq "">
		<cfset bal = #Lines.Amount#>
	<cfelse>
		<cfset bal = #Lines.Amount# - #Funded.Amount#>
	</cfif>
		
	<cfif #bal# lte "0.01">
	
		<cfquery name="Update" 
		   datasource="AppsPurchase" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE Purchase
		   SET ActionStatus = '#Form.StatusAction#'
		   WHERE PurchaseNo = '#URL.ID1#'
		</cfquery>
			
		<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO PurchaseAction 
			 (PurchaseNo, ActionStatus, ActionDate, ActionReference, OfficerUserId, OfficerLastName, OfficerFirstName) 
			 VALUES ('#URL.ID1#', '#Form.StatusAction#', getDate(), '#Form.Remarks#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
		</cfquery>
	
	</cfif>

</cfif>

<cfoutput>
<script language="JavaScript">
 
   window.location="POViewGeneral.cfm?Period=#URL.Period#&ID=#URL.ID#&ID1=#URL.ID1#&Role=#URL.Role#"
					 
</script>
</cfoutput> 


