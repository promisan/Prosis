<!--
    Copyright © 2025 Promisan

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

<!--- generate a mapping table ObjectCode to ParentCode --->

<cfset FileNo = round(Rand()*100)>
<cfparam name="init" default="0">
<cfset spc = "31">

<cfparam name="Form.SelectedFund" default="">

<cfif form.selectedFund eq "">
	<cfabort>
</cfif>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Allocation#FileNo#">	

<cfquery name="Edition"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   E.*,V.ObjectUsage
	FROM     Ref_AllotmentEdition E, Ref_AllotmentVersion V
	WHERE    E.Version = V.Code
	AND      E.EditionId = '#url.editionid#'	
</cfquery>

<cfquery name="FundList"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_AllotmentEditionFund	
	WHERE    EditionId = '#url.editionid#'		
	AND      Fund IN (#preservesingleQuotes(form.SelectedFund)#)
</cfquery>

<cfset fd = "">
<cfloop query="FundList">
  <cfif fd is "">
     <cfset fd = "#Fund#"> 
  <cfelse>
	 <cfset fd = "#fd#,#Fund#">
  </cfif>	 
</cfloop>	

<cfif FundList.recordcount gte "2">
	<cfset cols = "#(fundlist.recordcount*3)+2#">
<cfelse>
	<cfset cols = "#(fundlist.recordcount*3)+2#">
</cfif>

<!--- get programs that were planned and need to be shown for selected fund(s) --->

<cfquery name="getProgram"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT P.ProgramCode,
	       P.ProgramName, 
		   Pe.Reference, 
		   Par.HierarchyCode,
		   Pe.PeriodHierarchy,
		   P.ProgramAllocation,
		   Par.OrgUnitCode,
		   Par.OrgUnitName,
		   Par.OrgUnit		   
				  
	FROM   Program P, 
	       ProgramPeriod Pe, 		   
		   Organization.dbo.Organization O,
		   Organization.dbo.Organization Par
		   		   
	WHERE  P.Mission = '#Edition.mission#'
	AND    Pe.Period      = '#url.period#'	
	AND    Pe.ProgramCode  = P.ProgramCode
	
	AND    P.ProgramCode IN (
	
	                         <!--- has requirements --->
							 
	                         SELECT ProgramCode
	                         FROM   ProgramAllotmentDetail
							 WHERE  ProgramCode = P.ProgramCode
							 AND    Period      = Pe.Period
							 AND    EditionId   = '#url.editionid#'	
							 AND    Fund IN (#preservesingleQuotes(form.SelectedFund)#)
																				 
							 UNION
							 
							 <!--- has entries --->
							 
							 SELECT ProgramCode
	                         FROM   ProgramAllotmentAllocation
							 WHERE  ProgramCode = P.ProgramCode
							 AND    Period      = Pe.Period
							 AND    EditionId   = '#url.editionid#'	
							 AND    Fund IN (#preservesingleQuotes(form.SelectedFund)#)
							 
							 <!--- -------------------------------------------------------------- --->
							 <!--- provision to show dummy programs meant for budget control only --->
							 <!--- -------------------------------------------------------------- --->
							 
							 UNION
							 
							 SELECT ProgramCode
	                         FROM   Program
							 WHERE  Mission = P.Mission	
							 AND    ProgramCode = P.ProgramCode
							 AND    ProgramAllocation = 1		
							  
							 							 
							)
		
	AND    Pe.OrgUnit      = O.OrgUnit	
	AND    Par.Mission     = O.Mission
	AND    Par.MandateNo   = O.MandateNo
	
	<!--- we might have to adjust this a bit --->
	
	AND    Par.OrgUnitCode = O.HierarchyRootUnit 
			
	ORDER BY   Par.HierarchyCode, <!--- OrgUnit --->
	           Pe.PeriodHierarchy 			
					 
</cfquery>

<!--- get list of parent object codes to show for data entry --->

<cfquery name="getObject"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Object O, Ref_Resource R
	WHERE    O.Resource = R.Code
	AND      O.Code IN (SELECT ParentCode 
	                    FROM   userquery.dbo.#SESSION.acc#Object)
	AND      ObjectUsage = '#Edition.ObjectUsage#' 		
			  
	ORDER BY R.ListingOrder, O.ListingOrder	
</cfquery>  

<cfquery name="getAllocation"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT ProgramCode,
		       Fund,
			   ObjectCode,
			   Amount
		INTO   userquery.dbo.#SESSION.acc#Allocation#FileNo#
	    FROM   ProgramAllotmentAllocation
		WHERE  Period      = '#url.period#'
		AND    Editionid   = '#url.editionid#'		
		AND    Fund IN (#preservesingleQuotes(form.SelectedFund)#)	
</cfquery>

<cfset fdlist = replaceNoCase(form.SelectedFund,"'",":","ALL")> 

<!--- ----------------------    --------------------------pending correction --->
<!--- SHOW also program LIST that are not in allotment by that have an entry --->
<!--- --------------------------     --------------------------------------- --->

<table height="99%" width="1%" border="0" cellspacing="0" cellpadding="0">
	
	<cfoutput>	
		
	<tr>
	 <td height="30" class="labelit">Service<br>Program<cf_space spaces="80"></td>
	 
	  <cfloop index="fund" list="#fd#">
  		
		<td align="center" class="labelmedium">
			<cf_space spaces="#spc#">	
			Requirement
		</td>
		
		<td valign="bottom">
		 
		 
		 <table width="100%" cellspacing="0" cellpadding="0">		
			<tr><td align="center" class="labelmedium"><b>#fund#</td></tr>	
			<tr><td align="center" class="labelmedium">Allocation</td></tr>
		 </table>	
		 <cf_space spaces="#spc#">		
		
		</td>
		
		<td align="center" class="labelmedium">		   	
		    Expenditures
			<cf_space spaces="#spc#">
		</td>
		
      </cfloop>
	  
	  <cfif FundList.recordcount gte "2">

	      <td class="labelit" valign="bottom" align="center">
		  <cf_space spaces="#spc#">Total
		  </td>
		  
	  <cfelse>
	  
	  <td><cf_space spaces="10"></td>	  
		  
	  </cfif>
	  
	</tr>	
	
	<tr><td colspan="#cols#" class="line"></td></tr>
	
	<!--- --------------------- --->
	<!--- container for details --->
	<!--- --------------------- --->
	
	</cfoutput>
	
	<tr>
	<td colspan="<cfoutput>#cols#</cfoutput>" width="100%" height="100%" border="1">	 	
	
	 <cf_divscroll id="detail" style="width:100%">	 
		<cfinclude template="AllocationEntryDetail.cfm">
	 </cf_divscroll>		
	
	</td>
	</tr>
				
	<!--- container for the totals --->			
	
	<cfquery name="getEnvelope"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   R.Description,
					 R.ListingOrder,
					 E.Fund,
					 MAX(TransactionDate) as Date,
			         SUM(TransactionAmount) as Amount
		    FROM     Envelope E, EnvelopeLine L, Ref_EnvelopeClass R
			WHERE    E.EnvelopeId = L.EnvelopeId
			AND      L.EnvelopeClass = R.Code
			AND      E.Mission   = '#Edition.mission#'
			AND      E.Period    = '#Edition.Period#'
			AND      E.Fund IN (#preservesingleQuotes(form.SelectedFund)#)	
			GROUP BY R.Description,
					 R.ListingOrder,										
					 E.Fund
			ORDER BY R.Description		 					 
	</cfquery>		
	
	<cfif getEnvelope.recordcount gte "1">
	
	<cfoutput>
	<tr><td height="4"></td></tr>					
	<tr><td colspan="#cols#" class="line"></td></tr>	
	<tr><td colspan="#cols#" bgcolor="yellow" style="height:25;padding-left:10" class="labelmedium">Envelope (#dateformat(getEnvelope.Date,client.dateformatshow)#)</td></tr>	
	<tr><td colspan="#cols#" class="line"></td></tr>		
	
	</cfoutput>
	
	<cfoutput query="getEnvelope" group="Description">	
					
	<tr bgcolor="ffffaf">		
		
		<td style="padding-left:4px;padding-left:20px" class="labelmedium">#Description#</td>
						
			<cfloop query="get">
			    <cfset val[currentrow] = amount>
			</cfloop>
			
			<cfloop index="fund" list="#fd#">
			
				<td></td>
				
				<cfquery name="getValue"
	                 dbtype="query">
						SELECT   SUM(Amount) as Amount
					    FROM     getEnvelope
						WHERE    Fund = '#fund#' and Description = '#Description#'
				</cfquery>	
								
				<td class="labelmedium" align="right" style="padding-right:20px">#numberformat(getValue.Amount,',__')#</td>
				<td></td>
			
			</cfloop>
					
		<cfif FundList.recordcount gte "2">
		
		    <td class="labelit" align="right" style="padding-right:20px">	
			
			<cfquery name="getValue"
                 dbtype="query">
					SELECT   SUM(Amount) as Amount
				    FROM     getEnvelope
					WHERE    Description = '#Description#'
			</cfquery>	
					
			#numberformat(getValue.amount,',__')#						
			</td>
			
		<cfelse>
		
		<td></td>	
		
		</cfif>
		
		<!--- take for this mission, fund and period the total by class --->
		
	</tr>
	
	</cfoutput>
			
	<tr><td colspan="#cols#" class="line"></td></tr>		
	
	</cfif>
	
	<cfoutput>
				
	<tr height="20" bgcolor="97FF97">
			
			<td width="10%" style="padding-left:14px" style="height:30" class="labelmedium"><cf_space spaces="70">Overall Total</td>	
			
			<cfquery name="get"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   Fund,
					         SUM(Amount) as Amount
				    FROM     dbo.#SESSION.acc#Allocation#FileNo#		
					WHERE    Fund IN (#preservesingleQuotes(form.SelectedFund)#)	
					GROUP BY Fund											
			</cfquery>		
		
			<cfloop query="get">
			    <cfset val[currentrow] = amount>
			</cfloop>
			
			<cfset col = 0>			
			<cfset sub = 0>			
						
			<cfloop index="fund" list="#fd#">
					
			    <cfset col = col+1>
				<cfparam name="val[#col#]" default="0">					
				
				<cfquery name="getBudget" 
			    datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   SUM(Total) as Amount
				    FROM     #SESSION.acc#_AllRequirement S					
					WHERE    Fund = '#fund#'
				</cfquery>		
				
				<td align="right" style="padding-right:16px" class="labelmedium">				
					#numberformat(getBudget.Amount,',__')#								
				</td>
				
				<td align="right" style="padding-left:2px;padding-right:3px">
			     										
					<table cellspacing="0" cellpadding="0" width="100%">
						<tr>
						<td style="padding-right:16px" 
						 colspan="2" class="labelmedium" 
						 align="right" id="tot__#fund#" height="20">			
						#numberformat(val[col],',__')#
						</td>						
						</tr>
					</table>
											  
			    </td>
								
				<cfquery name="getReservation"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   ISNULL(SUM(ReservationAmount),0) as Amount
				    FROM     #SESSION.acc#_AllReservation S
					WHERE    Fund = '#fund#'
			  </cfquery>		
					
			  <cfquery name="getObligation"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   ISNULL(SUM(ObligationAmount),0) as Amount
				    FROM     #SESSION.acc#_AllObligation S
					WHERE    Fund = '#fund#'																					
			  </cfquery>		
					
			  <cfquery name="getInvoice"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   ISNULL(SUM(InvoiceAmount),0) as Amount
				    FROM     #SESSION.acc#_AllDisbursed S
					WHERE    Fund = '#fund#'																			
			  </cfquery>	
			  
			  <cfif getReservation.amount eq "">
			    <cfset res = "0">
			  <cfelse>
			  	<cfset res = getReservation.Amount>
			  </cfif>				
			  		
			   <cfif getObligation.amount eq "">
			    <cfset obl = "0">
			  <cfelse>
			  	<cfset obl = getObligation.Amount>
			  </cfif>		
			  
			  <cfif getInvoice.amount eq "">
			    <cfset inv = "0">
			  <cfelse>
			  	<cfset inv = getInvoice.Amount>
			  </cfif>		
			  								
			  <cfset exp = res+obl+inv>
				
				<td align="right" style="padding-right:16px" class="labelmedium">				
					#numberformat(exp,',__')#								
				</td>
								
				<cfset sub = sub+val[col]>
							
			</cfloop>			
			
			<cfif FundList.recordcount gte "2">
						
				<td align="right">
				
					<cf_space spaces="#spc#">
					
					<table cellspacing="0" cellpadding="0" width="100%">
						<tr>
						<td style="padding-right:20px" colspan="2" align="right" class="labelmedium" id="tot" height="20">		
						#numberformat(sub,',__')#
						</td>				
						</tr>
					</table>
				
				</td>
				
			<cfelse>
		
				<td></td>		
																		
			</cfif>
						
		</tr>
		
	</cfoutput>
	
	<tr><td colspan="#cols#" class="line"></td></tr>
				
	</table>
	
