
<script>

function listing(box,ent,code,act) {

	icM  = document.getElementById("d"+box+"Min")
    icE  = document.getElementById("d"+box+"Exp")
	se   = document.getElementById("d"+box);
	 		 
	if (se.className == "hide") {	 	
     	 icM.className = "regular";
	     icE.className = "hide";
		 se.className  = "regular";	
	 } else {
	   	 icM.className = "hide";
	     icE.className = "regular";
		 se.className  = "hide";
	 }
		 		
  }
  
</script>  

<table width="100%" class="navigation_table">

<cfoutput query = "Summary">
	   
	    <cfif counted gt "0">
		
		  <tr class="line fixrow"><td colspan="1" height="20" width="5%" align="center">
		  		
		    <cfif url.mode neq "Print">
		   
			<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
				id="d#CurrentRow#Exp" border="0" class="show" 
				align="middle" style="cursor: pointer;" 
				onClick="listing('#CurrentRow#','','#PostOrderBudget#','show')">
				
			<img src="#SESSION.root#/Images/arrowdown.gif" 
				id="d#CurrentRow#Min" alt="" border="0" 
				align="middle" class="hide" style="cursor: pointer;" 
				onClick="listing('#CurrentRow#','','#PostOrderBudget#','hide')">
				
			</cfif>	
							
			</td>
			<td style="height:34;font-size:18" colspan="3">				
				<a href="javascript:listing('#CurrentRow#','','#PostOrderBudget#','show')" title="Expand">
				#PostGradeBudget# [#counted#]
				</a>				
			</td>
		</tr>
				  			
		<tr>
		
		<td colspan="1" width="5%" align="center"></td>
		
		<td colspan="3" align="center" id="d#CurrentRow#">
		
			<cfset URL.EntityCode = "">
			<cfset URL.Code       = PostGradeBudget>			
			<cfinclude template   = "ControlListingResultGradeDetail.cfm">
	    </td>
		
		</tr>
					
		</cfif> 
	   			
	</cfoutput>
	
</table>	
