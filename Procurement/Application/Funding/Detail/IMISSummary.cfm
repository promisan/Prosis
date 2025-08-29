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
<cfoutput>


	<table width="100%">
		 
		 <!--- custom method --->
		 		 
		 <cfset url.year = "#expenditure.accountperiod#">
		 		
		 <cfquery name="IMIS" 
		    datasource="AppsPurchase" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">		
			SELECT     f_glan_seq_num, ROUND(SUM(curr_amt), 2) AS Total
			
			FROM     
				
				(   SELECT * FROM MergeData.dbo.IMP_stLedger_#url.Mission# AS I INNER JOIN
	                      stLedgerRouting AS R ON I.db_mdst_source = R.DutyStation 
						      AND I.f_fund_id_code = R.Fund 
							  AND I.f_orgu_id_code = R.OrgCode 
							  AND I.f_objc_id_code = R.ObjectClass 
							  AND I.f_objt_id_code = R.ObjectCode 
							  AND I.f_pgmm_id_code = R.PrgCode 
							  AND R.PrgCode != ''
							  AND R.Mission = '#url.Mission#'		
					 WHERE (I.f_glan_seq_num IN ('4510', '6210', '6310')) AND I.f_fund_id_code NOT IN ('ZCA','ZDA')		  		
							  
					UNION 
					
					SELECT * FROM MergeData.dbo.IMP_stLedger_#url.Mission# AS I INNER JOIN
	                      stLedgerRouting AS R ON I.db_mdst_source = R.DutyStation 
						      AND I.f_fund_id_code = R.Fund 
							  AND I.f_orgu_id_code = R.OrgCode 
							  AND I.f_objc_id_code = R.ObjectClass 
							  AND I.f_objt_id_code = R.ObjectCode 
							  AND R.PrgCode = '' <!--- blank --->
							  AND R.Mission = '#url.Mission#'	
					WHERE (I.f_glan_seq_num IN ('4510', '6210', '6310')) AND I.f_fund_id_code IN ('ZCA','ZDA')			  
							  
				) as R	  			
			
			WHERE      (f_glan_seq_num IN ('4510', '6210', '6310')) 
			
			<!--- new for fund and oe --->
			
			<cfif url.fund neq "">								
				AND     Nova_Fund = '#url.fund#'				
			</cfif>
			
			<cfif getPeriod._tsQueryCondition neq "">
				AND      (#preserveSingleQuotes(getPeriod._tsQueryCondition)#)					
			<cfelse>				
				AND        f_fnlp_fscl_yr = '#url.year#' 
			</cfif>				
			
			AND        f_actv_id_code = '#Period.Reference#'
										
			<cfif url.ObjectCode neq "">
																						
					<cfif resource neq "">
										
					   AND     Nova_Object IN (SELECT Code FROM Program.dbo.Ref_Object WHERE Resource = '#resource#')
					
					<cfelse>
					
							<cfif url.ObjectCode neq "">		
							
							
								
									AND  (
									      Nova_Object = '#url.ObjectCode#' OR 
									      Nova_Object IN (SELECT Code 
										                   FROM   Program.dbo.Ref_Object 
														   WHERE  ParentCode = '#url.ObjectCode#')
										  )
										  
										 
							<cfelse>
								
								<!--- only valid objects within this edition --->
							
								AND    Nova_Object IN (SELECT Code 
														FROM   Program.dbo.Ref_Object 
														WHERE  Code = L.ObjectCode
														<cfif url.editionid neq "">
														AND    ObjectUsage = (SELECT   TOP 1 V.ObjectUsage
																			  FROM     Program.dbo.Ref_AllotmentEdition E INNER JOIN
																	                   Program.dbo.Ref_AllotmentVersion V ON E.Version = V.Code
																			  WHERE    E.EditionId = '#editionid#')									    
																			  
													    </cfif>
														)
														
														
									
							</cfif>
								   
					</cfif>				
				
			</cfif>		
						
			GROUP BY   f_glan_seq_num 
			HAVING     (SUM(curr_amt) > 0)
			ORDER BY   f_glan_seq_num 
			
		</cfquery>	
		
		<tr>
		   <td height="19" colspan="3" width="15%" style="padding-left:10px" >
		   
			   <table><tr><td class="labelmedium">
			   <i><u>IMIS</u>
			   </td>
			   <td class="labelit" style="padding-left:7px">
			   <a href="javascript:imis('#url.year#','#url.fund#','#period.reference#','#url.objectcode#','#url.editionid#','#url.mission#','#res#','#url.programcode#')"><font color="0080C0">[more ...]</font></a>
			   </td>		 
			   </tr>
			   </table>
		   </td>
		   <td width="15%" class="labelit" align="right" style="padding-right:4px">Pre-encum. (4510)</td>
		   <td width="15%" class="labelit" align="right" style="padding-right:4px">Unliq. Obl (6210)</td>
		   <td width="15%" class="labelit" align="right" style="padding-right:4px">Disbursem. (6310)</td>
		   <td width="15%" class="labelit" align="right" style="padding-right:4px">Total</td>
		   <td width="15%" class="labelit" align="right" style="padding-right:4px">Balance</td>
		</tr>  	
								
		<!--- IMIS preencum, unliquidated obligation, disbursement --->
		
		<tr>
		    <td></td>
			<td></td>
			<td></td>
			<td height="20" class="labelit" align="right" style="border:1px solid silver;padding-right:4px">
			
			  <cfquery name="Total" dbtype="query">
				SELECT    Total as Pre
				FROM      IMIS		
				WHERE     f_glan_seq_num = 4510
		      </cfquery>  	
			  		  
			  #numberformat(Total.Pre,'__,__')#
			  
			  </td>
			
			<td height="20" class="labelit" align="right" style="border:1px solid silver;padding-right:4px">
			
			 <cfquery name="Total" dbtype="query">
				SELECT    Total as Obl
				FROM      IMIS		
				WHERE f_glan_seq_num = 6210
		      </cfquery>  	 
		  
			  #numberformat(Total.Obl,'__,__')#
			
			</td>
			
			<td height="20" class="labelit" align="right" style="border:1px solid silver;padding-right:4px">
			
			 <cfquery name="Total" dbtype="query">
				SELECT    Total as Dis
				FROM      IMIS		
				WHERE f_glan_seq_num = 6310
		      </cfquery>  	 
		  
			  #numberformat(Total.Dis,'__,__')#
			
			</td>
				
			<td height="20" class="labelit" align="right" style="border:1px solid silver;padding-right:4px">
			
			 <cfquery name="Total" dbtype="query">
				SELECT    sum(Total) as Amount
				FROM      IMIS						
		      </cfquery>  	 
		  
			  #numberformat(Total.Amount,'__,__')#
			
			</td>
			
			<td height="20" class="labelit" align="right" style="border:1px solid silver;padding-right:4px">
			
			<cfif Total.Amount eq "">
			    <cfset tot = "0">
			<cfelse>
				<cfset tot = Total.Amount>
			</cfif>
					
			<cfset bal = bud-tot>
			<cfif bal lt 0><font color="FF0000"></cfif>#numberformat(bal,'__,__')#<cf_space spaces="20">
			
			</td>
			
		</tr>	
		
		</table>
			
</cfoutput>		