
<cfquery name="Parameter" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM Ref_ParameterMission
	  WHERE Mission = '#URL.Mission#'
</cfquery>

<cfparam name="URL.Period" default="#Parameter.DefaultPeriod#">
<cfparam name="URL.Role" default="">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white">

<tr><td valign="top">

<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">


<tr><td height="5"></td></tr>

 <cfquery name="Period" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT R.*, M.MandateNo 
      FROM   Ref_Period R, Organization.dbo.Ref_MissionPeriod M
      WHERE  IncludeListing = 1
      AND    M.Mission = '#URL.Mission#'
      AND    R.Period = M.Period 
	  AND    (
	         R.Period IN (SELECT Period 
	                      FROM Purchase.dbo.Purchase 
						  WHERE Mission = '#URL.Mission#') 
				  OR R.Period = '#Parameter.DefaultPeriod#'
			
			 )	  
      </cfquery>

<cfif Period.recordcount neq "0">

	  <cfinvoke component = "Service.Access"  
	   method           = "createwfobject" 
	   entitycode       = "ProcInvoice"
	   mission          = "#url.mission#"
	   returnvariable   = "accesscreate">   
	   
	  <cfif accesscreate eq "EDIT" or accesscreate eq "ALL">	   
	 	  
			<cfoutput>
			 <tr>
			  <td>
			    <table width="100%">		
					<tr>			     
				        <td width="45%" class="labelmedium" style="font-size:18px;padding-left:5px">
					    <a href="javascript:newinvoice()"><cf_tl id="Record Incoming Invoice"></a>
						</td>
				    </tr>
					<tr><td height="6"></td></tr>
					<tr><td height="1" colspan="2" class="line"></td></tr>
				</table>
			  </td>
			 </tr>
			</cfoutput>
			
	  </cfif>	

</cfif>

<tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
	  
	  <cfif Period.recordcount eq "0">
	  
		  <tr>
	      	<td id="Period#PNo#" align="center" height="60" class="labelit"> 
			  <cf_tl id="No purchase orders recorded">.
			</td>
		  </tr>
	 
	  <cfelse>
		 	 		   
		      <cfset PNo = 0>
		      <cfset row = 0>
			 
			 <tr> 
			 <td valign="top" height="20" style="padding-left:4px">
	 
			 <table width="100%" cellspacing="0" cellpadding="0">
			  
		      <cfoutput query = "Period"> 
			  
			       <cfset row = row+1>
			       <cfset PNo = PNo+1>
		      
				   <cfif row eq "1"><tr></cfif>
			       <td id="Period#PNo#" class="labelit" style="padding:3px;<cfif URL.Period eq Period>font='bold'</cfif>"> 
				  <input type="radio" name="Period" id="Period" value="#Period#" 
					onClick="Period#PNo#.style.fontWeight='bold';updatePeriod(this.value,'#MandateNo#','#URL.role#')"
					<cfif URL.Period eq Period>Checked</cfif>>&nbsp;#Description#&nbsp;
			        <cfif URL.Period eq Period>
						<input type="hidden" name="PeriodSelect" id="PeriodSelect" value="#Period#">
						<cfset CLIENT.period = "#Period#">
						<input type="hidden" name="MandateNo"    id="MandateNo"   value="#MandateNo#">
						<cfset CLIENT.mandateNo= "#MandateNo#">			
					</cfif>
				  </td>
			      <cfif row eq "2"></tr><cfset row="0"></cfif>
			  
		      </cfoutput> 
			  
			  </table>
			  </td>
			  </tr>
		  	   
			  <tr><td height="5"></td></tr>
			   	 
			   <tr><td height="1" class="linedotted"></td></tr>
			  
			  <tr><td height="5"></td></tr>
					
			  <tr><td>
			  
		  	   <cf_InvoiceTreeData	
			    	iconpath="#SESSION.root#/Tools/Treeview/Images" 
					mission = "#URL.Mission#"
					systemfunctionid="#url.systemfunctionid#">	
				
			  </td></tr>	
				 
		    
		  
		</cfif>  
	   
	</table>	

	</td></tr>
		
	
</table>	

</td></tr>

</table>
