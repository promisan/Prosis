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

<cfsavecontent variable="option">
	<cfoutput>Fiscal Year:<font face="Verdana" size="4"> #url.Year# <font face="Verdana" size="2">Activity: <font face="Verdana" size="4">#url.activity#
	&nbsp;<a href="javascript:window.print()"><font size="2" color="0080C0">[Print]</a>
	</cfoutput>
</cfsavecontent>

<cfif url.mission eq "undefined">
   
   Please contact administrator to resolve this problem
   <cfabort>
   
</cfif>

<cf_listingscript>

<cf_screentop height="100%" html="Yes" validatesession="No" layout="webapp" line="no" banner="gradient" option="#option#" scroll="Yes" label="IMIS Budget Detail">

  <!--- custom --->

  <cfquery name="getPeriod" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   P.*
		FROM     Ref_AllotmentEdition R, Ref_Period P 
		WHERE    R.Period = P.Period 	
		AND      R.EditionId = '#url.Editionid#'			
 </cfquery>
 
 
  <cfquery name="getProgram" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ProgramPeriod 
		WHERE    ProgramCode = '#url.programcode#'
		AND      Period = '#getPeriod.Period#'				
 </cfquery>
 
 <cfif getProgram.recordcount eq "0">
 
 	<cfset ref = "#url.activity#">
	
 <cfelse>
 
	<cfset ref = "#getProgram.Reference#">
 
 </cfif>
 
 <!--- component --->
 
 <!---  unithierarchy    = "#url.unithierarchy#" --->
 
 <!--- --------invoices processed outside -------- --->		
	<cfinvoke component = "Service.Process.Program.IMIS"  
		   method           = "IMIS" 
		   mission          = "#url.mission#"		   
		   editionid        = "#url.editionid#"
		   Fund             = "#url.fund#"		
		   Content          = "detail"
		   AccountPeriod    = "'#url.year#','#url.year+1#'"	  
		   period           = "'#getPeriod.Period#'" 		   		  
		   ProgramCode      = "#ref#"
		   Resource         = "#url.Resource#" 
		   Object           = "#url.Object#"		   
		   mode             = "table"
		   table            = "#SESSION.acc#IMIS">		
 

 <cfquery name="IMIS" 
    datasource="AppsPurchase" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">	
		
	SELECT   Fund, 
	         Service, 
			 Class, 
			 Object, 
			 objc_descr,
			 ROUND(SUM(ExpenditureAmount), 2) AS Amount
 		
	FROM     userquery.dbo.#SESSION.acc#IMIS
		
	GROUP BY Fund, Service, Class, Object, objc_descr
	ORDER BY Fund, Service, Class, Object, objc_descr
	
</cfquery>	

<cf_menuScript>

<table width="96%" height="100%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td height="40">

		<!--- top menu --->
				
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">		  		
						
			<cfset ht = "26">
			<cfset wd = "27">
					
			<tr>				
									
				<cf_menutab item       = "1" 
				      iconsrc    = "Logos/Accounting/Summary.png" 
					  iconwidth  = "#wd#" 
					  iconheight = "#ht#" 
					  class      = "highlight1"
					  name       = "Summary"
					  source     = "">			
					
				<cf_menutab item       = "2" 
			          iconsrc    = "Logos/Accounting/Transaction.png" 
					  iconwidth  = "#wd#" 
					  iconheight = "#ht#" 
					  class      = "regular"
					  name       = "Details"
					  source     = "">			
														
					<td width="20%"></td>								 		
			</tr>
			
		</table>

	</td>
</tr>

<tr><td colspan="6" class="linedotted"></td></tr>

<tr><td height="100%" valign="top">

	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0" 
		  align="center">	 		
			
			<cf_menucontainer item="1" class="regular">			
			
					<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
				
					<tr><td class="labellarge" style="padding-left:4px;height:35"><b>Summary by Fund and Object</td></tr>
				
					<tr><td height="40">
					
						<table width="100%" cellspacing="0" cellpadding="0" class="formpadding" style="border:1px dotted gray">
						<tr>
						  <td class="labelit">Fund</td>
						  <td class="labelit">Service</td>
						  <td class="labelit">Class</td>
						  <td class="labelit">Object</td>
						  <td class="labelit">Name</td>
						  <td class="labelit">Amount</td>
						</tr>		
						
						<tr><td colspan="6" class="linedotted"></td></tr>
						
						<cfoutput query="IMIS" group="fund">
						
						<cfquery name="qFund" dbtype="query">
						    SELECT SUM(Amount) as Total
							FROM   IMIS
							WHERE  Fund = '#Fund#'
						</cfquery>
						
						<TR bgcolor="f4f4f4"> 
						  <td style="padding:2px;height:26" class="labelmedium">#Fund#</td>
						  <td align="center"></td>
						  <td align="center"></td>
						  <td align="center"></td>
						  <td align="center"></td>
						  <td style="padding-right:5px" align="right" class="labelmedium">#numberformat(qFund.total,'__,__.__')#</b></td>
						</tr>
						<cfoutput>
						<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffff'))#"> 
						  <td align="center"><!---#Fund#---></td>
						  <td class="labelit">#Service#</td>
						  <td class="labelit">#Class#</td>
						  <td class="labelit">#Object#</td>
						  <td class="labelit">#objc_descr#</td>
						  <td align="right" class="labelit" style="padding-right:10px">#numberformat(Amount,'__,__.__')#</td>
						</tr>			
						<tr><td></td><td colspan="5" class="linedotted"></td></tr>			
						</cfoutput>
						
						</cfoutput>
						</table>
					
					</td>
				  </tr>
				  
				</table>		
			
			<cf_menucontainer>
			
			
			<cf_menucontainer item="2" class="hide">			
				  <cfinclude template="IMISContent.cfm">				
			</cf_menucontainer>
			

<tr><td height="4"></td></tr>

</table>

</tr>

</table>