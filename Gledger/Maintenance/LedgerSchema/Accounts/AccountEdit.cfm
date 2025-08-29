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
<cfparam name="url.idmenu" default="">

<cfquery name="qAccount" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
  	FROM   Ref_Account   
  	WHERE  GlAccount = '#url.id1#'
</cfquery>

<cf_screentop height   = "100%" 
			  label    = "Edit GL Account" 
			  option   = "Maintain GL account for #url.mission# / #qAccount.GlAccount# - #qAccount.Description#" 
			  scroll   = "no" 
			  layout   = "webapp" 
			  banner   = "gray" 
			  bannerforce = "yes"
			  line     = "no"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cf_menuscript>

<cfajaximport tags="cfdiv">

<CFFORM style="height:100%" action="AccountCodeSubmit.cfm?mission=#url.mission#" method="post">

<table width="95%" height="100%" cellspacing="0" cellpadding="0" align="center">

<cfoutput>

<tr><td height="40">

		<!--- top menu --->
				
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">		  		
									
			<cfset ht = "48">
			<cfset wd = "48">			
			
			<tr>		
			
					<cfset itm = 0>
					
					<cfset itm = itm+1>			
										
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/General.png" 
								targetitem = "1"
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "General Settings"
								class      = "highlight1">
								
					<cfset itm = itm+1>													
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/System/Form.png" 
								iconwidth  = "#wd#" 
								targetitem = "2"
								iconheight = "#ht#" 
								name       = "Custom Fields & Actions">			
								
					<cfset itm = itm+1>													
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/System/Form.png" 
								iconwidth  = "#wd#" 
								targetitem = "3"
								iconheight = "#ht#" 
								name       = "Financial Statement">		
								
					<cf_verifyOperational module = "Payroll" Warning   = "No">															

					<cfset payroll = "0">
							
					<cfif operational eq "1">
										
						<cfif qAccount.AccountClass eq "Result">					
													
							<cfquery name="PayrollItem" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							
							SELECT  *
							FROM  
	                             (SELECT        SalarySchedule, Mission, PayrollItem, GLAccount, '' AS Class
	                               FROM         SalarySchedulePayrollItem AS A
	                               WHERE        Mission = '#url.mission#' 
								   AND          (NOT EXISTS
	                                                      (SELECT        'X' AS Expr1
	                                                       FROM            SalarySchedulePayrollItemClass
	                                                       WHERE        (Mission = A.Mission) AND (SalarySchedule = A.SalarySchedule) AND (PayrollItem = A.PayrollItem))) 
								   AND          Operational = 1 
								   AND          GLAccount IN (SELECT GLAccount FROM  Accounting.dbo.Ref_Account)
	                               UNION ALL
	                               SELECT       A.SalarySchedule, A.Mission, A.PayrollItem, B.GLAccount, B.PostClass
	                               FROM         SalarySchedulePayrollItem AS A INNER JOIN
	                                            SalarySchedulePayrollItemClass AS B ON B.Mission = A.Mission AND B.SalarySchedule = A.SalarySchedule AND 
	                                                   B.PayrollItem = A.PayrollItem
	                               WHERE        A.Mission = '#url.mission#' 
								   AND          Operational = 1) as R
								   
							 WHERE GLAccount = '#url.id1#'	   
							
							</cfquery>
						
							<cfif PayrollItem.recordcount neq 0>
							
								<cfset payroll = "1">
							
								<cfset itm = itm+1>														
								<cf_menutab item       = "#itm#" 
							            iconsrc    = "Logos/System/Form.png" 
										iconwidth  = "#wd#" 
										targetitem = "4"
										iconheight = "#ht#" 
										name       = "Payroll items">						
							
							</cfif>
									
						</cfif>
					
					</cfif>
					
				</tr>
		</table>

	</td>
</tr>
 
</cfoutput>
 
<tr><td height="1" colspan="1" class="linedotted"></td></tr>

<tr><td height="100%" style="border:0px solid silver">
	
	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0" 
		  align="center" 
	      bordercolor="d4d4d4">		  
		  		 	 		
			<!--- <tr class="hide"><td valign="top" height="100" id="result" name="result"></td></tr> --->
			
			<cf_menucontainer item="1" class="regular">
				<cfinclude template="AccountCodeEdit.cfm">
			</cf_menucontainer>							
			
			<cf_menucontainer item="2" class="hide">	
					<cfinclude template="AccountCodeCustom.cfm">
			</cf_menucontainer>		
			
			<cf_menucontainer item="3" class="hide">	
					<cfinclude template="Statement/StatementListing.cfm">
			</cf_menucontainer>		
								
			<cfif payroll eq "1">							
				<cf_menucontainer item="4" class="hide">	
						<cfinclude template="AccountPayrollItems.cfm">
				</cf_menucontainer>
			</cfif>			
												
	</table>

</td></tr>

<tr><td height="6px"></td></tr>
	
<tr><td height="1" colspan="2" class="line"></td></tr>

<tr><td></td></tr>

<tr><td colspan="2" align="center" height="35">

		<input class="button10g" style="height:25;width:140px" type="button" name="Cancel" value="Close" onClick="window.close()">
		
		<cfquery name="CountRec" 
	      datasource="AppsLedger" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
		      SELECT GLAccount
		      FROM   TransactionLine
		      WHERE  GLAccount  = '#get.GLAccount#' 
	    </cfquery>
		 
	  	<cfif countRec.recordcount eq "0">
			<input class="button10g" style="height:25;width:140px" type="submit" name="Delete" value="Delete" onclick="return ask()">
		</cfif>
		
		<input class="button10g" style="height:25;width:140px" type="submit" name="Update" value="Update">

</td></tr>

</table>
	
</CFFORM>

<cf_screenbottom layout="webapp">

