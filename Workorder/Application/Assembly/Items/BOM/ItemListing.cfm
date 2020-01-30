
<table width="100%" height="100%">

<cfoutput>

	<tr class="labelmedium">
	<td style="height:35px;padding:7px" align="center">
	
		<table class="formspacing">
		<tr>
		
		 <cf_tl id="Required BOM" var="1">
		<td class="labelmedium" id="item">
			<input onclick="ptoken.navigate('#session.root#/workorder/Application/Assembly/Items/BOM/ItemListingContent.cfm?mode=#url.mode#&systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&category=#url.category#','process')" 
			type="button" name="item" value="#lt_text#" style="font-size:13px;height:30px;width:230px;border-top-left-radius:15px;border-bottom-left-radius:15px" class="button10g">
		</td>
		
		<cfif url.mode eq "finalproduct">
			<td class="labelmedium" id="proc">			
			<cf_tl id="Procure BOM" var="vProcureBOM">

			<input type="button" name="item" 
			onclick="ptoken.navigate('#session.root#/workorder/Application/Assembly/Items/BOM/generateRequisition.cfm?mission=#url.mission#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&category=#url.category#&systemfunctionid=#url.systemfunctionid#','process')"				 
			value="#vProcureBOM#" style="font-size:13px;height:35px;width:230px;border-radius:0px" class="button10g">
			
			</td>
			<td class="labelmedium" id="earm">
				<cf_tl id="Earmark" var="vEarmark">
				<cf_tl id="Consume BOM" var="vConsume">
				<cf_tl id="or" var="vOr">
			
				<input type="button" name="item" value="#vEarmark# #vOr# #vConsume#" style="font-size:13px;height:35px;width:230px;;border-top-right-radius:10px;border-bottom-right-radius:10px" onclick="collectBOM('#url.workorderid#','#url.workorderline#','#url.category#','#url.mode#')" class="button10g">

			</td>
		<cfelse>
		
		   <!--- 17/6/2016 production workorder are consumed as a process, we disable the explicit earmarking here execpt for admin --->
		   
		   <cfif getAdministrator("*") eq "1">   
		  
		   
		   <cf_tl id="Consume BOM" var="1">		    
			<td class="labelmedium" id="earm">
			<input type="button" name="item" value="Admin/#lt_text#" style="font-size:13px;height:35px;width:230px;;border-top-right-radius:10px;border-bottom-right-radius:10px" onclick="collectBOM('#url.workorderid#','#url.workorderline#','#url.category#','#url.mode#')" class="button10g">
			</td>		
			
			</cfif>
			
		</cfif>
			
		</tr>
	
		</table>

	</td>
	</tr>
	
</cfoutput>

<tr><td valign="top">
   
   <form style="height:100%" id="fGeneration" name="fGeneration">  
       <cfdiv id="process" style="height:100%" bind="url:#session.root#/workorder/Application/Assembly/Items/BOM/ItemListingContent.cfm?mode=#url.mode#&systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&category=#url.category#">			
   </form>
   
</td></tr>

</table>