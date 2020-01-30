
<cfquery name="Job" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   	 SELECT *
     FROM   Job
	 WHERE  JobNo    = '#URL.ID1#'  
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#Job.Mission#' 
</cfquery>

<cfquery name="Requisition" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    sum(RequestAmountBase) as RequestAmount
	FROM      RequisitionLine 
	<!---  WHERE     ActionStatus IN ('2k','3') --->
	WHERE   ActionStatus != '9'	
	AND     ActionStatus != '0z'				
	AND     JobNo    = '#URL.ID1#' 
	<!--- not needed, based on CICIG report 
	AND     Period   = '#URL.Period#'
	--->
</cfquery>
    
<cfquery name="CheckFunding" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   SUM(QuoteAmountBaseCost) AS Total
	FROM     RequisitionLineQuote
	WHERE    JobNo = '#URL.ID1#' 
	AND      Selected = 1
    AND      RequisitionNo IN 	(SELECT RequisitionNo 
				                 FROM   RequisitionLine 
				                 WHERE  ActionStatus != '9'	
				                 AND    ActionStatus != '0z')
  </cfquery>
  
  <cfoutput>
      
  <table width="99%" cellspacing="0" cellpadding="0" align="center">
  
	  <cfif Parameter.PurchaseExceed neq "" and Requisition.RequestAmount neq "">
		  <cfset ceiling = Requisition.RequestAmount +(Requisition.RequestAmount*Parameter.PurchaseExceed)/100>
	  <cfelse>
	      <cfset ceiling = Requisition.RequestAmount>
	  </cfif>	 
	     
	  <cfif Checkfunding.total gt ceiling>
			  
		  <tr class="line"><td class="line labelmedium" style="height:40" colspan="4" align="center" bgcolor="yellow">		  
		  Awarded amount #NumberFormat(Checkfunding.total, "__,__.__")# exceeds pre-encumbered amount. <b>#SESSION.first#</b> you must request additional funding!
		  </td></tr>
		  	   		  
	  </cfif>
  
  </table>
  
  </cfoutput>	