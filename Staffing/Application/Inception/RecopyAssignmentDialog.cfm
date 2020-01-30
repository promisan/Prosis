

<cf_screentop height="100%" close="ColdFusion.Window.destroy('mydialog',true)" 
  scroll="Yes" layout="webapp" banner="gray" line="no" label="Carry over utility #URL.Mission#" option="Extend assignments and contracts in batch">
	
	<cfquery name="Mandate" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		   FROM Ref_Mandate
		   WHERE Mission = '#URL.Mission#'
		   AND MandateNo = '#URL.mandateparent#' 
	  </cfquery>
	
	<cfoutput>
	
	<table width="94%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td style="padding-top:10px">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding formspacing">
		
		    <tr><td style="padding-top:10px;font-size:27px;height:40px" class="labellarge">Options:</td></tr>
						
			<tr>
				<td style="padding-left:10px" class="labelmedium">
				<input type="checkbox" class="radiol" name="extendfirst" id="extendfirst" value="1">
				</td>
				<td class="labelmedium" style="padding-left:10px">Check to first extend all incumbents with a valid assignment on: <b>#DateFormat(Mandate.DateExpiration, CLIENT.DateFormatShow)#</b> for the selected staffing period.			
				</td>
			</tr>
			<tr>
			    <td></td>
				<td style="padding-left:10px" class="labelmedium">Issued extension requests for incumbents are identified with an icon : <img src="#SESSION.root#/Images/reminder.png" alt="" width="15" height="12" border="0"> </td>
			</tr>
				
			<tr>
				<td style="padding-left:10px" class="labelmedium">
				<input type="checkbox" class="radiol" name="onlynew" id="onlynew" value="1" checked>			
				</td>
				
				<td class="labelmedium" style="padding-left:10px">Carry over only people without an assignment under the new mandate yet.			
				</td>
			</tr>
			<tr><td></td></tr>
			<tr><td colspan="2" align="center"><input style="height:35;width:200px" type="button" onclick="extend()" class="button10g" name="Process" value="Apply"></td></tr>
			<tr><td></td></tr>
			<tr>
				<td colspan="2" style="padding-top:7px;padding-left:10px" align="center" class="labelmedium">Please note : All transactions (assignment, contracts and entitlements) will be recorded under your name i.e <b>#SESSION.first# #SESSION.last#</b> </td>
			</tr>	
		</table>
	
	</td></tr>  
	<tr class="xxxhide"><td id="processbox"></td></tr>
	</table>
		
	</cfoutput>

<cf_screenbottom layout="webapp">


