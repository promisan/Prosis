	
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
	
	<table width="94%" align="center" class="formpadding">
	<tr><td style="padding-top:10px">
		
		<table width="100%" class="formpadding formspacing">
		
		    <tr><td style="padding-top:10px;font-size:27px;height:40px" class="labellarge">Options:</td></tr>
						
			<tr>
				<td style="padding-left:10px" class="labelmedium2">
				<input type="checkbox" class="radiol" name="extendfirst" id="extendfirst" value="1">
				</td>
				<td class="labelmedium" style="padding-left:10px">Check to first extend all incumbents with a valid assignment on: <b>#DateFormat(Mandate.DateExpiration, CLIENT.DateFormatShow)#</b> for the selected staffing period.			
				</td>
			</tr>
			<tr>
			    <td></td>
				<td style="padding-left:10px" class="labelmedium2">Issued extension requests for incumbents are identified with an icon : <img src="#SESSION.root#/Images/reminder.png" alt="" width="15" height="12" border="0"> </td>
			</tr>
				
			<tr>
				<td style="padding-left:10px" class="labelmedium2">
				<input type="checkbox" class="radiol" name="onlynew" id="onlynew" value="1" checked>			
				</td>
				
				<td class="labelmedium" style="padding-left:10px">Carry over only people without an assignment under the new mandate yet.			
				</td>
			</tr>
			<tr><td></td></tr>
			<tr><td colspan="2" align="center"><input style="border:1px solid silver;height:35;width:200px" type="button" onclick="extend()" class="button10g" name="Process" value="Apply"></td></tr>
			<tr><td></td></tr>
			<tr>
				<td colspan="2" style="padding-top:7px;padding-left:10px" align="center" class="labelmedium2">Please note : All transactions (assignment, contracts and entitlements) will be recorded under your name i.e <b>#SESSION.first# #SESSION.last#</b> </td>
			</tr>	
		</table>
	
	</td></tr>  
	<tr class="xxxhide"><td id="processbox"></td></tr>
	</table>
		
	</cfoutput>

<!---	
<cf_screenbottom layout="webapp">
--->


