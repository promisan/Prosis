
<cfparam name="url.ent" default="">
<cfparam name="url.trg" default="">

<cfset dateValue = "">
<CF_DateConvert Value="#url.eff#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif url.exp neq ''>
    <CF_DateConvert Value="#url.exp#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfquery name="get" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_PayrollTrigger 
	WHERE  SalaryTrigger   = '#url.trg#'  	
</cfquery>

<cftry>
	
	<cfquery name="Select" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   PersonEntitlement T 	
		WHERE  Status    != '9'
		AND    PersonNo    = '#URL.ID#' 
		<cfif url.trg neq "">
			AND T.SalaryTrigger   = '#url.trg#' 
		<cfelse>
			AND T.PayrollItem = '#URL.ent#' 
		</cfif>
		AND    (
		      	(DateExpiration >= #STR# AND DateEffective <= #STR#)  OR 
			 	(DateEffective <= #END#  AND DateExpiration >= #END#) OR
			    (DateExpiration is NULL  OR  DateExpiration = '')
			   ) 	
	</cfquery>
	
	
	
	<script>
	
		try {
		<cfif get.RecordCount gte 1>
			<cfif get.enablePeriod eq "1">			    
				document.getElementById('expiration').className = "regular labelmedium"
			<cfelse>	
				document.getElementById('expiration').className = "hide"
			</cfif>
		<cfelse>
			document.getElementById('expiration').className     = "regular labelmedium"
		</cfif>
		 } catch(e) {}
		
	</script>
			
	<cfif select.recordcount gte "1">
		
		<table width="100%">
		
		<tr class="line">
		<td>
			
			<table width="100%" align="center" class="navigation_table">
			
			<TR class="labelmedium line">
			    <td><cf_tl id="Status"></td>
				<td><cf_tl id="Dependent"></td>
			    <td><cf_tl id="Effective"></td>
				<TD><cf_tl id="Expiration"></TD>
				<TD><cf_tl id="Schedule"></TD>
				<TD align="right"><cf_tl id="Period"></TD>
				<TD align="right"><cf_tl id="Amount"></TD>	
				<td align="right" style="padding-right:4px"><cf_tl id="End"></td>
			</TR>
			
			<cfoutput query="select">
			
			<TR class="labelmedium line navigation_row">
				
				<td style="padding-left:5px"><cfif Status eq "2"><cf_tl id="Approved"><cfelse><cf_tl id="Pending"></cfif></td>
				<td>
				
				<cfquery name="dependent" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   PersonDependent 
					WHERE  DependentId   = '#dependentid#'  	
				</cfquery>
				
				#Dependent.FirstName#
				
				</td>
				<td>#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
				<td><cfif #Dateformat(DateExpiration, CLIENT.DateFormatShow)# eq "">End of contract<cfelse>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</cfif> </td>
				<TD>#SalarySchedule#</TD>
				<cfif EntitlementClass eq "Amount">
					<TD align="right" style="padding-right:4px">#Period#</TD>
					<TD align="right">#Currency# #NumberFormat(Amount, ".__")#</TD>
				<cfelseif enableAmount eq "1">
					<TD align="right" style="padding-right:4px"></TD>
					<TD align="right">#Currency# #NumberFormat(Amount, ".__")#</TD>	
				<cfelseif ContractId neq "">
					<TD colspan="2"><cf_tl id="Contract defined"></TD>
				</cfif>
				<td align="right">
				<table>
					<tr class="labelmedium">
					<td style="padding-left:20px;min-width:100px"><font color="FF0000"><cf_tl id="Terminate">:</font></td>
					<td style="padding-left:3px;padding-right:5px"><input type="checkbox" name="terminate" value="#EntitlementId#"></td>
					</tr>
				</table>
				</td>
				
			</tr>
			
			</cfoutput>
			
			</table>
		</td>	
		</tr>
		
		</table>
	
	</cfif>

	<cfcatch>
	
	<table width="100%" align="center">
	   <tr class="line"><td align="center" class="labelmedium"><font color="FF0000"><cf_tl id="Incorrect date recorded"></font></td></tr>
     </table>	
	
	</cfcatch>
	
	</cftry>
	
	<cfset ajaxonload("doHighlight")>