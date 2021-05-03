
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
			<td style="padding-left:3px">			
				<cfif abs(val) gte "0.001">			
				 <cf_tl id="Apply" var="1">		
			     <input class="button10g" style="border:1px solid gray;border-radius:10px;font-size:14px;height:25;width:100px"  type="button" name="Submit" value="#lt_text#" onClick="addlines()">
			     <input type="hidden" id="lastselectedmode" name="lastselectedmode" value="#url.mode#">	
				</cfif>				
			</td>
			<td style="padding-left:40px;align:right;padding-right:4px;font-size:18px">
				<cfif abs(val) gte "0.001">#numberFormat(val,",.__")#</cfif>
			</td>
		
		</tr>
		
	</table>

 </cfoutput>