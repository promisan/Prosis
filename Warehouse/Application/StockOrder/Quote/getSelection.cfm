
<!--- get Selection --->

<table style="width:96%" align="center" class="formpadding">

    <tr><td style="height:10px"></td></tr> 
	<tr class="labelmedium2 line"><td colspan="2" style="font-size:16px;font-weight:bold"><cf_tl id="Filter by"></td></tr>
			
		<tr class="labelmedium2">
		      <td style="font-size:15px"><cf_tl id="Stock On hand"></td>
			  <td>
			  <input type="checkbox" name="SettingonHand" class="radiol" value="1" onclick="search()">
			  </td>
	    </tr>
		
		<tr class="labelmedium2">
		      <td style="font-size:15px"><cf_tl id="Promotions only"></td>
			  <td>
			  <input type="checkbox" name="SettingPromotion" class="radiol" value="1" onclick="search()">
			  </td>
	    </tr>
		
		<tr class="labelmedium2 line">
		      <td colspan="2" style="padding-top:10px;font-size:15px"><cf_tl id="Priceschedule"></td>
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
		
		  <tr class="labelmedium2" style="background-color:f1f1f1">
		      <td class="linedotted" style="height:27px;padding-left:10px;font-size:14px">#Description#</td>
			  <td class="linedotted">
			  
			  <input type="radio" 
				    style="height:16px;width:16px" 
					name="priceschedule" onclick="search()"
					<cfif FieldDefault eq "1">checked</cfif> 
					value="#code#">
				
			  </td>
			  
		  </tr>
		
		</cfoutput>
		
		<tr><td colspan="2" class="line"></td></tr>
		
				
	<cfparam name="url.category" default="">
	
	<tr><td id="boxcategory" colspan="2" style="padding:6px">
	
	    <cfif url.category neq "">	
		    <cfinclude template="getSelectionCategory.cfm">		
		</cfif>
	
	</td></tr>
		
</table>