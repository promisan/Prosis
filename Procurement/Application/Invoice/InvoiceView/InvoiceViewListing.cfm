
<!--- ------------------------------------------- --->
<!--- -------- GET status on the workflow ------- --->
<!--- ------------------------------------------- --->

<cfparam name="url.filter" default="all">
<cfparam name="URL.page"   default="1">
<cfparam name="URL.sort"   default="vendor">

<cfset currrow = 0>

<cfset condition = "">
<cfset text = "Matching Invoices">

<!--- clear the view which was generate for this user already --->

<CF_DropTable dbName="AppsQuery"  tblName="lsInvoice_#SESSION.acc#">	

<!--- select --->

<cfoutput>

<cfquery name="Param" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission='#URL.Mission#'
</cfquery>
	
<cfsavecontent variable="sqlselect">
	
		 DISTINCT  TOP  2500 I.*,
		 
		 		   <!--- only the last invoice here --->
				   
				   (SELECT   TOP 1 PurchaseNo						    
					FROM     InvoicePurchase IP
					WHERE    IP.InvoiceId = I.InvoiceId	
					ORDER BY DocumentAmountMatched DESC
					) as PurchaseNo,
		 				   
				   (SELECT   TOP 1 			   
						     <cfif Param.PurchaseCustomField eq "">
				             P.PurchaseNo
						     <cfelse>
						     P.Userdefined#Param.PurchaseCustomField# 
						     </cfif>
					FROM     Purchase AS P INNER JOIN
				             InvoicePurchase AS IP ON P.PurchaseNo = IP.PurchaseNo 
					WHERE    IP.InvoiceId = I.InvoiceId	
					ORDER BY DocumentAmountMatched DESC
					) as PurchaseReference,
		          				   
				   (SELECT COUNT(DISTINCT PurchaseNo) 
				    FROM   InvoicePurchase 
					WHERE  InvoiceId = I.InvoiceId) as PurchaseNos, 
				   
				   ISNULL((SELECT SUM(Amount) 
				           FROM   Accounting.dbo.TransactionHeader 
						   WHERE  ReferenceId = I.InvoiceId 
						   AND    ActionStatus != '9' 
						   AND    RecordStatus != '9'),0) as Payable,
						   
				   ISNULL((SELECT SUM(AmountOutstanding) 
				           FROM   Accounting.dbo.TransactionHeader 
						   WHERE  ReferenceId = I.InvoiceId 
						   AND    ActionStatus != '9' 
						   AND    RecordStatus != '9'),0) as Pending,
						   
		   CASE I.OrgUnitVendor WHEN 0 THEN '[Employee]' <!--- 'E:'+E.FirstName+' '+E.LastName --->
		                               ELSE OrgUnitName 
									   END as IssuedBy
	 
</cfsavecontent>				

<!--- body --->

<cfsavecontent variable="sqlbody">

       Organization.dbo.Organization AS O RIGHT OUTER JOIN         
       Invoice AS I ON O.OrgUnit = I.OrgUnitVendor
	  
</cfsavecontent>

<cfinvoke component     = "Service.Access"  
	   method           = "RoleAccess" 
	   Role             = "'ProcInvoice'"
	   Mission          = "#url.mission#" 
	   returnvariable   = "access"> 	  
	   
	   
	  
<cfif access eq "GRANTED">

	<cfset flyaccess = "">
	
<cfelse>	

   <cfsavecontent variable="flyaccess">
		AND  I.InvoiceId IN (
							 SELECT ObjectKeyValue4 
        	                 FROM   Organization.dbo.OrganizationObject O, 
				  		            Organization.dbo.OrganizationObjectAction OA
							 WHERE  O.ObjectKeyValue4 = I.InvoiceId
							 AND    O.ObjectId        = OA.ObjectId
							 AND    OA.OfficerUserId  = '#SESSION.acc#' 
							)
	</cfsavecontent>									  
		
</cfif>


<cfswitch expression="#URL.ID1#">

	<cfcase value="today">
	
		<cfset condition = "I.Created >= '#dateFormat(now()-1, CLIENT.dateSQL)#' AND I.ActionStatus != '9' AND I.Period = '#URL.Period#' AND I.Mission = '#URL.Mission#'">
			
		<cfset text = "Today's invoices">
		
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">
		   	SELECT   #preserveSingleQuotes(sqlselect)#		
			INTO     userquery.dbo.lsInvoice_#SESSION.acc#			 
		    FROM     #preserveSingleQuotes(sqlbody)#
			WHERE    #preserveSingleQuotes(Condition)#	
			         #preserveSingleQuotes(FlyAccess)#	
			<cfif url.filter eq "me">		 
			AND      I.OfficerUserId = '#SESSION.acc#'
			</cfif>					 
			ORDER BY DocumentDate
		</cfquery>
			
	</cfcase>
	
	<cfcase value="week">
	
		<cfset condition = "I.Created >= '#dateFormat(now()-7, CLIENT.dateSQL)#' AND I.ActionStatus != '9' AND I.Period = '#URL.Period#' AND I.Mission = '#URL.Mission#'">
	
		<cfset text = "This week's invoices">
		
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">
		   	SELECT   #preserveSingleQuotes(sqlselect)#	
			INTO     userquery.dbo.lsInvoice_#SESSION.acc#				 
		    FROM     #preserveSingleQuotes(sqlbody)#
			WHERE    #preserveSingleQuotes(Condition)#	
			         #preserveSingleQuotes(FlyAccess)#	 		  		   
			<cfif url.filter eq "me">		 
			AND      I.OfficerUserId = '#SESSION.acc#'
			</cfif>					 
			ORDER BY DocumentDate
		</cfquery>		

	</cfcase>
	
	<cfcase value="month">
	
		<cfset condition = "I.Created >= '#dateFormat(now()-30, CLIENT.dateSQL)#' AND I.ActionStatus != '9' AND I.Period = '#URL.Period#' AND I.Mission = '#URL.Mission#'">
	
		<cfset text = "This month's invoices">
		
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">
		   	SELECT   #preserveSingleQuotes(sqlselect)#	
			INTO     userquery.dbo.lsInvoice_#SESSION.acc#				 
		    FROM     #preserveSingleQuotes(sqlbody)#
			WHERE    #preserveSingleQuotes(Condition)#	
			         #preserveSingleQuotes(FlyAccess)#	 		  		   
			<cfif url.filter eq "me">		 
			AND      I.OfficerUserId = '#SESSION.acc#'
			</cfif>					 
			ORDER BY DocumentDate
		</cfquery>		

	</cfcase>	
	
	<!--- status --->

	<cfcase value="hold">
	
		<cfset condition = "I.ActionStatus = '0' AND I.Period = '#URL.Period#' AND I.Mission = '#URL.Mission#'">
	
		<cfset text = "On Hold">
		
		<cf_ListingScript>
		
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">
		   
			SELECT   #preserveSingleQuotes(sqlselect)#					 
			INTO     userquery.dbo.lsInvoice_#SESSION.acc#
		    FROM     #preserveSingleQuotes(sqlbody)#
			WHERE    #preserveSingleQuotes(Condition)#	
			         #preserveSingleQuotes(FlyAccess)#	
			<!--- on hold means there is No workflow created, happens only once you create a
			         different instance --->		 
		    AND      I.InvoiceId NOT IN (SELECT ObjectKeyValue4 
				                         FROM Organization.dbo.OrganizationObject
	        					         WHERE EntityCode    = 'ProcInvoice'
										 AND  ObjectKeyValue4 = I.InvoiceId) 
			<cfif url.filter eq "me">		 
			AND      I.OfficerUserId = '#SESSION.acc#'
			</cfif>		 	
			ORDER BY DocumentDate
			
		</cfquery>
			
	</cfcase>
	
	<cfcase value="pending">	
	    
		<cfset condition = "I.ActionStatus = '0' AND I.Period = '#URL.Period#' AND I.Mission = '#URL.Mission#'">
		
		<!--- we might use the period of the invoice, which usually is the same as the period of purchase
		to be considered 
		<cfset condition = "I.ActionStatus = '0' AND I.Period = '#URL.Period#' AND I.Mission = '#URL.Mission#'">
		--->		
			
		<cfset text = "Pending">
				
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">	
			   
			SELECT   #preserveSingleQuotes(sqlselect)#		
			INTO     userquery.dbo.lsInvoice_#SESSION.acc#			 
		    FROM     #preserveSingleQuotes(sqlbody)#
			WHERE    #preserveSingleQuotes(Condition)#	
			         #preserveSingleQuotes(FlyAccess)#	
			     
			  <!--- pending means there is workflow created in any stage --->		 
			  
			   AND   I.InvoiceId IN (SELECT ObjectKeyValue4 
				                 FROM Organization.dbo.OrganizationObject
	        					 WHERE EntityCode    = 'ProcInvoice'
								 AND  ObjectKeyValue4 = I.InvoiceId)
			 <cfif url.filter eq "me">		 
			AND      I.OfficerUserId = '#SESSION.acc#'
			</cfif> 		
			ORDER BY DocumentDate
						
		</cfquery>
			
			
	</cfcase>
	
	<cfcase value="completed">
	
		<cfset condition = "I.ActionStatus = '1' AND I.Period = '#URL.Period#' AND I.Mission = '#URL.Mission#'">
	
		<cfset text = "Completed">
				
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">	
			   
			SELECT   #preserveSingleQuotes(sqlselect)#		
			INTO     userquery.dbo.lsInvoice_#SESSION.acc#			 
		    FROM     #preserveSingleQuotes(sqlbody)#
			WHERE    #preserveSingleQuotes(Condition)#	
			         #preserveSingleQuotes(FlyAccess)#	
			     
			
			 <cfif url.filter eq "me">		 
			AND      I.OfficerUserId = '#SESSION.acc#'
			</cfif> 		
			ORDER BY DocumentDate
			
		</cfquery>
			
	</cfcase>
	
	<cfcase value="cancelled">	
	   
		<cfset condition = "I.ActionStatus = '9' AND I.Period = '#URL.Period#' AND I.Mission = '#URL.Mission#'">
			
		<cfset text = "Cancelled">
				
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">
		
		    SELECT   #preserveSingleQuotes(sqlselect)#		
			INTO     userquery.dbo.lsInvoice_#SESSION.acc#			 
		    FROM     #preserveSingleQuotes(sqlbody)#
			WHERE    #preserveSingleQuotes(Condition)#	
			         #preserveSingleQuotes(FlyAccess)#	
			
			  <!---		 
			   AND   (I.InvoiceId IN (SELECT ObjectKeyValue4 
				                 FROM Organization.dbo.OrganizationObject
	        					 WHERE EntityCode    = 'ProcInvoice')
					OR  I.EntityClass is NULL)
			 --->		
			<cfif url.filter eq "me">		 
			AND      I.OfficerUserId = '#SESSION.acc#'
			</cfif> 		
			ORDER BY DocumentDate
			
		</cfquery>
			
	</cfcase>
	
	<!--- special views from Program / vendor dialog and issuances --->
	
	<cfcase value="PRM">
		
		<cfset condition = "I.ActionStatus != '9' AND I.Mission = '#URL.Mission#'">				
		<cfset text = "Invoices not matched to a Purchase Order">
						
		<cfsavecontent variable="sqlbody">
			      Invoice I 
			      LEFT OUTER JOIN Organization.dbo.Organization O ON I.OrgUnitVendor = O.OrgUnit 		 
				  LEFT OUTER JOIN InvoicePurchase IP ON I.InvoiceId = IP.InvoiceId 
				  LEFT OUTER JOIN Purchase P ON IP.PurchaseNo = P.PurchaseNo
				  LEFT OUTER JOIN Employee.dbo.Person E ON P.PersonNo = E.PersonNo
		</cfsavecontent>
				
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">
		
		  SELECT   #preserveSingleQuotes(sqlselect)#	
		  INTO     userquery.dbo.lsInvoice_#SESSION.acc#				 
		  FROM     #preserveSingleQuotes(sqlbody)#
		  WHERE    #preserveSingleQuotes(Condition)#	
		           #preserveSingleQuotes(FlyAccess)#	
	      AND     I.InvoiceId NOT IN (SELECT InvoiceId FROM InvoicePurchase WHERE InvoiceId = I.InvoiceId)		
		  <cfif url.filter eq "me">		 
			AND      I.OfficerUserId = '#SESSION.acc#'
		  </cfif>   	
		  ORDER BY DocumentDate
		  
		</cfquery>
		
	</cfcase>
	
	<cfcase value="VED">
		
		<cfset condition = "I.OrgUnitVendor = '#URL.ID2#'">				
		<cfset text = "Invoices">
				
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">
		
		  SELECT   #preserveSingleQuotes(sqlselect)#	
		  INTO     userquery.dbo.lsInvoice_#SESSION.acc#				 
		  FROM     #preserveSingleQuotes(sqlbody)#
		  WHERE    #preserveSingleQuotes(Condition)#	
		           #preserveSingleQuotes(FlyAccess)#	
	     <cfif url.filter eq "me">		 
			AND      I.OfficerUserId = '#SESSION.acc#'
		  </cfif>   	
		  ORDER BY DocumentDate 
		  
		</cfquery>
				
	</cfcase>
	
	<cfcase value="PRP">
		
		<cfset condition = "I.ActionStatus != '9' AND I.Mission = '#URL.Mission#'">				
		<cfset text = "Invoices processed BUT not posted in General Ledger">
				
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">
		
		SELECT   #preserveSingleQuotes(sqlselect)#		
		INTO     userquery.dbo.lsInvoice_#SESSION.acc#			 
		FROM     #preserveSingleQuotes(sqlbody)#
		 WHERE   #preserveSingleQuotes(Condition)#	
		         #preserveSingleQuotes(FlyAccess)#	
		   AND   I.InvoiceId NOT IN (SELECT ReferenceId 
		                             FROM   Accounting.dbo.TransactionHeader 
									 WHERE  ReferenceId = I.InvoiceId)		 	
		   AND   I.ActionStatus = '1'
		ORDER BY DocumentDate
		
		</cfquery>
		
	</cfcase>
	
	<cfcase value="SHP">	
		
	    <!--- ---------------------------------------------- --->
		<!--- mode to show invoices for warehouse inssuances --->
		<!--- ---------------------------------------------- --->
		
		<cfset condition = "I.ActionStatus != '9' AND I.Mission = '#URL.Mission#'">				
		<cfset text = "Invoices for stock issuances">
				
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">
		
		 SELECT  #preserveSingleQuotes(sqlselect)#		
		 INTO    userquery.dbo.lsInvoice_#SESSION.acc#			 
		 FROM    #preserveSingleQuotes(sqlbody)#
		 WHERE   #preserveSingleQuotes(Condition)#	
		         #preserveSingleQuotes(FlyAccess)#	
				 
				 
		   AND   I.InvoiceNo IN (SELECT InvoiceNo 
		                         FROM   InvoiceIncoming
								 WHERE  Mission = I.Mission
                                 AND    OrgUnitOwner  = I.OrgUnitOwner
								 AND	OrgUnitVendor = I.OrgUnitVendor
								 AND    InvoiceNo  = I.InvoiceNo
  								 AND    InvoiceClass = '#url.invoiceclass#' 								
								 AND    OrgUnitOwner IN (
								                         SELECT OrgUnit 
								                         FROM   Organization.dbo.Organization 
														 WHERE  MissionOrgUnitId = '#url.MissionOrgUnitId#') 
														 
								 )		 	  
		 ORDER BY DocumentDate
		
		</cfquery>	
	
	</cfcase>
		
	<cfcase value="Tagging">
	
		<cfset condition = "I.ActionStatus != '9' AND I.Mission = '#URL.Mission#'">
				
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#InvoiceTotal">	
		
		<!--- Hanno : how does this work with the currency --->
		
		<cfquery name="TotalAmount" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT    O.ObjectKeyValue4 AS InvoiceId, SUM(OA.Amount) AS Amount		
		INTO      userQuery.dbo.#SESSION.acc#InvoiceTotal
		FROM      FinancialObjectAmount OA INNER JOIN
                  FinancialObject O ON OA.ObjectId = O.ObjectId 
				  <!---
				  INNER JOIN
                  FinancialObjectAmountCategory OAC ON OA.ObjectId = OAC.ObjectId AND OA.SerialNo = OAC.SerialNo
				  --->
		WHERE     O.EntityCode = 'INV'
		AND       O.Mission = '#URL.Mission#'
		GROUP BY  O.ObjectKeyValue4 
		
		</cfquery>
			
		<!--- Pending portion of Invoice tagging --->
				
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">
		
			SELECT    #preserveSingleQuotes(sqlselect)#					 
			 INTO     userquery.dbo.lsInvoice_#SESSION.acc#
			 FROM     #preserveSingleQuotes(sqlbody)#
			 WHERE    #preserveSingleQuotes(Condition)#	
			          #preserveSingleQuotes(FlyAccess)#	
			   AND   
			         (
			   
			          I.InvoiceId NOT IN  (
			   
										    SELECT     OA.ObjectKeyValue4			
											FROM       Accounting.dbo.FinancialObjectAmountCategory OAC INNER JOIN
											           Accounting.dbo.FinancialObject OA ON OAC.ObjectId = OA.ObjectId INNER JOIN
											           Accounting.dbo.Ref_Category RC ON OAC.Category = RC.Code
											WHERE      OA.EntityCode = 'INV'
											AND        OA.Mission = '#URL.Mission#'
											GROUP BY   OA.ObjectKeyValue4
											HAVING     COUNT(DISTINCT RC.CategoryClass) = (										
											
																						SELECT COUNT(DISTINCT CategoryClass)
																						FROM   Accounting.dbo.Ref_Category
																						WHERE  (Mission IS NULL OR Mission = '#URL.Mission#') 
																						AND    EntityCode = 'INV'																																		
																			
																			           )		
																					
											UNION 
																					
											SELECT     OA.ObjectKeyValue4			
											FROM       Accounting.dbo.FinancialObjectAmountProgram OAC INNER JOIN
											           Accounting.dbo.FinancialObject OA ON OAC.ObjectId = OA.ObjectId 
											WHERE      OA.EntityCode = 'INV'
											AND        OA.Mission = '#URL.Mission#'
											GROUP BY   OA.ObjectKeyValue4										
			                             
										 )												
			                             
					   )				
					  
			    UNION
			 
			SELECT   #preserveSingleQuotes(sqlselect)#					 
			FROM     #preserveSingleQuotes(sqlbody)#
			         INNER JOIN
			         userQuery.dbo.#SESSION.acc#InvoiceTotal IPT ON I.InvoiceId = IPT.InvoiceId
			 WHERE   #preserveSingleQuotes(Condition)#			 
			   AND   ABS(I.DocumentAmount - IPT.Amount) > 0.01		   		
			   
			ORDER BY I.DocumentDate
				
		</cfquery>		
									
		<cfset text = "Pending Tagging">
		
	</cfcase>
	
	<cfcase value="Reconcile">
	
		<cf_message message="Pending development by Hanno" return="false">		
		
		<!--- ------------------------------------------------------------------------------ --->
		<!--- IMIS transaction which have cls/obj that needs to be match but are not or partially 
		  reconciled yet. --->		
		<!--- ------------------------------------------------------------------------------ --->  
		
		SELECT     *
		FROM       stLedgerIMIS IMIS
		WHERE     (NOVADestination = 'Match') AND (NOVAMatchingStatus <> 'Complete')
		ORDER BY FiscalYear
		
		<cfabort>				
	
	</cfcase>
	
	<cfcase value="Purchase">
		

		<cfset condition = " EXISTS (SELECT 'X' FROM InvoicePurchase IP INNER JOIN Purchase P 
				ON  P.PurchaseNo = IP.PurchaseNo
				WHERE P.OrderType = '#URL.ID#' 
				AND IP.InvoiceId = I.InvoiceId ) 
				AND I.ActionStatus != '9' 
				AND I.Period = '#URL.Period#' 
				AND I.Mission = '#URL.Mission#'">
	
		<cfset text = "Order type">
		
		<cf_ListingScript>
		
		<cfquery name= "SearchResult" 
		datasource   = "AppsPurchase" 
		username     = "#SESSION.login#" 
		password     = "#SESSION.dbpw#">
			SELECT   #preserveSingleQuotes(sqlselect)#		
			INTO     userquery.dbo.lsInvoice_#SESSION.acc#			 
		    FROM     #preserveSingleQuotes(sqlbody)#
			WHERE    #preserveSingleQuotes(Condition)#	
			#preserveSingleQuotes(FlyAccess)#		
			<cfif url.filter eq "me">		 
			AND      I.OfficerUserId = '#SESSION.acc#'
			</cfif>					 
			ORDER BY DocumentDate
		</cfquery>	
	
	</cfcase>		
	
	
	<cfcase value="Locate">
					
		  <cfset condition = "">
		  
		  <cfparam name="Form.Period"        default="">
		  <cfparam name="Form.ActionStatus"  default="">
		  <cfparam name="Form.Description"   default="">
		  <cfparam name="Form.Amount"        default="">
		  <cfparam name="Form.Officer"       default="">
		  <cfparam name="Form.Currency"      default="">
		  <cfparam name="Form.OrgUnitVendor" default="">
		  <cfparam name="Form.InvoiceNo"     default="">
		  <cfparam name="Form.PurchaseNo"    default="">
		  <cfparam name="Form.DateStart"     default="">
	      <cfparam name="Form.DateEnd"       default="">
			
		  <cfif Form.Period eq "">
			  <cfset condition = "AND I.Mission = '#URL.Mission#'">
		  <cfelse> 
			  <cfset condition = "AND I.Period = '#Form.Period#' and I.Mission = '#URL.Mission#'">
		  </cfif>
		  
		  <cfset text = "Inquiry">
		  
		  <cfif Form.ActionStatus neq "">
		       <cfset condition   = "#condition# AND I.ActionStatus IN (#Form.ActionStatus#)">	   
		  </cfif>  
		    
		  <cfif Form.Description neq "">
		       <cfset condition   = "#condition# AND (I.Description LIKE '%#Form.Description#%' OR P.PurchaseNo IN (SELECT P.PurchaseNo FROM PurchaseLine P WHERE OrderItem LIKE '%#Form.Description#%'))">								
		   </cfif>	   
		     
		  <cfif isNumeric(Form.Amount)>
		       <cfset condition   = "#condition# AND I.DocumentAmount #form.amountoperator# '#Form.amount#'">
		   </cfif>
		     
		  <cfif Form.Officer neq "">
		       <cfset condition   = "#condition# AND I.OfficerUserId = '#Form.Officer#'">
		   </cfif>
		  
		  <cfif Form.Currency neq "">
		       <cfset condition   = "#condition# AND I.DocumentCurrency = '#Form.Currency#'">
		   </cfif>
		  
		  <cfif Form.OrgUnitVendor neq "">
		       <cfset condition   = "#condition# AND I.OrgUnitVendor = '#Form.OrgUnitVendor#'">
		  </cfif>
			
		  <cfif Form.InvoiceNo neq "">
		        <cfset condition  = "#condition# AND I.InvoiceNo LIKE '%#Form.InvoiceNo#%'">
		  </cfif>	
		  
		  <cfsavecontent variable="purchase">
		   
		    		SELECT  InvoiceId
					FROM     Purchase AS Px INNER JOIN
				             InvoicePurchase AS IPx ON Px.PurchaseNo = IPx.PurchaseNo 
					WHERE    IPx.InvoiceId = I.InvoiceId	
					AND       
					
		  </cfsavecontent>	
		  
		  <cfif Form.PurchaseNo neq "">		   
		   
		   	   <cfif Param.PurchaseCustomField eq "">
			    <cfset condition  = "#condition# AND I.InvoiceId IN (#purchase# IPx.PurchaseNo LIKE '%#Form.Purchaseno#%')">											  
			   <cfelse>
		        <cfset condition  = "#condition# AND I.InvoiceId IN (#purchase# (Px.PurchaseNo LIKE '%#Form.Purchaseno#%' OR Px.Userdefined4#Param.PurchaseCustomField# LIKE '%#Form.Purchaseno#%'))">								
			   </cfif>
			   
		  </cfif>	
		  
		  <cfif Form.RequisitionNo neq "">
		   		   
		        <cfset condition  = "#condition# AND I.InvoiceId IN (#purchase# (Px.PurchaseNo IN (SELECT Pl.PurchaseNo FROM RequisitionLine L INNER JOIN PurchaseLine Pl ON L.RequisitionNo = Pl.RequisitionNo WHERE (L.RequisitionNo LIKE '%#Form.RequisitionNo#%') OR (L.Reference LIKE '%#Form.RequisitionNo#%'))))">								
						   
		  </cfif>	
		  
		  <cfif Form.DateStart neq "">
			     <cfset dateValue = "">
				 <CF_DateConvert Value="#Form.DateStart#">
				 <cfset dte = dateValue>
				 <cfset condition = "#condition# AND I.DocumentDate >= #dte#">
		  </cfif>	
		  
		  <cfif Form.DateEnd neq "">
				 <cfset dateValue = "">
				 <CF_DateConvert Value="#Form.DateEnd#">
				 <cfset dte = dateValue>
				 <cfset condition = "#condition# AND I.DocumentDate <= #dte#">
		  </cfif>	
	
		 <cfquery name= "SearchResult" 
		 datasource   = "AppsPurchase" 
		 username     = "#SESSION.login#" 
		 password     = "#SESSION.dbpw#">
			SELECT   #preserveSingleQuotes(sqlselect)#					 
			INTO     userquery.dbo.lsInvoice_#SESSION.acc#
		    FROM     #preserveSingleQuotes(sqlbody)#
			WHERE    1=1 #preserveSingleQuotes(Condition)#		
			         #preserveSingleQuotes(FlyAccess)#	 		
			<cfif url.filter eq "me">		 
			AND      I.OfficerUserId = '#SESSION.acc#'
			</cfif>
			ORDER BY DocumentDate					
		</cfquery>
				
		<cfset text = "Search Result">
	
	</cfcase>
		
</cfswitch>

</cfoutput>

<!--- create index --->

<cfquery name="AddIndex"  datasource="AppsQuery">	

CREATE CLUSTERED INDEX [InvoiceId] 
		   ON dbo.lsInvoice_#SESSION.acc#([InvoiceId]) ON [PRIMARY]
	
</cfquery>

<cfinclude template="InvoiceViewListingContent.cfm">

<script>
	parent.Prosis.busy('no')
</script>
