
<cfparam name="Form.Selected" default="-0.0001" >
<cfparam name="form.off_"     default="-0.0001" >

<cfset val = 0>
<cfset cnt = 0>

<cfloop index="itm" list="#form.Selected#">	
    <cfset cnt = cnt + 1>
    <cfset amt = evaluate("form.off_#left(itm,8)#")>
	<cfset amt = replace("#amt#",",","","ALL")>
	<cfset amt = val(amt)>
	<cfset val = val + amt>		
</cfloop>
			  
<cfoutput>								
		  	
	<table style="width:100%;min-width:290px;" align="center">
	
	    <cfif abs(val) gte "0.001">
	
		<tr class="labelmedium2">
		
			<td style="padding-left:13px">			
					
				 <cf_tl id="Apply" var="1">		
			     <input class="button10g" style="border:1px solid gray;border-radius:4px;font-size:14px;height:30px;width:100px"  type="button" name="Submit" value="#lt_text#" onClick="addlines()">
			     <input type="hidden" id="lastselectedmode" name="lastselectedmode" value="#url.mode#">	
					
			</td>
			
			<td>
			<table>
			
				<tr class="fixlengthlist labelmedium2">
				
				<td style="fixlength;padding-left:4px;padding-right:4px;font-size:14px">
				 <cfif cnt eq "1"><cf_tl id="Selected"><cfelse><cf_tl id="Selected"></cfif>:
				</td>		
			
			    <td style="padding-left:1px;align:right;font-size:16px">
				<cfif cnt eq "1">
				#cnt#
				<cfelse>
				#cnt#
				</cfif>
				</td>	
				
				</tr>
				
				<tr class="fixlengthlist labelmedium2">
				<td style="fixlength;padding-left:4px;padding-right:4px;font-size:14px">
				 <cf_tl id="Amount">:
				</td>		   		
				
				<td style="align:right;padding-right:4px;font-size:16px">
					#numberFormat(val,",.__")#
				</td>	
				</tr>
						
			</table>
			</td>
								
		
		</tr>
		
		</cfif>
		
	</table>

 </cfoutput>