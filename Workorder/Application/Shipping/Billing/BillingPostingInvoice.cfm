
<cfoutput>

<table width="97%" class="formspacing" align="center">

 <tr><td height="10"></td></tr>
 <tr class="labelmedium2">
 
 	<cf_calendarscript>
	
	<td width="60"><cf_tl id="Journal">:</td>
 	<td style="padding-left:4px">							
	
	<select name="Journal" class="regularxxl" style="width:200px">
		 <cfloop query="journal">
		 <option value="#Journal#" <cfif journal eq serviceitem.journal>selected</cfif>>#Journal# - #Description#</option>
		 </cfloop>
	</select>

    </td>
	
	<td width="60" style="min-width:140px"><cf_tl id="Date">:</td>
	<td style="padding-left:3px;min-width:120px">
	 			 
	 <cf_intelliCalendarDate9
		FieldName="TransactionDate" 
		Class="regularxxl"
		Default="#dateformat(now(),client.dateformatshow)#"
		AllowBlank="False">	
	  
	</td>
	</tr>	
	
	<tr class="labelmedium2">
	
	<td width="60" style="min-width:100px"><cf_tl id="Account Period">:</td>
	<td width="60" style="padding-left:3px">
											
	<cfquery name="PeriodList" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  	SELECT   *
			FROM     Period
			WHERE    AccountPeriod IN (SELECT AccountPeriod 
			                           FROM   Organization.dbo.Ref_MissionPeriod 
									   WHERE  Mission = '#workorder.mission#')
			AND      ActionStatus = '0'		
	</cfquery>  						
	
	<select name="AccountPeriod" class="regularxxl">
		 <cfloop query="PeriodList">
		 	<option value="#AccountPeriod#" <cfif param.currentaccountperiod eq Accountperiod>selected</cfif>>#AccountPeriod#</option>
		 </cfloop>
	</select>
	
	</td>
	
	
 	
			
	<td width="60"><cf_tl id="Owner">:</td>
						
	<!--- show only the last parent org structure --->
 
	   <cfquery name="Owner" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	      SELECT    DISTINCT TreeOrder,
		            OrgUnitName,
					OrgUnit,
					OrgUnitCode 
	      FROM      #Client.LanPrefix#Organization
	   	  WHERE     (
		             ParentOrgUnit is NULL OR ParentOrgUnit = '' OR Autonomous = 1 
					)							 
		  AND       Mission     = '#workorder.Mission#'
		  AND       MandateNo   = '#getMandate.MandateNo#'
		  
		  <!---
		  <cfif getAdministrator(workorder.mission) eq "1">

			<!--- no filtering --->
		
		  <cfelse>
		  AND       ( 
		            OrgUnit IN (SELECT OrgUnit 
		                        FROM   Organization.dbo.OrganizationAuthorization 
								WHERE  Role = 'ProcApprover' 
								AND    UserAccount = '#session.acc#' 
								AND    AccessLevel != '0') 
					OR 
					OrgUnit = '#Invoice.OrgUnitOwner#' 
					OR
				Mission IN (SELECT Mission 
		                        FROM   Organization.dbo.OrganizationAuthorization 
								WHERE  Role = 'ProcApprover' 
								AND    OrgUnit is NULL
								AND    UserAccount = '#session.acc#' 
								AND    AccessLevel != '0') 
					)			
		  </cfif>		
		  --->
		  
		  
		  ORDER BY  TreeOrder, OrgUnitName
	 </cfquery>
	 
	<td style="padding-left:3px">
	 			 
	  <select name="OrgUnitOwner" id="OrgUnitOwner" class="regularxxl" style="width: 200px;">				     
	    <cfloop query="Owner">
   		   	  <option value="#OrgUnit#">#OrgUnitName#</option>
       	    </cfloop>  
            </select>	
	  
	</td>	
	
	</tr>
	
	<tr>
	
	<td width="90" ><cf_tl id="Issued InvoiceNo">:</td>
	<td style="padding-left:3px">
	 	
		<input type="text" name="ActionReference2" value="" class="regularxl" style="width:35"  maxlength="4">
		<input type="text" name="ActionReference1" value="" class="regularxl" style="width:160" maxlength="14">
			  
	</td>
							
	<td width="60"><cf_tl id="Memo">:</td>
	<td colspan="3" style="padding-left:3px">
	<input type="text" name="Memo" value="" class="regularxxl" style="width:100%" maxlength="100">
	</td>
	
     </tr>
	 
	 <tr><td height="5"></td></tr>
	 
</table>

</cfoutput>