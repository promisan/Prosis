
<cfinvoke component = "Service.PendingAction.Check"  
	   method           = "#url.Role#"
	   returnvariable   = "Check">	

<table cellspacing="0" cellpadding="0" class="navigation_table">
		
	<cfset cnt = 0>
	<cfset tot = 0>
						
	<cfoutput query="Check">
						
	<cfset cnt = cnt+1>
	
	<cfif url.role eq "procreqreview" or url.role eq "procreqapprove" or url.role eq "procreqbudget">
		<cfset template = "RequisitionClear">
	<cfelseif url.role eq "procreqcertify">	
		<cfset template = "RequisitionCertify">	
	<cfelseif url.role eq "procreqobject">	
		<cfset template = "RequisitionFunding">
	<cfelseif url.role eq "procmanager">	
		<cfset template = "RequisitionBuyer">
	</cfif>
	
	<tr class="hide"><td id="button_#lcase(url.role)#" 
	     onclick="cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/system/entityaction/entityview/MyClearancesBatch.cfm?role=#url.role#','#url.role#box')"></td>
	</tr>
		
	<cfif cnt eq "1">	
								
		    <cfif url.role eq "ProcBuyer">
			<tr class="navigation_row labelmedium" style="cursor: pointer;" 
			onClick="#lcase(url.role)#('#mission#','#period#','#lcase(url.role)#')">
			<cfelse>
			<tr class="navigation_row labelmedium" style="cursor: pointer;" 
			onClick="procbatch('#mission#','#period#','#lcase(url.role)#','#template#')">									
			</cfif>
			
	</cfif>	   
   
	   		<td bgcolor="white" >			
				<cf_space spaces="10">
			</td>
			
			<cf_assignid>
					  
			<td width="20" align="center" style="cursor: pointer">					  
				<cf_space spaces="5">	  
				
	  	  			<img src="#SESSION.root#/Images/contract.gif" alt="" name="img0_#left(rowguid,8)#" 
			  			onMouseOver="document.img0_#left(rowguid,8)#.src='#SESSION.root#/Images/button.jpg'" 
			  			onMouseOut="document.img0_#left(rowguid,8)#.src='#SESSION.root#/Images/contract.gif'"
			  			style="cursor: pointer" alt="" width="13" height="14" border="0" align="absmiddle">	  	
						  
	  		</td>
	  		<td><cf_space spaces="18" class="labelmedium" label="#Mission#"></td>			
	  		<td><cf_space spaces="15" class="labelmedium" label="#Period#"></td>	 
	   		<td style="padding-right:4px"><cf_space align="right" class="labelmedium" color="red" spaces="8" label="#Total#"></td>	
			
			<cfset tot = tot + total>
			 		
	<cfif cnt eq "1">  
		</tr>	
	<cfset cnt = 0>
	</cfif>	
	</cfoutput>	
		
</table>

<!---

<cfoutput>
<script>
	_cf_loadingtexthtml='';
	ColdFusion.navigate('getSummary.cfm?mode=batch&overall=#tot#','summarybatch')
</script>
</cfoutput>
--->



<cfset ajaxonload("doHighlight")>