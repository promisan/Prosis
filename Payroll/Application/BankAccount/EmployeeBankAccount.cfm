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
<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop label="" height="100%" scroll="yes" html="No" menuaccess="context" jquery="Yes" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">

<cf_tl id="Do you want to remove this account ?" var="vDeleteAsk">
	
<cfoutput>
	<script language="JavaScript">
		function account(persno) {
		    ptoken.location("AccountEntry.cfm?ID=" + persno);
		}

		function accountedit(persno,id) {
		    ptoken.location("AccountEdit.cfm?ID=" + persno + "&ID1=" + id);
		}

		function accountdelete(persno,id) {
			if (confirm('#vDeleteAsk#')) {
		    	ptoken.location("AccountPurge.cfm?ID=" + persno + "&ID1=" + id);
			}
		}
	</script>
</cfoutput>

<cf_dialogPosition>

<table cellpadding="0" cellspacing="0" width="99%" align="center">

	<tr><td height="10" style="padding-top:3px;padding-left:7px">	
		  <cfset ctr      = "0">		
	      <cfset openmode = "open"> 
		  <cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	
</table>

<!--- Query returning search results --->
<cfquery name="Listing" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
    FROM     PersonAccount L INNER JOIN Ref_Bank R ON R.Code = L.BankCode
	WHERE    L.PersonNo = '#URL.ID#' 	
	<!--- the account was the father of a new account --->
	AND      AccountId NOT IN (SELECT SourceId 
	                           FROM   PersonAccount 
							   WHERE  PersonNo = '#URL.ID#'
							   AND    SourceId is not NULL) 
	AND      L.ActionStatus IN ('0','1')						   
	ORDER BY L.Destination 
</cfquery>

<table width="96%" align="center" class="formpadding">
<tr><td>
	
<table width="98%" align="center" class="formpadding">
  <tr>
  
    <cfoutput>
    <td width="1%" class="labellarge"  style="padding:5px 0 4px 4px;">		   
		<img src="#SESSION.root#/Images/bankaccount.png" height="99" alt=""  border="0" align="absmiddle">			
	</td>
	
    <td width="98%" height="24" style="font-size:38px;font-weight:200" class="labelmedium2"><cf_tl id="Bank accounts"></td>
	
    <td align="right" height="30" style="padding-right:10px;padding-top:35px">
	
				<cfinvoke component="Service.Access"  
		          method="employee"  
				  personno="#URL.ID#" 
				  returnvariable="access">
				  
			    <cfif access eq "EDIT" or access eq "ALL">
					
					<cf_tl id="Add" var="vAdd">
					
			    	<input type="button" 
					       value="#vAdd#" 
						   class="button10g" 
						   onClick="account('#URL.ID#')">
						   
				</cfif>
    </td>
	</cfoutput>
   </tr>
   <tr>
  <td width="100%" colspan="3">
  
	  <table width="100%" class="navigation_table">
			
		<TR class="line labelmedium2 fixlengthlist">
		    <td align="center"></td>
		    <td><cf_tl id="Bank"></td>
			<td><cf_tl id="Address"></td>
			<td><cf_tl id="Type"></td>			
			<TD><cf_tl id="Account"></TD>			
			<TD><cf_tl id="IBAN"></TD>
			<TD><cf_tl id="Effective"></TD>
		</TR>
		
		<cfinvoke component="Service.Access"  method="employee"  personno="#URL.ID#" returnvariable="access">
			 			
		<cfset last = '1'>
		
		<cfoutput query="Listing" group="Destination">
		
		<tr class="line">
		<td colspan="9" class="labelmedium2" style="font-size:20px;font-weight:200;height:35;padding-left:5px">#Destination#</tr>
		</tr>
		
		<cfoutput>
			
		
		<cfif actionstatus eq "0">
			<cfset cl = "FFFF0080">
		<cfelseif actionstatus eq "1">
			<cfset cl = "FFFFFF80">		
		<cfelse>
			<cfset cl = "FFC1C180">		
		</cfif>
		
		<TR bgcolor="FFFFFF" class="labelmedium2 line navigation_row fixlengthlist">
		<td align="center" height="20" style="background-color:###cl#">		
		     
		     <cfif access eq "EDIT" or access eq "ALL">
			 	<table>
			 		<tr>
			 			<td style="padding-top:2px">
			 				<cf_img icon="open" navigation="Yes" onclick="accountedit('#url.id#','#accountid#')">
			 			</td>

			 			<cfquery name="validateDelete" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   AccountId
						    FROM     EmployeeSettlementDistribution
							WHERE    PersonNo = '#URL.ID#' 
							AND      AccountId = '#accountid#'
							UNION ALL
							SELECT   AccountId
						    FROM     PersonDistribution
							WHERE    PersonNo = '#URL.ID#' 
							AND      AccountId = '#accountid#'
						</cfquery>

						<td style="padding-left:2px;padding-top:3px">
							<cfif validateDelete.recordCount eq 0>
				 				<cf_img icon="delete" navigation="Yes" onclick="accountdelete('#url.id#','#accountid#')">
				 			<cfelse>
				 				&nbsp;
			 				</cfif>
			 			</td>
			 		</tr>
			 	</table>
			     
			 </cfif>  
			 
		</td>	
		<td style="background-color:###cl#">#Description#</td>
		<td style="background-color:###cl#">#BankAddress#</td>
		<td style="background-color:###cl#">#AccountType#-#AccountCurrency#</td>		
		<td style="background-color:###cl#">#AccountNo#</td>		
		<TD style="background-color:###cl#;padding-left:5px;padding-right:4px"><cfif IBAN eq AccountNo><i><font color="gray"><cf_tl id="Same"><cfelse>#IBAN#</cfif></TD>		
		<td style="background-color:###cl#;padding-right:4px;">#dateformat(DateEffective,client.dateformatshow)#</td>		
		
		</tr>
				
		
		<TR class="labelit line" style="height:19px" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F1F1F1'))#">
			<td></td>
			<td style="font-size:12px" colspan="9">#OfficerFirstName# #OfficerLastName# #dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")# <cfif Remarks neq "">#Remarks#</cfif></td>
		</tr>
				
		<cfquery name="Distribution" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
			    FROM 	PersonDistribution L
				WHERE 	L.PersonNo     = '#PersonNo#' 
				AND 	L.AccountId     = '#AccountId#'
				AND 	L.DateEffective <= getdate()
		</cfquery>
		
		<cfif Distribution.recordCount eq "0">
		
		 <!--- we check if the actionstatus and if the parent still has an distribution --->
		
			<tr class="labelmedium2 line" bgcolor="f1f1f1" id="#accountid#">			
				<td align="left"></td>			
				<td colspan="8"><cf_tl id="Method of Payment">:<font color="0080C0"><cf_tl id="not used"></td>
			</tr>
		
		<cfelse>
		
			<cfloop query = "Distribution">
				
				<tr bgcolor="D0FDC4" class="labelmedium2 line fixlengthlist">
				
				<td align="left"></td>
				<td colspan="8">
				<cf_tl id="Method of Payment"> : <b>#Distribution.DistributionMethod#</b> [<cf_tl id="Effective">: #dateFormat(Distribution.DateEffective, client.dateformatshow)# ] </b>
				</td>
				
				</tr>
			
			</cfloop>
		
		</cfif>
	
		<cfset srcid = sourceId>
		<cfset stats = actionstatus>
		<cfset cnt = 0>
								
		<!--- show the parent accounts --->
		
		<cfloop condition="#srcid# neq '' and #cnt# lte '5'">	
			
			<cfset cnt = cnt+1>
		
			<cfquery name="Parent" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
			    FROM     PersonAccount L INNER JOIN Ref_Bank R ON R.Code = L.BankCode
				WHERE    PersonNo = '#URL.ID#' 	
				AND      AccountId = '#srcid#'				
				AND      ActionStatus IN ('0','1')						   
				ORDER BY L.Destination 
			</cfquery>
			
			<cfloop query="Parent">
			
				<tr bgcolor="e4e4e4" class="labelmedium2 line" style="height:14px">
				<td align="right" style="border-right:1px solid silver">		
												     
				     <cfif access eq "EDIT" or access eq "ALL">
					 	<table style="width:100%;height:100%">
					 		<tr>					 			
		
					 			<cfquery name="validateDelete" 
								datasource="AppsPayroll" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   AccountId
								    FROM     EmployeeSettlementDistribution
									WHERE    PersonNo  = '#URL.ID#' 
									AND      AccountId = '#accountid#'
									UNION ALL
									SELECT   AccountId
								    FROM     PersonDistribution
									WHERE    PersonNo  = '#URL.ID#' 
									AND      AccountId = '#accountid#'
								</cfquery>
		
							    <cfif validateDelete.recordCount eq 0>
								<td align="right" style="padding-left:5px;padding-top:3px">									
						 				<cf_img icon="delete" navigation="Yes" onclick="accountdelete('#url.id#','#accountid#')">						 			
					 				
					 			</td>
								</cfif>
																
					 		</tr>
					 	</table>
					     
					 </cfif>  
					 
				</td>	
				<td style="padding-left:5px;color:gray"> <img src="#session.root#/images/join.gif" alt="" border="0">#Description#</td>
				<td style="color:gray">#BankAddress#</td>
				<td style="color:gray">#AccountType#-#AccountCurrency#</td>		
				<td style="color:gray">#AccountNo#</td>		
				<TD style="color:gray;padding-left:5px;padding-right:4px"><cfif IBAN eq AccountNo><i><cf_tl id="Same"><cfelse>#IBAN#</cfif></TD>		
				<td style="color;gray;padding-left:4px;">#dateformat(DateEffective,client.dateformatshow)#</td>				
				</tr>		
				
				<cfquery name="Distribution" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT 	*
					    FROM 	PersonDistribution L
						WHERE 	L.PersonNo      = '#PersonNo#' 
						AND 	L.AccountId     = '#AccountId#'
						AND 	L.DateEffective <= getdate()
				</cfquery>
				
				<cfif Distribution.recordCount eq "0">
				
				    <!---
					
					<tr class="labelmedium line" bgcolor="f1f1f1">			
						<td align="left"></td>			
						<td colspan="8"><cf_tl id="Method of Payment">:<font color="0080C0"><cf_tl id="not used"></td>
					</tr>
					
					--->
				
				<cfelse>
				
					<cfif stats eq "1">
					    <cfset cl = "FFC1C1">
					<cfelse>
					
						<cfset cl = "D0FDC4">  
					</cfif>
				
					<cfloop query = "Distribution">
						
						<tr class="labelmedium2 line" bgcolor="#cl#">
												
						<td align="left"></td>
						<td colspan="8">
						<cf_tl id="Method of Payment"> : #stats#<b>#Distribution.DistributionMethod#</b> [<cf_tl id="Effective">: #dateFormat(Distribution.DateEffective, client.dateformatshow)# ] </b>
						</td>
						
						</tr>
					
					</cfloop>
				
				</cfif>		
				
				<cfset srcid = sourceid>			
				
			</cfloop>			
								
		</cfloop>
		
		<tr class="labelmediumt line" bgcolor="FFFFEF">
			<td></td>
			<td colspan="8">
				<cfquery name="getAccountMission" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT 	PAM.*,
					    		B.BankName,
					    		B.AccountNo,
					    		B.Currency
					    FROM 	PersonAccountMission PAM
					    		INNER JOIN Accounting.dbo.Ref_BankAccount B 
					    			ON PAM.BankId = B.BankId
						WHERE 	PAM.PersonNo = '#PersonNo#'
						AND 	PAM.AccountId = '#AccountId#'
				</cfquery>
				<table>
					<cfloop query="getAccountMission">
						<tr class="labelmedium2">
							<td>#Mission#:</td>
							<td style="padding-left:10px;">
								#BankName# - (#AccountNo# - #Currency#)
							</td>
						</tr>
					</cfloop>
				</table>
			</td>
		</tr>
		
							
		</cfoutput>
		</cfoutput>
		
		</TABLE>

</td>
</tr>

</table>

<cfset ajaxonload("doNavigation")>
