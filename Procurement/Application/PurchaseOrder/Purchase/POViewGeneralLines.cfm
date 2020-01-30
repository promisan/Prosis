
 <script>
	 Prosis.busy('no');
 </script> 
 
<cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase 
		WHERE  PurchaseNo ='#URL.Id1#' 
		AND    PurchaseNo IN (SELECT PurchaseNo FROM PurchaseLine)
</cfquery>	

<cfinvoke component="Service.Access"
	   Method="procApprover"
	   OrgUnit="#PO.OrgUnit#"
	   OrderClass="#PO.OrderClass#"
	   ReturnVariable="ApprovalAccess">	

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 		
</cfquery>


<table width="100%" align="center">
	 
      <tr><td>
	  
	  <cfif Parameter.InvoiceRequisition eq "1">		    	  
	    <cfinclude template="POViewLines_Balance.cfm">		
	  <cfelse>  	  
	    <cfinclude template="POViewLines_Regular.cfm"> 		
	  </cfif>	
	  
	  </td></tr>		  			   
	 			 
	  <cfif delete eq "1" and url.mode eq "edit">
		
		  <cfif (URL.Sort eq "Line" and PO.ActionStatus lte "3" and URL.Mode eq "Edit") 
		      or 
		    
			((getAdministrator(PO.mission) eq "1") and check.recordcount eq "0")>
			
			<tr>
				<td height="30" align="right" style="padding-right:4px">
				<input class="button10g" type="submit" style="width:150;height:25" name="Remove" id="Remove" value="Remove Selected">				
				</td>
			</tr>
			
		  </cfif>
	  </cfif>	  
	  
 </table>
 
 <script>
	 Prosis.busy('no');
 </script>