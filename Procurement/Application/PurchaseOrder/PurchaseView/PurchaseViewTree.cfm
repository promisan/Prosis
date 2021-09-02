
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#'
</cfquery>

<cfparam name="URL.role" default="">
<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">

<cf_divscroll style="height:100%">

<table width="95%" align="center">

	 <cfoutput>
	  
     <tr><td height="7"></td></tr>		  			
		   
     <tr>			
		<td class="labelmedium" style="height:36px;padding-left:9px;font-size:18px">			
		<a href="javascript:ptoken.open('PurchaseViewOpen.cfm?ID1=Locate&ID=LOC&Mission=#url.Mission#','right')"><cf_tl id="Extended Search"></a>
		</td>
	 </tr>
		  
	 <tr><td class="linedotted"></td></tr>
	
	 <tr>
		<td class="labelmedium" style="height:36px;padding-left:9px;font-size:18px">		
		 <a href="javascript:ptoken.open('PurchaseViewOpen.cfm?ID1=2&ID=PEN&Mission=#url.Mission#','right')"><cf_tl id="Pending for Approval"></a>	  			
		</td>
	 </tr>	 
			 
	 </cfoutput>
	  
	 <tr><td height="1" class="line"></td></tr>	
	
	 <cfquery name="Period" 
	      datasource="AppsProgram" 
    	  username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT R.*, M.MandateNo 
	      FROM   Ref_Period R, 
		         Organization.dbo.Ref_MissionPeriod M
	      WHERE  IncludeListing = 1
		  
		  AND    R.Period IN (SELECT Period as Period
		                      FROM   Purchase.dbo.RequisitionLine
						      UNION 
							  SELECT DefaultPeriod as Period
							  FROM   Purchase.dbo.Ref_ParameterMission 
							  WHERE  Mission = '#URL.Mission#'
							   )
							   
	      AND    M.Mission = '#URL.Mission#'
	      AND    R.Period = M.Period
      </cfquery>
	  
	  <cfif url.period eq "">
	   <cfset url.period = period.period>
	  </cfif>
	 
      <tr>
      <td height="30" style="padding:7px">
	 
	  <table width="100%" cellspacing="0" cellpadding="0">
			 		   
      <cfset PNo = 0>
	  <cfset row = 0>
	  
	  <cfoutput query = "Period"> 
	  
	  	 <cfset row = row+1>
		 <cfset PNo = PNo+1>
	     <cfif row eq "1"><tr class="labelmedium"></cfif>
		  		  
	      <td id="Period#PNo#" style="padding-left:7px;padding:1px;<cfif URL.Period eq Period>font:'bold'</cfif>"> 
		  <input type="radio" class="radiol" name="Period" id="Period" value="#Period#" 
			onClick="peri('#Period#','#MandateNo#','#URL.role#')"
			
			<cfif URL.Period eq Period>Checked</cfif>>&nbsp;#Description#&nbsp;
	        	<cfif URL.Period eq Period>		
				<input type="hidden" id="PeriodSelect" name="PeriodSelect" value="#Period#">
				<cfset CLIENT.period   = "#Period#">
				<input type="hidden" id="MandateNo" name="MandateNo" value="#MandateNo#">
				<cfset CLIENT.mandateNo = "#MandateNo#">
										
			</cfif>
			
		  </td>
	      <cfif row eq "2"></tr><cfset row="0"></cfif>
	  
      </cfoutput> 
  	  </table> 	  
	  
	  </td>
      </tr>
	  
	  <tr><td height="1" class="line"></td></tr>	
	  
	  <cfif Period.recordcount eq "0">
	  
	  <tr><td height="40" align="center"><font face="Calibri" size="2"><i><cf_tl id="No periods found"></font></td></tr>
	  
	  <cfelse>
	 			
	  <tr><td style="padding-top:9px; padding-left:5px">	  	   
		    <cf_PurchaseTreeData
			 mission     = "#URL.Mission#"
			 period      = "#URL.Period#"
			 destination = "PurchaseViewOpen.cfm">
			
	 </td></tr>	
	 
	 </cfif>
	 
	 <tr><td height="1" class="linedotted"></td></tr>
			 
     </td></tr>
	 
</table>	
 	 

</cf_divscroll>

