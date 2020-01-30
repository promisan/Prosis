
<cfparam name="Form.Selected" default="-0.0001" >
<cfparam name="form.off_"     default="-0.0001" >

<cfset val = 0>

<cfloop index="itm" list="#form.Selected#">	
    <cfset amt = evaluate("form.off_#left(itm,8)#")>
	<cfset amt = replace("#amt#",",","","ALL")>
	<cfset amt = val(amt)>
	<cfset val = val + amt>		
</cfloop>
			  
<cfoutput>								
		  	
	<table align="right">
	
		<tr class="labelmedium">
		
			<td>
			
				<cfif abs(val) gte "0.001">			
				 <cf_tl id="Apply" var="1">		
			     <input class="button10g" style="font-size:13px;height:25;width:140"  type="button" name="Submit" value="#lt_text#" onClick="addlines()">
			     <input type="hidden" id="lastselectedmode" name="lastselectedmode" value="#url.mode#">	
				</cfif>
				
			</td>
			<td style="padding-left:40px;align:right;min-width:200px;padding-right:20px;font-size:18px">
				<cfif abs(val) gte "0.001">#numberFormat(val,",.__")#</cfif>
			</td>
		
		</tr>
		
	</table>

 </cfoutput>