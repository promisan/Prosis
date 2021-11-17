
<!--- get Selection --->

<cf_divscroll>

<table style="width:96%" align="center" class="formpadding">

    <tr><td style="height:10px"></td></tr> 

   	    <tr class="labelmedium2 line"><td colspan="2" style="font-size:16px;font-weight:bold"><cf_tl id="Filter by"></td></tr>
			
		<tr class="labelmedium" style="height:23px">
		      <td style="font-size:14px"><cf_tl id="Stock On hand"></td>
			  <td><input type="checkbox" name="SettingonHand" class="radiol" value="1" onclick="search()"></td>
	    </tr>
		
		<tr class="labelmedium" style="height:23px">
		      <td style="font-size:14px"><cf_tl id="Reserved stock"></td>
			  <td><input type="checkbox" name="SettingReservation" class="radiol" value="1" onclick="search()"></td>
	    </tr>
		
		<tr class="labelmedium" style="height:23px">
		      <td style="font-size:14px"><cf_tl id="Promotions"></td>
			  <td><input type="checkbox" name="SettingPromotion" class="radiol" value="1" onclick="search()"></td>
	    </tr>
		
		<tr class="labelmedium" style="height:23px">
		      <td style="font-size:14px"><cf_tl id="Recently shipped"></td>
			  <td><input type="checkbox" name="SettingReceipt" class="radiol" value="1" onclick="search()"></td>
	    </tr>
		
		<tr class="labelmedium" style="height:23px">
		      <td style="font-size:14px"><cf_tl id="#url.mission# recommended"></td>
			  <td><input type="checkbox" name="SettingRecommend" class="radiol" value="1" onclick="search()"></td>
	    </tr>
						
		<tr><td colspan="2" class="line"></td></tr>
						
		<cfparam name="url.category" default="">
	
		<tr><td id="boxcategory" colspan="2" style="padding:6px">
	
		    <cfif url.category neq "">	
			    <cfinclude template="getSelectionCategory.cfm">		
			</cfif>
	
		</td>
		</tr>
		
</table>

</cf_divscroll>