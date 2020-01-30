<cfparam name="url.servicedomain"  		default="">
<cfparam name="url.servicedomainclass" 	default="">

<cfsavecontent variable="myfeature">
	<cfset embed = "1">
    <cfinclude template="DetailBillingFormEntryRegular.cfm">	
</cfsavecontent>

<cfif unitdetail.recordcount gt "0">
	<table width="97%" border="0" align="right" cellspacing="0" cellpadding="0">		
		<tr><td id="box_<cfoutput>#unitclass#</cfoutput>" 
			    align="right" style="padding-top:2px">									
				<table width="100%" align="right">							   					   
					   <tr>
					    <td><cf_space spaces="10"></td>
					   	<td style="width:99%"></td>
						<td><cf_space spaces="15"></td>
						<td><cf_space spaces="10"></td>
						<td><cf_space spaces="15"></td>
						<td><cf_space spaces="29"></td>
						<td><cf_space spaces="30"></td>
						<td><cf_space spaces="30"></td>
						<td><cf_space spaces="30"></td>						
					   </tr> 					   					   
					   <cfoutput>#myfeature#</cfoutput>						  
				</table>			
			</td>
		</tr>				
	</table>
</cfif>
