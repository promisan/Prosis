
<cfif url.mandateNo eq "">


<cfelse>

	<table width="100%">
	
	<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_Mandate 
		WHERE   Mission = '#URL.Mission#'
		AND     MandateNo = '#url.MandateNo#'
	</cfquery>
	
	<cfquery name="Unit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  count(*) as total
		FROM    Organization 
		WHERE   Mission = '#URL.Mission#'
		AND     MandateNo = '#url.MandateNo#'
	</cfquery>
	
	<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  count(*) as total
		FROM    Position 
		WHERE   Mission = '#URL.Mission#'
		AND     MandateNo = '#url.MandateNo#'
		AND     DateExpiration >= '#Mandate.DateExpiration#'
	</cfquery>

	<cfquery name="Extension" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT count(*) as total
	    FROM   PersonExtension
		WHERE  Mission   = '#URL.Mission#'
		AND    MandateNo = '#URL.MandateNo#'		
	</cfquery>
	
	<!--- contracts --->
	
	<cfquery name="Contract" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    count(*) as Total
	FROM      PersonContract PC
	WHERE     Mission = '#URL.Mission#' 
	AND       ActionStatus     = '1' 
	AND       DateExpiration   = '#Mandate.DateExpiration#' <!--- if contract is null is automatically extends itself OR DateExpiration IS NULL) ---> 
	AND       HistoricContract = 0
	AND       PersonNo IN (SELECT PersonNo 
	                       FROM   PersonExtension 
						   WHERE  Mission = '#URL.Mission#'
						   AND    MandateNo = '#URL.MandateNo#')		
	</cfquery>	
	
	
	<cfoutput>
	
	<tr><td></td></tr>
	<tr class="labelmedium">
		<td style="padding-left:10px">
		<b>#Unit.total#</b> units were recorded for this period.</font>
		</td>
	</tr>
	
	<tr class="labelmedium">
		<td style="padding-left:10px">
		<b>#Position.total#</b> positions will be extended.</font>
		</td>
	</tr>
	
	<cfif extension.total eq "0">
	
		<tr class="labelmedium">
		  <td style="padding-left:10px">
		   <font color="FF0000">- No extensions requests were recorded, no assignment records will be carried over.</font>
		  </td>
		</tr>
	
	<cfelse>
	
		<tr class="labelmedium">
		<td style="padding-left:10px">
		<b>#Extension.total#</b> assignment extensions have been requested
		</td></tr>
	
	</cfif>
	
	<tr class="labelmedium">
		<td style="padding-left:10px">
		<b>#Contract.total#</b> contract records will be extended.</font>
		</td>
	</tr>
		
	</cfoutput>
	
	</table>
	
</cfif>	