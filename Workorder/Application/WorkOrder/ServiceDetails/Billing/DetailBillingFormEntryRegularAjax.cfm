<cfparam name="url.servicedomain"  		default="">
<cfparam name="url.servicedomainclass" 	default="">

<cfsavecontent variable="myfeature">
	<cfset embed = "1">
    <cfinclude template="DetailBillingFormEntryRegular.cfm">	
</cfsavecontent>

<cfif unitdetail.recordcount gt "0">

    <!---
	<table width="100%">		
		<tr><td id="box_<cfoutput>#unitclass#</cfoutput>" style="padding-top:2px;padding-left:30px">									
				<table align="right">							   					   					  			   					   
					   <cfoutput>#myfeature#</cfoutput>						  
				</table>			
			</td>
		</tr>				
	</table>
	
	--->
		
	<table width="100%" style="background-color:fafafa" class="formspacing" id="box_<cfoutput>#unitclass#</cfoutput>">			  	
		<cfoutput>#myfeature#</cfoutput>						  					
		
	</table>
</cfif>
