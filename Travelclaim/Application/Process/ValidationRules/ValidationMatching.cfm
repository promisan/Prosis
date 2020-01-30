
<!--- step 1 ; focus on easy cases, this is 95% already --->
<!--- step 2 ; match non-obligated lines based on rule 41/61 --->
<!--- step 3 : additional obvious matching rules in document --->
<!--- step 4 : non-obligated lines (combination index/category does not exist --->
<!--- step 5 : manual matching in the interface --->

<!--- START Processing step 1 --->

<!--- auto matching phase 1 this covers 95% of the cases:
      define number of lines per claim category/personNo with one line per person --->
	  
<cftransaction>

<cfquery name="Claim" 
  datasource="appsTravelClaim"
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT *
	FROM   Claim
	WHERE  ClaimId = '#URL.ClaimId#'
</cfquery>
	  
<cfparam name="URL.Express" default="0">

<!--- step 1 claim obligation lines --->

<cfif URL.Express eq "0">

	<!--- determine the lines (Count(*)) obligated per claim category & person (!!!!)
	if there is just one line there is no question that it should be linked --->
	  
	<cfquery name="Obligation" 
	  datasource="appsTravelClaim" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT   C.ClaimId, 
		         R.ClaimRequestId, 
				 MIN(R.ClaimRequestLineNo) as ClaimRequestLineNo, 
				 R.ClaimCategory, 
				 R.PersonNo, 
				 COUNT(*) AS Lines
		FROM     Claim C INNER JOIN
	             ClaimRequestLine R ON C.ClaimRequestId = R.ClaimRequestId
		WHERE    ClaimId = '#URL.ClaimId#' 		 
		GROUP BY R.ClaimRequestId, 
		         C.ClaimId, 
				 R.ClaimCategory,  
				 R.PersonNo 		
	</cfquery>
	
<cfelse>

	<!--- express claims will always matched no manual intervention ERGO: lines are artifically
	 set as 1 --->

	<cfquery name="Obligation" 
	  datasource="appsTravelClaim" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT     C.ClaimId, 
	             R.ClaimRequestId, 
				 R.ClaimRequestLineNo, 
				 R.ClaimCategory, 
				 R.PersonNo, 
				 DSA.DateExpiration as DSAEnd,
				 DSA.ServiceLocation,
				 1 as Lines
	  FROM       Claim C INNER JOIN
	             ClaimRequestLine R ON C.ClaimRequestId = R.ClaimRequestId LEFT OUTER JOIN
	             ClaimRequestDSA DSA ON R.ClaimRequestId = DSA.ClaimRequestId AND R.ClaimRequestLineNo = DSA.ClaimRequestLineNo
	  WHERE      ClaimId = '#URL.ClaimId#' 		
	 </cfquery>
	 			 
</cfif>	

<!--- entry cost lines n : m --->

<!--- Resrt is an safeguard : 
update prior mapping if cost entries wwere changed in amount from interface so need to be redone --->


<cfquery name="Reset" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   C.ClaimEventId, 
	         C.IndicatorCode, 
			 C.CostLineNo, 
			 C.InvoiceAmount, 
			 SUM(CL.MatchingInvoiceAmount) AS Total
    FROM     ClaimEventIndicatorCostLine CL INNER JOIN
             ClaimEventIndicatorCost C ON CL.ClaimEventId = C.ClaimEventId 
			                         AND CL.IndicatorCode = C.IndicatorCode 
									 AND CL.CostLineNo = C.CostLineNo
	WHERE  C.ClaimEventId IN (SELECT ClaimEventId 
	                       FROM ClaimEvent 
						   WHERE ClaimId = '#URL.ClaimId#')							 
    GROUP BY C.ClaimEventId, C.IndicatorCode, C.CostLineNo, C.InvoiceAmount
    HAVING   C.InvoiceAmount <> SUM(CL.MatchingInvoiceAmount)				   
 </cfquery>	
 
 <cfloop query="reset">
 
 	<cfquery name="Reset" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	   UPDATE   ClaimEventIndicatorCostLine
		SET      matchingAction = 0	
		WHERE ClaimEventid  = '#ClaimEventid#'
		AND   IndicatorCode = '#IndicatorCode#'
		AND   CostLineNo    = '#CostLineNo#' 
	</cfquery>
		
 </cfloop>
 
<!--- clear prior mapping entries that were NOT touched or changed already --->

<cfquery name="Clear" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM  ClaimEventIndicatorCostLine 
	WHERE  ClaimEventId IN (SELECT ClaimEventId 
	                       FROM ClaimEvent 
						   WHERE ClaimId = '#URL.ClaimId#')
	AND    MatchingAction = '0'					   
</cfquery>	

<!--- automatching if the is just one line --->

<cfloop query="Obligation">
	
	<cfif ClaimCategory eq "DSA">
		
		<!--- update claim line DSA --->
		<cfquery name="DSA" 
		  datasource="appsTravelClaim" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			UPDATE   ClaimLineDSA
			SET      ClaimRequestId      = '#ClaimRequestId#', 
					 ClaimRequestLineNo  = '#ClaimRequestLineNo#',
					 <cfif lines eq "1">
					 ClaimAutomatching   = '1'
					 <cfelse>
					 ClaimAutomatching   = '0'
					 </cfif>
			WHERE    ClaimId = '#URL.ClaimId#' 
			AND      PersonNo = '#PersonNo#' 	
			AND      MatchingAction = 0
			<cfif URL.Express eq "1">
			AND      LocationCode = '#ServiceLocation#'
			AND      CalendarDate <= '#DateFormat(DSAEnd,CLIENT.DateSQL)#'  
			</cfif>
		</cfquery>							
				
	<cfelse>
	
		<!--- update amounts line TRM, SFT, MSC, LTR  --->
				
		<cfquery name="Costs" 
		  datasource="appsTravelClaim" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT   *
			FROM     ClaimEventIndicatorCost
			WHERE    ClaimEventId IN (SELECT ClaimEventId 
			                          FROM   ClaimEvent 
									  WHERE  ClaimId = '#URL.ClaimId#') 
			AND      PersonNo = '#PersonNo#'	
			AND      IndicatorCode IN (SELECT Code 
			                           FROM Ref_Indicator 
									   WHERE ClaimCategory = '#ClaimCategory#') 
			AND    CostLineNo NOT IN (SELECT CostLineNo 
			                          FROM ClaimEventIndicatorCostLine						   			     						   
									  WHERE  ClaimEventId IN (SELECT ClaimEventId 
									                          FROM   ClaimEvent 
															  WHERE  ClaimId = '#URL.ClaimId#')
										AND   IndicatorCode IN (SELECT Code 
								                           FROM Ref_Indicator 
														   WHERE ClaimCategory = '#ClaimCategory#')		
										AND MatchingAction = 1				   			   									
									 )					   
		</cfquery>
							   
		
		<cfset reqid = claimRequestid>
		<cfset reqno = claimRequestLineNo>
		<cfset l = lines>
		
		<!--- loop through the costs for a specific claim category --->
		
		<cfif l gt "1">
		
			<!--- prepare comparison array --->
		
			<cfquery name="OblLines" 
			  datasource="appsTravelClaim" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT *
			  FROM   ClaimRequestLine
			  WHERE  ClaimRequestId = '#reqid#' 
			  AND    ClaimCategory  = '#ClaimCategory#'		
			  ORDER BY ClaimRequestLineNo	
			</cfquery>	
			
			<!--- read into an array --->
			
			<cfset obl = StructNew()>
			<cfset oln = OblLines.recordcount>
			
			<cfloop query="OblLines">
				<cfif currentrow neq recordcount>
					<cfset bal = StructInsert(obl, "#claimrequestlineno#","#requestamount#")>	 
				<cfelse>
					<!--- ensure you always map to the last line here in case over overclaiming --->
					<cfset bal = StructInsert(obl, "#claimrequestlineno#","1000000")>
				</cfif>	
			</cfloop>
				
		</cfif>
				
		<cfloop query="Costs">		
						 
				 <cfif l eq "1">	
				 
				 	<!--- this is the default 98+% --->			
				
					<cfquery name="Insert" 
					  datasource="appsTravelClaim" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						INSERT INTO ClaimEventIndicatorCostLine
						 (ClaimEventId, 
						  IndicatorCode, 
						  CostLineNo, 
						  MatchingNo, 
						  MatchingInvoiceAmount, 
						  ClaimAutoMatching, 
						  ClaimRequestId, 
						  ClaimRequestLine)
						VALUES
						('#ClaimEventid#',
						 '#IndicatorCode#',
						 '#CostLineNo#',
						 '1',
						 '#InvoiceAmount#', 
						 '1',									
						 '#reqid#',
						 '#reqno#')			
				    </cfquery>	
				
				<cfelse>
						
						<cfset cnt = 0>						   
						<cfset inv = InvoiceAmount> <!--- local claim line currency --->
						<cfset amt = AmountBase>  <!--- = USD dollars equivalent of the line --->
												
						<cfquery name="Exchange" 
						  datasource="appsTravelClaim"
						  username="#SESSION.login#" 
					      password="#SESSION.dbpw#">
						  SELECT   TOP 1 *
						  FROM     Accounting.dbo.CurrencyExchange
						  WHERE    Currency         = '#InvoiceCurrency#' 
						    AND    EffectiveDate   <= getDate()
						  ORDER BY EffectiveDate DESC
						 </cfquery>
										 
						 <cfif Exchange.recordcount eq "0">
						     <cfset exc = 1>
						 <cfelse>
						     <cfset exc = Exchange.ExchangeRate>
						 </cfif>						
												
						 <cfloop condition="#amt# gt 0">
						 						       							
								<cfset cnt = cnt+1>
								
								<cfset bal = 0>
																														
								<cfloop collection = "#obl#" item = "line">
																	
									<cfif bal eq "0">
										<cfset lne = line>
										<cfset bal = StructFind(obl, line)>											
										 <br>								    			
									</cfif>						
											
								</cfloop>
																								
								<cfif amt lte bal>
										
										<!--- determine amount if the payment currency is not USD --->													
										<cfset map    = amt>
										<!--- take full amounts 7.456 => 8 --->							
										<cfset map = ceiling(map)>
										<!--- update the obligation amount with the new balance --->																																	
										<cfset amt = amt-map>
										<cfset balnew = bal-map>																									
										<cfset upd = StructUpdate(obl, "#lne#", "#balnew#")>
										<cfset inv = (map*exc)>
																			
								<cfelse>						
										
										<cfset map = bal>									
										<cfset map = ceiling(map)>										
										<cfset upd = StructUpdate(obl, "#lne#", "0")>	
										
										<cfset inv = map*exc>
										<cfif inv lt 1>
											<cfset inv = inv>
											<cfset amt = 0>
										<cfelse>
										   	<cfset amt = amt-map>
										</cfif>		
																	
								</cfif>
								
								<cfquery name="Insert" 
								  datasource="appsTravelClaim" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
									INSERT INTO ClaimEventIndicatorCostLine
										 (ClaimEventId, 
										  IndicatorCode, 
										  CostLineNo, 
										  MatchingNo, 
										  MatchingInvoiceAmount, 
										  ClaimAutoMatching, 
										  ClaimRequestId, 
										  ClaimRequestLine)
									VALUES
										('#ClaimEventid#',
										 '#IndicatorCode#',
										 '#CostLineNo#',
										 '#cnt#',
										 '#inv#', 
										 '0',				
										 '#reqid#',
										 '#lne#')			
							    </cfquery>
								
									
					 	</cfloop>
				
				
				</cfif>								
					
		</cfloop>
						
	</cfif>

</cfloop>	


<!--- START Processing step 2 --->

<!--- Non-obligated lines
      - determine non-obligated lines (no claim cat found page 6.2.2)
      - associate highest line not ITN, SFT or NOC was dropped --->
	  
	<cfquery name="Check" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	  
		SELECT    TOP 1 *
		FROM      ClaimRequestLine
		WHERE     ClaimRequestId = '#Claim.ClaimRequestId#' 
		<!--- reenabled --->
		AND       ClaimCategory NOT IN ('SFT', 'ITN', 'NOC')		
		ORDER BY   RequestAmount DESC	
	</cfquery>		
	
	<cfif check.recordcount eq "0">
	
		<cfquery name="Check" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	  
			SELECT    TOP 1 *
			FROM      ClaimRequestLine
			WHERE     ClaimRequestId = '#Claim.ClaimRequestId#' 
			ORDER BY   RequestAmount DESC	
		</cfquery>		
		
	</cfif>	    
		
	<cfquery name="NonMatchedCost" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   C.ClaimEventId, 
			         C.IndicatorCode, 
					 C.CostLineNo, 
					 C.InvoiceAmount, 
					 CL.ClaimEventId AS Exist
			FROM     ClaimEventIndicatorCost C LEFT OUTER JOIN
            	     ClaimEventIndicatorCostLine CL ON C.ClaimEventId = CL.ClaimEventId AND C.IndicatorCode = CL.IndicatorCode AND 
                     C.CostLineNo = CL.CostLineNo
			WHERE     C.ClaimEventId IN
                          (SELECT     ClaimEventid
                            FROM      ClaimEvent
                            WHERE     ClaimId = '#URL.ClaimId#')
			GROUP BY C.ClaimEventId, C.IndicatorCode, C.CostLineNo, C.InvoiceAmount, CL.ClaimEventId
			HAVING      (CL.ClaimEventId IS NULL) 
	</cfquery>		
	
	<cfloop query="NonMatchedCost">
	
			<cfquery name="Insert" 
				  datasource="appsTravelClaim" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					INSERT INTO ClaimEventIndicatorCostLine
					 (ClaimEventId, 
					  IndicatorCode, 
					  CostLineNo, 
					  MatchingNo, 
					  MatchingInvoiceAmount, 
					  ClaimObligated,
					  ClaimAutoMatching, 
					  ClaimRequestId, 
					  ClaimRequestLine)
					VALUES
					('#ClaimEventid#',
					 '#IndicatorCode#',
					 '#CostLineNo#',
					 '1',
					 '#InvoiceAmount#',
					 '0',
					 '1',
					 '#Check.ClaimRequestId#',
					 '#Check.ClaimRequestLineNo#')			
			    </cfquery>			
	
	
	</cfloop>
		
<!--- START Processing step 3 --->

<!--- process only those lines that are NOT matched yet and 
associate to the LOWEST number and enforce association --->

<cfquery name="Step3" 
  datasource="appsTravelClaim" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   DISTINCT 
	         C.ClaimId, 
	         R.ClaimRequestId, 
			 MIN(R.ClaimRequestLineNo) as ClaimRequestLineNo, 
			 R.ClaimCategory, 
			 R.PersonNo
	FROM     Claim C INNER JOIN
             ClaimRequestLine R ON C.ClaimRequestId = R.ClaimRequestId
	WHERE    ClaimId = '#URL.ClaimId#' 		 
	GROUP BY R.ClaimRequestId, C.ClaimId, R.ClaimCategory, R.PersonNo 
</cfquery>

<!--- not relevant for express claim --->

<cfif URL.Express eq "0">
	
	<cfloop query="Step3">
		
		<cfif ClaimCategory eq "DSA">
		
			  <cfset PersonNo = "#PersonNo#">
			  
			  <cfquery name="Check" 
			  datasource="appsTravelClaim" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT   count(DISTINCT ClaimRequestLineNo)
				FROM     ClaimRequestDSA
				WHERE    ClaimRequestId   = '#ClaimRequestId#' 				
			  </cfquery>
			  
			  <!--- disabled hanno 15/11
			  <cfif check.recordcount gte "2">
			  --->
				
				  <cfquery name="Step3a" 
				  datasource="appsTravelClaim" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT   *
					FROM     ClaimRequestDSA
					WHERE    ClaimRequestId   = '#ClaimRequestId#' 
					ORDER BY DateEffective  
				  </cfquery>
				  
				  <cfloop query="Step3a">
							
						<!--- update claim line DSA --->
						<cfquery name="DSA" 
						  datasource="appsTravelClaim" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							UPDATE   ClaimLineDSA
							SET      ClaimRequestId     = '#ClaimRequestId#', 
									 ClaimRequestLineNo = '#ClaimRequestLineNo#',
									 ClaimAutoMatching  = '0' 
							WHERE    ClaimId = '#URL.ClaimId#'
							AND      ClaimAutoMatching != '1'
							<!--- disable to allow for errors here
							AND      PersonNo = '#PersonNo#'		     
							--->
							<cfif currentRow eq "1">
							AND    	 1=1 		
							<cfelse>
							AND      CalendarDate >= '#DateFormat(DateEffective,client.DateSQL)#' 
							</cfif>
							AND    MatchingAction = 0
							
						</cfquery>
					
				   </cfloop>	
			  <!---	   
			  </cfif>	   
			  --->
			
		<cfelse>
		
			<!--- update amounts line TRM, MSC, LTR  --->
			
			<!--- depreciated Hanno
			
			<cfquery name="Match" 
			  datasource="appsTravelClaim" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				UPDATE   ClaimEventIndicatorCost
				SET      ClaimRequestId     = '#ClaimRequestId#', 
						 ClaimRequestLineNo = '#ClaimRequestLineNo#',
						 ClaimAutoMatching  = '0'
				WHERE    ClaimEventId IN (SELECT ClaimEventId 
				                          FROM ClaimEvent 
										  WHERE ClaimId = '#URL.ClaimId#') 
				AND    	 ClaimRequestId is NULL					  
				AND      PersonNo = '#PersonNo#'	
				AND      IndicatorCode IN (SELECT Code 
				                           FROM Ref_Indicator 
										   WHERE ClaimCategory = '#ClaimCategory#') 
			</cfquery>
			
			--->
			
		</cfif>
	
	</cfloop>	

</cfif>

</cftransaction>


