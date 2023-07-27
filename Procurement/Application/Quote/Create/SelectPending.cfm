
<!--- ---------- --->
<!--- safe guard --->
<!--- ---------- --->

<cfquery name="Reset" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE RequisitionLine 
	SET    ActionStatus = '2k'	
	WHERE  RequisitionNo NOT IN (SELECT RequisitionNo 
	                             FROM   PurchaseLine 
								 WHERE  RequisitionNo = RequisitionLine.RequisitionNo)
	AND    ActionStatus = '3' 
</cfquery>

<!--- ---------- --->

<cfparam name="url.search"       default="">
<cfparam name="url.fun"          default="">
<cfparam name="url.fund"         default="">
<cfparam name="url.unit"         default="">
<cfparam name="url.annotationid" default="">	
<cfparam name="url.page"         default="1">	
<cfparam name="url.mode"         default="Pending">

<table width="100%" height="100%">
		
	<tr>
			
	   <cf_tl id="REQ056" var="1">
	   <cfset vReq056=lt_text>		
	   <td colspan="2" width="90%" style="height:50px;font-size:20px;font-weight:bold" class="labelmedium"><cfoutput>#url.period#: #vReq056#</cfoutput>:</td>
	 		   
	</tr>
			
	<tr><td colspan="2" height="100%">
	
		<table width="100%" height="100%">
			
			<tr><td style="height:100%" valign="top">	
						
			<form method="post" name="jobreq" id="jobreq" style="height:100%">
			
			<input type="hidden" id="reqno" name="reqno">
			
			<cf_securediv id="pending" style="height:100%;" 
			  bind="url:SelectLines.cfm?mode=#mode#&page=#url.page#&annotationid=#url.annotationid#&mission=#url.mission#&period=#url.period#&search=#url.search#&fun=#url.fun#&fund=#url.fund#&unit=#url.unit#">	
			  
			</form>
							
			</td></tr>
			
		</table>
	
	</td></tr>
	
</table>