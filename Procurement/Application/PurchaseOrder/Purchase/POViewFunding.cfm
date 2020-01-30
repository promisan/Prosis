<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfquery name="Parameter" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Ref_ParameterMission
	  WHERE  Mission IN (SELECT Mission FROM Purchase WHERE PurchaseNo = '#url.id1#')	 
	</cfquery>

<cfquery name="Param" 
	  datasource="AppsSystem" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Parameter	 
	</cfquery>

<cfquery name="Check" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   PurchaseFunding
	  WHERE  PurchaseNo = '#URL.ID1#'
	</cfquery>

<cfif URL.Mode neq "Edit" or check.recordcount eq "0">

	<!--- recalculate funding --->
	<cftransaction>
	
	<cfquery name="Delete" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  DELETE FROM PurchaseFunding
	  WHERE PurchaseNo = '#URL.ID1#' 
	</cfquery>
		
	<!--- changed to support activities 19/7/2015 --->
	
	<cfquery name="getFunded" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  
	  SELECT   F.*, POLine.OrderAmountBase
	  FROM     PurchaseLine POLine 	           
	           INNER JOIN RequisitionLineFunding F ON POLine.RequisitionNo = F.RequisitionNo 			  
	  WHERE    POLine.PurchaseNo = '#URL.ID1#' 
	  AND      POLine.actionStatus != '9'	  
			   
	</cfquery>
	
	<cfloop query="getFunded">
	
		<!--- check if there are details --->
		
		<cfset per = ProgramPeriod>
		<cfset prg = ProgramCode>
		<cfset fun = Fund>
		<cfset obj = ObjectCode>
		<cfset prc = Percentage>
		
		<cfquery name="check" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	  
			  SELECT   sum(Percentage) as Percentage
			  FROM     RequisitionLineFundingActivity  			  
			  WHERE    RequisitionNo = '#RequisitionNo#' 
			  AND      FundingId     = '#FundingId#'	 		   			   
		 </cfquery>
		 
		 <cfif check.Percentage eq "1">
		 
		 	<!--- has activities in the funding --->
		 
			 <cfquery name="getActivity" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	  
				  SELECT   *
				  FROM     RequisitionLineFundingActivity  			  
				  WHERE    RequisitionNo = '#RequisitionNo#' 
				  AND      FundingId     = '#FundingId#'	 		   			   
			 </cfquery>
			 
			 <cfloop query="getActivity">
			 
			    <cfset amt = getFunded.OrderAmountBase * prc * percentage>
				
				 <cfquery name="check" 
				   datasource="AppsPurchase" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT * FROM PurchaseFunding
				   WHERE PurchaseNo  = '#url.id1#'
				   AND   Period      = '#per#'
				   AND   Fund        = '#fun#'
				   AND   ProgramCode = '#prg#'
				   AND   ActivityId  = '#activityid#'
				   AND   ObjectCode  = '#obj#'
				  </cfquery>
				  
				  <cfif check.recordcount eq "1">
				  
					  <cfquery name="check" 
					   datasource="AppsPurchase" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   UPDATE PurchaseFunding
						   SET Amount = Amount + #amt#
						   WHERE PurchaseNo  = '#url.id1#'
						   AND   Period      = '#per#'
						   AND   Fund        = '#fun#'
						   AND   ProgramCode = '#prg#'
						   AND   ActivityId  = '#activityid#'
						   AND   ObjectCode  = '#obj#'
					  </cfquery>
				  				 
				  <cfelse>
				 			 
					 <cfquery name="Insert" 
					   datasource="AppsPurchase" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   INSERT INTO PurchaseFunding
			             (PurchaseNo,Period,Fund,ProgramCode,ActivityId,ObjectCode,Amount)
					   VALUES
					     ('#URL.ID1#','#per#','#fun#','#prg#','#activityid#','#obj#','#amt#')
				     </cfquery>
				 
				 </cfif>
			 
			 </cfloop>
			 
		 <cfelse>
		 
			  <cfset amt = getFunded.OrderAmountBase * prc>
			  
			  <cfquery name="check" 
				   datasource="AppsPurchase" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   SELECT * 
				   FROM   PurchaseFunding
				   WHERE  PurchaseNo  = '#url.id1#'
				   AND    Period      = '#per#'
				   AND    Fund        = '#fun#'
				   AND    ProgramCode = '#prg#'
				   AND    ActivityId  is NULL
				   AND    ObjectCode  = '#obj#'
				  </cfquery>
				  
				<cfif check.recordcount eq "1">
				  
					  <cfquery name="check" 
					   datasource="AppsPurchase" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   UPDATE PurchaseFunding
						   SET    Amount = Amount + '#amt#'
						   WHERE  PurchaseNo  = '#url.id1#'
						   AND    Period      = '#per#'
						   AND    Fund        = '#fun#'
						   AND    ProgramCode = '#prg#'
						   AND    ActivityId  is NULL
						   AND    ObjectCode  = '#obj#'
					  </cfquery>
				  				 
				<cfelse>
				 			 
					 <cfquery name="Insert" 
					   datasource="AppsPurchase" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   INSERT INTO PurchaseFunding
			             (PurchaseNo,Period,Fund,ProgramCode,ObjectCode,Amount)
					   VALUES
					     ('#URL.ID1#','#per#','#fun#','#prg#','#obj#','#amt#')
				     </cfquery>
				 
				</cfif>
			 		 
		 </cfif>	
	
	</cfloop>		  		  
		
	</cftransaction>

</cfif>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table formpadding">
       
    <TR class="labelit line" height="19">
	  
	   <td width="30"></td>
	   <td><cf_tl id="Fund"></td>
       <td><cf_tl id="Period"></td>
	   <td colspan="2"><cf_tl id="Program">/<cf_tl id="Activity"></td>
	   <td width="200"><cf_tl id="Object"></td>	  	   
	   <td align="right" style="padding-right:8px"><cf_tl id="Amount">#Param.BaseCurrency#</td>	  
	 
	 </TR> 
			 
	 	<cfif Parameter.EnforceProgramBudget eq "1">
			
			<cfquery name="Lines" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  F.PurchaseNo, PF.ProgramCode, PF.ProgramName, F.ActivityId, F.Fund, F.Period, F.ObjectCode, O.Description, F.Amount
				FROM    PurchaseFunding F INNER JOIN 
		                Program.dbo.Program PF ON F.ProgramCode = PF.ProgramCode INNER JOIN
	    	            Program.dbo.Ref_Object O ON F.ObjectCode = O.Code
				WHERE   F.PurchaseNO = '#URL.ID1#' 
			</cfquery> 
			
			<cfif Lines.recordcount eq "0">
			
				<cfquery name="Lines" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  F.PurchaseNo, '' as Reference, '' as ProgramCode, 'Default' as ProgramName, '' as ActivityId, F.Period, F.Fund, F.ObjectCode, O.Description, F.Amount
				FROM    PurchaseFunding F INNER JOIN 
		                Program.dbo.Ref_Object O ON F.ObjectCode = O.Code
				WHERE   F.PurchaseNO = '#URL.ID1#' 
				</cfquery> 
						
			</cfif>
		
		<cfelse>
		
			<cfquery name="Lines" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  F.PurchaseNo, '' as Reference, ProgramCode, 'Default' as ProgramName, '' as ActivityId, F.Period,F.Fund, F.ObjectCode, O.Description, F.Amount
			FROM    PurchaseFunding F INNER JOIN 
	                Program.dbo.Ref_Object O ON F.ObjectCode = O.Code
			WHERE   F.PurchaseNO = '#URL.ID1#' 
			</cfquery> 
		
		</cfif> 
						
		<cfif Lines.recordcount eq "0">

			 <tr><td height="30" colspan="8" align="center" class="labelmedium"><font color="FF0000"><i>Problem, Purchase Order has not been funded.  Please contact your administrator</td></tr>  
 
		<cfelse>		
		
		<cfloop query="Lines">
		
			 <cfquery name="Period" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT * 
					FROM  ProgramPeriod
					WHERE ProgramCode = '#ProgramCode#'
					AND   Period = (SELECT PlanningPeriod 
					                FROM   Organization.dbo.Ref_MissionPeriod 
									WHERE  Mission = '#PO.Mission#' 
									AND    Period = '#Period#')					
		   </cfquery>
		   
		   <cfif ActivityId neq "">
		   
			   <cfquery name="Activity" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
						FROM  ProgramActivity
						WHERE ActivityId = '#ActivityId#'							
			   </cfquery>
			   
			   <cfset act = Activity.ActivityDescriptionShort>
			   
		   <cfelse>
		   
		   		<cfset act = "">
					   
		   </cfif>
								
			<tr class="navigation_row line">
						
				<td class="labelit" height="19" align="center">#CurrentRow#.</td>
				<td class="labelit">#Fund#</td>
				<td class="labelit">#Period#</td>
				<cfif act eq "">
					<td colspan="2" class="labelit"><cfif Period.recordcount eq "1"><a href="javascript:EditProgram('#ProgramCode#','#PO.Period#','project')"><font color="0080C0">#Period.Reference# #ProgramName#</a><cfelse>n/a</cfif></td>					
				<cfelse>
					<td colspan="2">
					<table>
					  <tr class="labelit" style="height:15px">
					  <td style="height:15px"><cfif Period.recordcount eq "1"><a href="javascript:EditProgram('#ProgramCode#','#PO.Period#','project')"><font color="0080C0">#Period.Reference# #ProgramName#</a><cfelse>n/a</cfif></td>					
					  </tr>				  
					  <tr style="height:15px" class="labelit"><td style="height:15px" colspan="1">#act#</td></tr>				  
				    </table>
					</td>
				
				</cfif>	

				<td class="labelit">#ObjectCode# #Description#</td>
				
				<td align="right" class="labelit" style="padding-right:8px">#NumberFormat(Amount,",__.__")#</td>
											
           	</tr>
									
		</cfloop>		

</cfif>		
		
</table>

</cfoutput>	