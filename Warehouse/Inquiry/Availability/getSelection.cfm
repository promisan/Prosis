
<!--- get Selection --->

<table style="width:96%" align="center" class="formpadding">

    <tr><td style="height:10px"></td></tr> 
	<tr class="labelmedium2 line"><td style="font-size:16px;font-weight:bold"><cf_tl id="Filter by"></td></tr>
	
	<tr class="line"><td id="boxpriceschedule" style="padding:6px">
	
	    <!--- only show if category is selected --->
		<table style="width:100%">
		
		<tr class="labelmedium2">
		      <td colspan="2" style="font-size:15px"><cf_tl id="Priceschedule"></td>
	    </tr>
		
		<cfquery name="Schedule" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Ref_PriceSchedule
		   WHERE     Operational = 1  	   
		</cfquery>
		
		<cfoutput query="schedule">
		
		  <tr>
			  <td>
			  
			  <input type="radio" 
			    style="height:17px;width:17px" 
				name="priceschedule" 
				<cfif FieldDefault eq "1">checked</cfif> 
				value="#code#">
				
			  </td>
			  <td style="font-size:13px">#Description#</td>
		  </tr>
		
		</cfoutput>
		
		</table>
	
	</td></tr>	
	
	<tr class="line"><td id="boxbrand" style="padding:6px">
	
	    <!--- only show if category is selected --->
		<table style="width:100%">
		<tr class="labelmedium2"><td style="font-size:15px"><cf_tl id="Brand"></td></tr>
		
		<cfquery name="Make" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Ref_Make		    
		</cfquery>
		
		<tr class="labelmedium2"><td>
		
		  <cf_UISelect name   = "filterMake"
		     class          = "regularxxl"
		     queryposition  = "below"
		     query          = "#Make#"
		     value          = "Code"
		     onchange       = "search()"		     
		     required       = "No"
		     display        = "Description"
		     selected       = ""
			 separator      = "|"
		     multiple       = "yes"/>		
												 
			</td></tr>									 
		
		</table>
	
	</td></tr>
	
	<cfparam name="url.category" default="">
	
	<tr><td id="boxcategory" style="padding:6px">
	
	    <cfif url.category neq "">	
		    <cfinclude template="getSelectionCategory.cfm">		
		</cfif>
	
	</td></tr>
		
</table>