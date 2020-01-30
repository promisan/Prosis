
<cfparam name="url.scope" default="standard">
<cfparam name="url.mode"  default="Total">

<cfoutput>	

<cfif url.mode eq "Total">

		<cfparam name="url.start" default="1">
	    <cfparam name="url.lines" default="1">

	    <cftry>
	
			<cfset tot = "">
		
		    <cfloop index="itm" from="#start#" to="#url.lines#">
			
			    <cfset qty = evaluate("url.resource_#itm#")>
				<cfset day = evaluate("url.day_#itm#")>
				
				<cfset prc = replace(url.price,',','',"ALL")>
				
				<cfif day neq "" and qty neq "">
				
					<cfif tot eq "">				    
						<cfset tot = prc*qty*day>	
					<cfelse>					
					    <cfset tot = tot+(prc*qty*day)>
					</cfif>	
					
					<cfif url.scope eq "standard">
															
						<div id="total_display_#itm#" style="padding-top:3px;font-size:15">#numberformat(prc*qty*day,",__.__")#</div>
					
					</cfif>
										
					<script language="JavaScript">
						 
						 try {						   
							  document.getElementById("requestamountbase_#itm#").value = "#prc*qty*day#"
							  ItemTotalCalculate(#tot#, #itm#)							  
						 } catch(e) {} 
						 
					</script>	
					
				</cfif>	
				
			</cfloop>
			
			<cfif url.scope eq "period">				
				<div id="total_display" style="padding-top:3px;font-size:15">#numberformat(tot,",__.__")#</div>
			</cfif>
			
			<script language="JavaScript">
			  try {
				  document.getElementById("requestamountbase_#url.lines#").value = "#tot#"
			   } catch(e) {}  
			</script>	
							
		<cfcatch>
			
			<font color="FF0000" style="font-size:15;padding-top:3px">n/a</font>
			
		</cfcatch>
		
	</cftry>	
	
<cfelseif url.mode eq "Quantity">

	<cfparam name="url.start" default="1">	
	<cfparam name="url.lines" default="1">
	
	<cftry>
	
		<cfset tot = "">
	
	    <cfloop index="itm" from="#url.start#" to="#url.lines#">
		
		    <cfset qty = evaluate("url.resource_#itm#")>
			<cfset day = evaluate("url.day_#itm#")>

			<cfif day neq "" and qty neq "">
			
				<cfif tot eq "">				    
					<cfset tot = qty*day>	
				<cfelse>					
				    <cfset tot = tot+(qty*day)>
				</cfif>	
				
				<cfif url.scope eq "standard">											
				    <div id="quantity_display_#itm#" style="padding-top:3px;font-size:14">#numberformat(qty*day,",__")#</div>	
				</cfif>	
																
				<input type="hidden" name="requestquantity_#itm#" id="requestquantity_#itm#" value="#numberformat(qty*day,",__")#">	
															
			</cfif>	
			
		</cfloop>
		
		<cfif url.scope eq "period">	
			<div id="total_display" style="font-size:15">#numberformat(tot,",__.__")#</div>
			<input type="hidden" name="requestquantity_sum" id="requestquantity_sum" value="#numberformat(tot,",__")#">	
		</cfif>	
								
		<cfcatch>
		
			<font color="FF0000" style="font-size:14">n/a
			
		</cfcatch>
		
	</cftry>	
	
<cfelse>

	<!--- period line subtotal handling only --->
	
	<cfparam name="url.line" default="1">
	<cfparam name="url.resource" default="0">
	<cfparam name="url.day" default="0">
	
	<cftry>	
		<cfset qty = url.Resource*url.Day>	
		<cfcatch>
			<cfset qty = "0">
		</cfcatch>
	</cftry>	
			
	<input type="text" class="regularh"  size="10" tabindex="9999" style="background-color:f1f1f1;text-align:right;width:99%;border:0px" readonly id="requestquantity_#url.line#" name="requestquantity_#url.line#" value="#numberformat(qty,",__")#" tabindex="999">	
		

</cfif>

</cfoutput>	

