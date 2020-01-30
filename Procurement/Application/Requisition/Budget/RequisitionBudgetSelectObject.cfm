<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="URL.Mission"          default="">
<cfparam name="URL.Period"           default="FY 04/05">
<cfparam name="URL.ProgramClass"     default="">
<cfparam name="URL.ProgramHierarchy" default="0">
<cfparam name="URL.Fund"             default="">
<cfparam name="URL.ObjectCode"       default="">
<cfparam name="URL.Edition"          default="">
<cfparam name="URL.Mode"             default="select">

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfset edition = url.edition>

<!--- define expenditure periods --->

<cfquery name="Allotment" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_AllotmentEdition R, 
	          Ref_AllotmentVersion V
	WHERE     EditionId = '#url.edition#'
	AND       R.Version = V.Code
</cfquery>

<cfset persel = "#Allotment.Period#">

<!--- define expenditure periods --->

<cfquery name="Expenditure" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_MissionPeriod
	WHERE     Mission = '#URL.Mission#'
	<cfif Allotment.Period neq "">
	AND       Period  = '#Allotment.Period#'
	</cfif>
</cfquery>
	
<cfquery name="Object" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Object R, Ref_Resource S
	WHERE    S.Code = R.Resource	
	<cfif URL.Object neq "" and Parameter.EnforceObject eq "1">
	AND      R.Code = '#URL.Object#' 
	</cfif>   
	AND      R.Code IN (SELECT Code 
	                    FROM   Ref_Object 
						WHERE  ObjectUsage = '#Allotment.ObjectUsage#'
					   )
	AND      (
	
			R.Code IN
                   (SELECT  ObjectCode
                    FROM    ProgramObject
                    WHERE   ProgramCode IN (SELECT ProgramCode 
		                                    FROM   Program.dbo.Program 
											WHERE  ProgramHierarchy LIKE '#left(ProgramHierarchy,6)#%') 
									        <!--- WHERE  ProgramHierarchy LIKE '#ProgramHierarchy#%') ---> 
				   )
	
		   OR 
	
	        R.Code IN
                   (SELECT D.ObjectCode
				    FROM   Program P,
					       ProgramAllotmentDetail D
			        WHERE  P.ProgramCode = D.ProgramCode
					AND    D.Amount > 0
					AND    P.ProgramCode IN (SELECT ProgramCode 
		                                    FROM   Program.dbo.Program 
											WHERE  ProgramHierarchy LIKE '#left(ProgramHierarchy,6)#%') 
											<!--- CMP is funded on the higher level and the project roll-up
									        WHERE  ProgramHierarchy LIKE '#ProgramHierarchy#%') --->											
					AND    D.Period        = '#URL.Period#'
       			    AND    D.EditionId     = '#Edition#'
			       
				   )	
			
			
						   
			)
				   
	ORDER BY S.ListingOrder, R.ListingOrder
</cfquery>	


<table width       = "100%"
       border      = "0"
       cellspacing = "0"
       cellpadding = "0"
       align       = "right"
       bgcolor     = "F4FBFD">

<cfoutput query="Object" Group="Name">
	
	<tr><td colspan="9">
	<table width="80%"><tr><td class="labelit">
	<b>#Name#</b></td></tr>
	</table>
	</td>
	</tr>

	<cfoutput>
	
	<tr><td colspan="9" class="linedotted"></td></tr>
	
	<cfquery name="check" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * 
			 FROM   RequisitionLineBudget 
			 WHERE  RequisitionNo = '#URL.ID#'
			 AND    Fund          = '#URL.Fund#'
			 AND    ProgramCode   = '#URL.ProgramCode#'
			 AND    ObjectCode    = '#Code#'
	 </cfquery>
	
	<cfif check.recordcount gte "1">
	  <cfset cl = "ffffcf">
	<cfelseif ParentCode neq "">
	  <cfset cl = "ffffdf">
	<cfelse>
	  <cfset cl = "ffffff">  
	</cfif>
	<tr bgcolor="#cl#">
	
	<td width="20" bgcolor="white"></td>
	<td colspan="1" align="left" class="labelit" width="100%">#Code# #Description#</td>
	<td align="left">
	
	<cfif url.mode neq "List">
	 
		<cfif check.recordcount gte "1">
		         <input type="checkbox" 
				        name="ObjectCode" 
                        id="ObjectCode"
						value="#ProgramCode#-#Code#-#Fund#-#Edition#" 
						onClick="javascript:hl(this, this.checked)" checked>
		<cfelse>
		    <!--- allow checkbox if the cost is entered on the same level --->
									 
				<cfquery name="Procurement" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				      SELECT Code 
					  FROM   Ref_Object 
					  WHERE  Procurement = 1
					  AND    Code = '#Code#'
				</cfquery>
				
				<cfparam name="Parameter.FundingOnProgram" default="0">
				 
				<cfif Procurement.recordcount eq "1">
							
					 <cfif ProgramClass eq "Project" and Parameter.FundingOnProgram eq "0">
					 
					 <!--- if Project and funding also occurs on Project check in addition --->
					 
						 <cfquery name="funds" 
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     SELECT * 
							 FROM   ProgramAllotmentDetail 
							 WHERE  ProgramCode   = '#URL.ProgramCode#'
							 AND    Period        = '#URL.Period#'
							 AND    EditionId     = '#Edition#'
							 AND    Fund          = '#URL.Fund#'
							 AND    ObjectCode    = '#Code#'
							 AND    Amount        > 0			 
						 </cfquery>
						 
						 <!--- enforced for procurement --->
						 
						 <cfquery name="enforce" 
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					      		SELECT  *
			                    FROM   ProgramObject
			                    WHERE  ProgramCode = '#ProgramCode#'
								AND    ObjectCode  = '#Code#'					
						 </cfquery>
						 
						 <cfif funds.recordcount gt "0" or enforce.recordcount gt "0">
					
						 		<input type="checkbox" 
						        name="ObjectCode" 
                                id="ObjectCode"
								value="#ProgramCode#-#Code#-#Fund#-#Edition#" 
								onClick="javascript:hl(this, this.checked)">
								
						</cfif>	
									
					<cfelse>
					
						 <input type="checkbox" 
					        name="ObjectCode" 
                            id="ObjectCode"
							value="#ProgramCode#-#Code#-#Fund#-#Edition#" 
							onClick="javascript:hl(this, this.checked)">
					
					</cfif>	
					
				</cfif>	
			
		</cfif>
	
	</cfif>
	</td>
	
	<td align="right" style="border-left: 1px solid Gray;padding-right:2px">	
			
			<cfquery name="Total" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    SUM(PAD.AmountBase) AS Total
				FROM      ProgramAllotment PA INNER JOIN
			              ProgramAllotmentDetail PAD ON PA.ProgramCode = PAD.ProgramCode AND PA.Period = PAD.Period AND PA.EditionId = PAD.EditionId
				WHERE     PA.Period = '#URL.period#'
				AND       PAD.ObjectCode = '#Code#'
				AND       PAD.Fund       = '#URL.Fund#'
				AND       PA.ProgramCode IN (SELECT ProgramCode 
				                             FROM Program.dbo.Program 
											 WHERE ProgramHierarchy LIKE '#ProgramHierarchy#%')
				AND       PA.EditionId = '#Edition#'
		    </cfquery>		
			
			<cfif Total.total eq "">
				  <cfset all = 0>
			<cfelse>
				  <cfset all =  Total.total>
			</cfif>
			
			<cf_space align="right" label="#numberformat(all/1000,"_,_._")#" spaces="23">
					
	</td>
			
		<!--- define reservations --->
		
		<cftry>
		
			<!--- define reservations --->
			<cfquery name="Reservation" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   SUM(ReservationAmount) as ReservationAmount
			FROM     dbo.#SESSION.acc#Requisition
			WHERE    ProgramCode IN (SELECT ProgramCode 
				                       FROM Program.dbo.Program 
									   WHERE ProgramHierarchy LIKE '#ProgramHierarchy#%')
			AND       ObjectCode = '#Code#'		
			AND       Fund       = '#URL.Fund#'				   
			</cfquery>
			
			
		<cfcatch>
			<cfquery name="Reservation" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    SUM(L.Percentage * R.RequestAmountBase) AS ReservationAmount
			FROM      RequisitionLine R INNER JOIN
			          RequisitionLineBudget L ON R.RequisitionNo = L.RequisitionNo
			WHERE     R.Mission         = '#URL.Mission#'
			AND       R.Period IN (#preservesingleQuotes(persel)#) 
			AND       R.RequisitionNo   != '#URL.ID#' 
			AND       L.ObjectCode = '#Code#'
			AND       L.Fund       = '#URL.Fund#'
			AND       R.ActionStatus    > '2' 
			AND       R.ActionStatus    < '3' 
			AND       L.Status != '9'
			AND       L.Fund       = '#URL.Fund#'
			AND       L.ProgramCode IN (SELECT ProgramCode 
				                        FROM  Program.dbo.Program 
										WHERE ProgramHierarchy LIKE '#ProgramHierarchy#%')
			</cfquery>
		</cfcatch>
		
		</cftry>
		
		
		<cfif Reservation.ReservationAmount neq "">
		    <td align="right" 		
			 style="border-left: 1px solid Gray;cursor: pointer;;padding-right:2px"	
			 onclick="bmore('add','#ProgramCode#_#url.Fund#_#CurrentRow#','#URL.Fund#','#URL.ID#','#URL.Period#','#URL.ProgramCode#','#Code#','show','list','#url.mission#')" 
			 onmouseover="this.className='highlight'"
			 onmouseout="this.className='regular'">		   
			
		<cfelse>
		    <td align="right" style="border-left: 1px solid Gray;;padding-right:2px">		   
			
		</cfif>
		
		<cfif Reservation.ReservationAmount eq "">
		  <cfset res = 0>
		<cfelse>
		  <cfset res =  Reservation.ReservationAmount>
		</cfif>
		
		<cf_space align="right" label="#numberformat(res/1000,"_,_._")#" spaces="23">
	
	</td>
	
		<!--- define reservations --->
		
		<cftry>
		
			<!--- define reservations --->
			<cfquery name="Obligation" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   SUM(ObligationAmount) as ObligationAmount
			FROM     dbo.#SESSION.acc#Obligation
			WHERE    ProgramCode IN (SELECT ProgramCode 
				                       FROM Program.dbo.Program 
									   WHERE ProgramHierarchy LIKE '#ProgramHierarchy#%')
			AND      ObjectCode = '#Code#'	
			AND      Fund       = '#URL.Fund#'			
							   
			</cfquery>
			
			<cfcatch>
				
				<!--- define obligations --->
				<cfquery name="Obligation" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    SUM(L.Percentage * P.OrderAmountBaseObligated) AS ObligationAmount
				FROM      RequisitionLine R INNER JOIN
				                      RequisitionLineBudget L ON R.RequisitionNo = L.RequisitionNo INNER JOIN
				                      PurchaseLine P ON R.RequisitionNo = P.RequisitionNo
				WHERE     R.Mission         = '#URL.Mission#'
				AND       R.Period IN (#preservesingleQuotes(persel)#) 
				AND       L.ProgramCode IN (SELECT ProgramCode 
					                             FROM Program.dbo.Program 
												 WHERE ProgramHierarchy LIKE '#ProgramHierarchy#%')
				AND       (R.RequisitionNo != '#URL.ID#') 
				AND       (R.ActionStatus   = '3') 
				AND       P.PurchaseNo IN (SELECT PurchaseNo FROM Purchase WHERE ObligationStatus = 1)
				AND       P.ActionStatus  != '9'
				AND       L.Status != '9'
				AND       L.ObjectCode = '#Code#'
				AND       L.Fund       = '#URL.Fund#'						
				</cfquery>
			
			</cfcatch>
		
		</cftry>
			
		<cfif Obligation.ObligationAmount neq "">
		   <td align="right" 
			 onclick="bmore('add','#ProgramCode#_#url.Fund#_#CurrentRow#','#url.Fund#','#URL.ID#','#URL.Period#','#URL.ProgramCode#','#Code#','show','list','#url.mission#')" 
			 style="border-left: 1px solid Gray;cursor: pointer;;padding-right:2px"		 
			 onmouseover="this.className='highlight'"
			 onmouseout="this.className='regular'">		   
					
		<cfelse>
		    <td align="right" style="border-left: 1px solid Gray;;padding-right:2px">
		</cfif>
		
		<cfif Obligation.ObligationAmount eq "">
		  <cfset obl = 0>
		<cfelse>
		  <cfset obl =  Obligation.ObligationAmount>
		</cfif>
		
		<cf_space align="right" label="#numberformat(obl/1000,"_,_._")#" spaces="23">
	
	    </td>
	
			
		<cfif Obligation.ObligationAmount neq "">

		   <td align="right" 	
		       style="border-left: 1px solid Gray;cursor: pointer;;padding-right:2px" 
			   onclick="bmore('add','#ProgramCode#_#url.Fund#_#CurrentRow#','#url.Fund#','#URL.ID#','#URL.Period#','#URL.ProgramCode#','#Code#','show','list','#url.mission#')"
			   onmouseover="this.className='highlight'"
			   onmouseout="this.className='regular'">
					   			
		<cfelse>
		
		   <td align="right" style="border-left: 1px solid Gray;;padding-right:2px">
			
		</cfif>
		
		<cf_space align="right" label="#numberformat((obl+res)/1000,"_,_._")#" spaces="23">
		
	</td>
		
	</tr>
	
	<tr class="hide" id="add#ProgramCode#_#url.Fund#_#CurrentRow#" bgcolor="white">
	    <td bgcolor="white"></td>
	    <td colspan="6" id="iadd#ProgramCode#_#url.Fund#_#CurrentRow#"></td>
	</tr>
		
	</cfoutput>
	
	
</cfoutput>

</table>