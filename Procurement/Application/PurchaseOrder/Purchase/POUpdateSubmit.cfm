<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cfparam name="Form.UserDefined1"    default="">
<cfparam name="Form.UserDefined2"    default="">
<cfparam name="Form.UserDefined3"    default="">
<cfparam name="Form.UserDefined4"    default="">

<cfparam name="Form.ClauseCode"      default="''">
<cfparam name="Form.ShippingDate"    default="">
<cfparam name="Form.DeliveryDate"    default="">

<cfset dateValue = "">
	
<cfquery name="PO" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM   Purchase
   WHERE  PurchaseNo = '#URL.ID1#'
</cfquery>	

<cfparam name="Form.ActionStatusOld" default="#PO.ActionStatus#">
<cfparam name="Form.ActionStatus"    default="#PO.ActionStatus#">

<cfif PO.PersonNo eq "" and PO.Payroll eq "0">

	<cfif Form.ShippingDate neq ''>
	    <CF_DateConvert Value="#Form.ShippingDate#">
	    <cfset shipping = dateValue>
	<cfelse>
	    <cfset shipping = 'NULL'>
	</cfif>	
	
	<cfif Form.DeliveryDate neq ''>
	    <CF_DateConvert Value="#Form.DeliveryDate#">
	    <cfset delivery = dateValue>
	<cfelse>
	    <cfset delivery = 'NULL'>
	</cfif>	

</cfif>		

<cfparam name="Form.StandardCode" default="">
<cfparam name="Form.ProgramCode" default="">

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#PO.Mission#' 
	</cfquery>
	
<cfquery name="Update" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   UPDATE Purchase
   SET ActionStatus = '#Form.ActionStatus#',	      
	   OrderClass   = '#Form.OrderClass#', 
	   OrderType    = '#Form.OrderType#',		
	   <cfif Form.PrintDocumentId eq "">
	   PrintDocumentId = NULL,
	   <cfelse>
	   PrintDocumentId = '#Form.PrintDocumentId#',		   
	   </cfif>
	   <cfif Form.IncoTerms neq "">
	   IncoTerms  = '#Form.IncoTerms#', 
	   </cfif> 
	   <cfif Parameter.TreeVendor neq "">
	   
		   <cfif Form.StandardCode eq "">
		   	   StandardCode = NULL,
		   <cfelse>
			   StandardCode  = '#Form.StandardCode#',
		   </cfif>
		   
		    <cfif Form.ProgramCode eq "">
		   	   ProgramCode  = NULL,
		    <cfelse>
		       ProgramCode   = '#Form.ProgramCode#',		   
		   </cfif> 
	   
	   </cfif>
	   <cfif PO.PersonNo eq "" and PO.Payroll eq "0">
	       OrgUnitVendor  = '#Form.VendorOrgUnit#',
		   ShippingDate   = #shipping#,
		   DeliveryDate   = #delivery#,	
		   <cfif form.transportcode neq "">
		   TransportCode = '#Form.TransportCode#',
		   </cfif>
	   </cfif> 	
	   <cfif PO.Payroll eq "0">   
		   Condition     = '#Form.POCondition#',			 			  			   	  
		   UserDefined1  = '#Form.UserDefined1#',
		   UserDefined2  = '#Form.UserDefined2#',
		   UserDefined3  = '#Form.UserDefined3#',
		   UserDefined4  = '#Form.UserDefined4#',
	   </cfif>
	   Remarks    = '#Form.PORemarks#' 
   WHERE PurchaseNo = '#URL.ID1#'
</cfquery>	

<!--- -------------------- --->	
<!--- saving custom fields --->
<!--- -------------------- --->

<cfif PO.PersonNo eq "" and PO.Payroll eq "0">
	
	<cfquery name="CleanTopics" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  DELETE FROM PurchaseTopic
	  WHERE PurchaseNo = '#URL.ID1#'
	</cfquery>
			
	<cfquery name="GetTopics" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT *
	  FROM Ref_Topic 
	  WHERE  Code IN (SELECT Code 
                         FROM   Ref_TopicOrderType 
			          WHERE  OrderType = '#PO.OrderType#')
         AND    (Mission = '#PO.Mission#' or Mission is NULL)				 
         AND    Operational = 1 
	</cfquery>
	
	<cfloop query="getTopics">		
	
		 <cfif ValueClass eq "List">
		 
		 		<cfparam name="FORM.Topic_#Code#" default="">
	
				<cfset value  = Evaluate("FORM.Topic_#Code#")>
				
				 <cfquery name="GetList" 
						  datasource="AppsPurchase" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  SELECT *
						  FROM   Ref_TopicList T
						  WHERE  T.Code = '#Code#'
						  AND    T.ListCode = '#value#'				  
				</cfquery>
							
				<cfif value neq "">
							
					<cfquery name="InsertTopics" 
					  datasource="AppsPurchase" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  INSERT INTO PurchaseTopic
						 		 (PurchaseNo,
								  Topic,
								  ListCode,
								  TopicValue,
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
					  VALUES ('#URL.ID1#',
					          '#Code#',
							  '#value#',
							  '#getList.ListValue#',
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
					</cfquery>
				
				</cfif>
				
		<cfelse>
			
				<cfif ValueClass eq "Boolean">					
					  <cfparam name="FORM.Topic_#Code#" default="0">
				<cfelse>
		             <cfparam name="FORM.Topic_#Code#" default=""> 
    				</cfif>
				
				<cfset value  = Evaluate("FORM.Topic_#Code#")>
				
				<cfif value neq "">
				
					<cfquery name="InsertTopics" 
					  datasource="AppsPurchase" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  INSERT INTO PurchaseTopic
					 		 (PurchaseNo, Topic, TopicValue,OfficerUserId,OfficerLastName,OfficerFirstName)
					  VALUES ('#url.id1#','#Code#','#value#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
					</cfquery>	
				
				</cfif>
			
		</cfif>	

	</cfloop>
	
</cfif>	
	
 <cfquery name="CheckMission" 
			 datasource="AppsEmployee"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     Organization.dbo.Ref_EntityMission 
				 WHERE    EntityCode     = 'ProcPO'  
				 AND      Mission        = '#PO.Mission#' 
 </cfquery>
		
 <cfif CheckMission.WorkflowEnabled eq "0">		
			
	<cfif Form.ActionStatus neq Form.ActionStatusOld>
	
		<!---  3. enter action --->
		<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO PurchaseAction 
					 (PurchaseNo, 
					  ActionStatus, 
					  ActionDate, 
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			 VALUES 
				 ('#URL.ID1#', 
				  '#Form.ActionStatus#', 
				  getDate(), 
				  '#SESSION.acc#', 
				  '#SESSION.last#', 
				  '#SESSION.first#')
		</cfquery>
	
	</cfif>
	
</cfif>	

<!--- remove clauses which are not selected anymore  --->

<cfquery name="Delete" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   DELETE FROM PurchaseClause
	   WHERE PurchaseNo = '#URL.ID1#'
	   AND ClauseCode NOT IN (#preserveSingleQuotes(Form.ClauseCode)#)
</cfquery>
	
<cfloop index="itm" list="#Form.ClauseCode#" delimiters="','">
	
		<cfquery name="Check" 
			   datasource="AppsPurchase" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT * FROM PurchaseClause
			   WHERE PurchaseNo = '#URL.ID1#'
			   AND ClauseCode = '#itm#'
		</cfquery>
		
		<cfif Check.recordcount eq "0">
		
			<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO PurchaseClause
			 (PurchaseNo, ClauseCode, ClauseName, ClauseText, OfficerUserId, OfficerLastName, OfficerFirstName) 
			 SELECT  '#URL.ID1#', Code, ClauseName, ClauseText, '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#'
			 FROM    Ref_Clause
			 WHERE   Code = '#itm#'
			</cfquery>
		
		</cfif>
	  
	</cfloop>

    <!--- address --->

	<cfquery name="PO" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   	SELECT *
    FROM Purchase
	WHERE PurchaseNo = '#URL.ID1#' 
	</cfquery>
	
	<cfif PO.PersonNo eq "" and PO.Payroll eq "0">
	
	<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#PO.Mission#' 
	</cfquery>
			
	  <cfloop index="tpe" list="#Parameter.AddressTypeInvoice#,#Parameter.AddressTypeTransport#,#Parameter.AddressTypeShipping#" delimiters=",">
	  
	       <cfset address1 = Evaluate("FORM.Address1_" & #tpe#)>
		   <cfset address2 = Evaluate("FORM.Address2_" & #tpe#)>
		   <cfset City     = Evaluate("FORM.City_" & #tpe#)>
		   <cfset State    = Evaluate("FORM.State_" & #tpe#)>
		   <cfset PostalCode   = Evaluate("FORM.PostalCode_" & #tpe#)>
		   <cfset Country      = Evaluate("FORM.Country_" & #tpe#)>
		   <cfset Tel          = Evaluate("FORM.TelephoneNo_" & #tpe#)>
		   <cfset Fax          = Evaluate("FORM.FaxNo_" & #tpe#)>
		   <cfset eMail        = Evaluate("FORM.eMailAddress_" & #tpe#)>
		   <cfset Contact      = Evaluate("FORM.Contact_" & #tpe#)>
	  
		   <cfquery name="Update" 
		   datasource="AppsPurchase" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE PurchaseAddress 
		   SET   Address1            = '#address1#',
				 Address2            = '#address2#',
				 City                = '#city#',
				 State               = '#state#',
				 PostalCode          = '#PostalCode#',
				 Country             = '#country#',
				 TelephoneNo         = '#Tel#',
				 FaxNo               = '#fax#',
				 eMailAddress        = '#eMail#',
				 Contact             = '#contact#'
	 	   WHERE PurchaseNo  = '#URL.ID1#'
		   AND   AddressType = '#tpe#'
		   </cfquery>
	  	  
	  </cfloop>
	  
	 </cfif> 
	  
<!--- Updating funding JORGE MAZARIEGOS --->
<cfquery name="Delete" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  DELETE FROM PurchaseFunding
  WHERE  PurchaseNo = '#URL.ID1#'
</cfquery>

<cfquery name="ToBeFunded" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  
  INSERT INTO PurchaseFunding
          (PurchaseNo,Fund,Period,ProgramCode,ObjectCode,Amount)

  SELECT   POLine.PurchaseNo, 
           ReqFund.Fund, 
		   ReqFund.ProgramPeriod,
		   ReqFund.ProgramCode, 
		   ReqFund.ObjectCode, 
       	   SUM(POLine.OrderAmountBase * ReqFund.Percentage) AS AmountToBeFunded
		   
  FROM     PurchaseLine POLine INNER JOIN
           RequisitionLineFunding ReqFund ON POLine.RequisitionNo = ReqFund.RequisitionNo LEFT OUTER JOIN
           PurchaseFunding PF ON POLine.PurchaseNo = PF.PurchaseNo 
		              AND ReqFund.Fund        = PF.Fund 
					  AND ReqFund.ProgramCode = PF.ProgramCode 
					  AND ReqFund.ObjectCode  = PF.ObjectCode
  WHERE    POLine.PurchaseNo = '#URL.ID1#' 
  
  GROUP BY POLine.PurchaseNo, 
	 	   ReqFund.Fund, 
		   ReqFund.ProgramPeriod, 
		   ReqFund.ProgramCode, 
		   ReqFund.ObjectCode
		  	 
</cfquery>
 	
<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>

	<script language="JavaScript">	 
	   window.location = "POView.cfm?mid=#mid#&header=#url.header#&ID1=#URL.ID1#&Mode=view"						 
	</script>

</cfoutput>
