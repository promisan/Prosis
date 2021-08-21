
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">

<table width="100%" height="100%" align="center" class="tree formpadding" >

<tr><td valign="top" style="padding-left:5px">

	<form method="POST" name="receipt">

    <table width="100%" class="formpadding">	
	
	 <cfquery name="Period" 
	      datasource="AppsProgram" 
    	  username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT  R.*, M.MandateNo 
	      FROM    Ref_Period R, 
		          Organization.dbo.Ref_MissionPeriod M
	      WHERE   IncludeListing = 1
		  AND     R.Period IN (SELECT Period as Period
		                       FROM Purchase.dbo.Purchase
							   UNION 
							   SELECT DefaultPeriod as Period
							   FROM Purchase.dbo.Ref_ParameterMission 
							   WHERE Mission = '#URL.Mission#'
							   )
							   
	      AND     M.Mission = '#URL.Mission#'
	      AND    R.Period = M.Period
      </cfquery>	
	  
	  <cfif Period.recordcount eq "0">
	  
	 	 <tr><td align="center" class="labelit" height="90"><font color="FF0000">No purchase records recorded<br>Function is not operational</font></td></tr>
	  
	  <cfelse>
   	 	 
	  <cfoutput>
	  
		<cfquery name="RequisitionCheck" 
	      datasource="AppsPurchase" 
    	  username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
				SELECT  *
				FROM    PurchaseLineReceipt RCT INNER JOIN
                        RequisitionLine R ON RCT.RequisitionNo = R.RequisitionNo
				WHERE   R.Mission = '#url.mission#' 
				AND     R.ActionStatus = '9'  
				AND     RCT.ReceiptId IN
                          (SELECT     ReceiptId
                            FROM          Materials.dbo.ItemTransaction
                            WHERE      ReceiptId = RCT.ReceiptId)
		</cfquery>					
		
		<cfif RequisitionCheck.recordcount gte 1>
			<tr><td class="labelit"><font color="FF9966">Detected receipts for cancelled requisitions. <br><br>Contact your administrator</font></td></tr>
			<tr><td class="linedotted"></td></tr>
		</cfif>
	
		<cfquery name="ReceiptCheck" 
	      datasource="AppsPurchase" 
    	  username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
				SELECT  *
				FROM    PurchaseLineReceipt RCT INNER JOIN
                        RequisitionLine R ON RCT.RequisitionNo = R.RequisitionNo
				WHERE   R.Mission = '#url.mission#' 
				AND     RCT.ActionStatus = '9'  
				AND     RCT.ReceiptId IN
                          (SELECT     ReceiptId
                            FROM      Materials.dbo.ItemTransaction
                            WHERE     ReceiptId = RCT.ReceiptId)
		</cfquery>					
		
	  <cfif receiptCheck.recordcount gte 1>
		<tr class="line"><td class="labelmedium" style="padding-left:4px"><font color="FF0000">Alter posted but cancelled receipts. <br>Contact your administrator</font></td></tr>			
	  </cfif>
				
	  <tr>
	     <td height="20" style="padding-left:4px;font-size:16px" class="labelmedium2"><a href="javascript:newreceipt();"><cf_tl id="Record new receipts"></a></td>
	  </tr>					  
	  <tr>
	     <td height="20" style="padding-left:4px;font-size:16px" class="labelmedium2"><a href="javascript:newSearch();"><cf_tl id="Extended search"></a></td>
	  </tr>
	  
	  <tr><td height="2"></td></tr>
	  
	  <tr><td class="line"></td></tr>
		
	  </cfoutput>
		
	  <cfif url.period eq "">
	     <cfset url.period = period.period>
	  </cfif>
	  
	   <tr> 
			 <td valign="top" height="20" style="padding-left:4px">
	 
			 <table width="100%" cellspacing="0" cellpadding="0">
		  		   
			      <cfset PNo = 0>
				  <cfset row = 0>
			  
			      <cfoutput query = "Period"> 
				  
				  	  <cfset row = row+1> 
					  <cfset PNo = PNo+1>
				       <cfif row eq "1"><tr class="labelmedium"></cfif>
				      <td id="Period#PNo#" style="padding:2px;<cfif URL.Period eq Period>font='bold'</cfif>"> 
					  <input type="radio" class="radiol" name="Period" id="Period" value="#Period#" 
						onClick="clearrows('Period',#Period.RecordCount#);Period#PNo#.style.fontWeight='bold';updatePeriod(this.value,'#MandateNo#')"
						<cfif URL.Period eq Period>Checked</cfif>>&nbsp;#Description#&nbsp;
				        	<cfif URL.Period eq Period>
							<input type="hidden" name="PeriodSelect" id="PeriodSelect" value="#Period#">
							<cfset CLIENT.period         = "#Period#">
							<input type="hidden" name="MandateNo" id="MandateNo" value="#MandateNo#">
							<cfset CLIENT.mandateNo      = "#MandateNo#">				
						</cfif>
					  </td>
				      <cfif row eq "2"></tr><cfset row="0"></cfif>
				  
			      </cfoutput> 
				  
			  </table> 	  
	  
		  </td>
		  
      </tr>
  	 		
	  <tr><td class="line"></td></tr>	
			
	  <tr><td valign="top" style="padding-top:4px">
	  	  	   
	   <cf_receiptTreeData	
		    iconpath="#SESSION.root#/Tools/Treeview/Images" 
			mission = "#URL.Mission#"
			systemfunctionid="#url.systemfunctionid#"
			destination = "PurchaseViewOpen.cfm">
			
	 </td></tr>	
	 
	   <tr><td class="line"></td></tr>	
	 
	 </cfif>
	 
	 </form>
	 
	</table>	
	
  </td>
  </tr>		
	
</table> 	  


	