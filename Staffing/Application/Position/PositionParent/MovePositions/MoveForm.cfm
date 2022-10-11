<cfparam name="url.idmenu" default="">
<cfparam name="url.positions" default="">
			   
<cfoutput>
	
	<cfif url.positions eq "">
		
		<table width="100%">
		   <tr><td align="center" class="labelit"><font color="808080">No positions selected</td></tr>
		</table>
	
	</cfif>
	
	<cfquery name="Mandate" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Mandate
			WHERE  Mission   = '#URL.Mission#'
			AND    MandateNo = '#URL.MandateNo#'
	</cfquery>
	
	<cfif Mandate.MandateStatus eq 1 and Mandate.MandateDefault eq 1>
		<cfset mandateStatus = "locked">
	<cfelseif Mandate.MandateStatus eq "0">
		<cfset mandateStatus = "draft">
	<cfelse>	
		<cfset mandateStatus = "locked">
	</cfif>
	
	<cf_divscroll>
	
	<cfform id="moveForm" style="width:95%" onsubmit="return false" name="moveForm">
					  
		<table width="95%" align="center" class="formpadding formspacing">
			
		<cfif mandateStatus eq "locked">
		
		<tr>
			<td class="labelmedium" style="padding-top:4px;color:green" align="center" colspan="3">
					
					There are two movement modes. <b>Loan positions:</b>, allows you to loan selected positions in one click.
					<b>Transfer responsability:</b> expires selected positions as of the day before transfer effective date and will create new positions on the selected unit
					effective as of the transfer effective date.</b> Both modes take care of the assignments linked to the selected positions.
					Inter mission loaned positions may not be moved using this utility.					
					<hr>					
					<font color="FF0000">Important: This action cannot be reverted by the end-user</font>.
					<br>
					<hr>
				
			</td>
		</tr>
		
		<cfelseif mandateStatus eq "draft">
		
		<tr>
			<td class="labelmedium" style="color:green" align="center" colspan="3">
				
					This action will move selected positions to a given, just as if they have been always there.
					<br><br><span style="color:red">Important: This action cannot be reverted.</span>
				
			</td>
		</tr>
		
		</cfif>
		
		<tr>
		<td height="4px" colspan="3">
			<input type="hidden" value="#URL.Positions#" name="positions">
			<input type="hidden" value="#URL.Mission#"   name="mission">
			<input type="hidden" value="#URL.MandateNo#" name="mandateno">
			<input type="hidden" value="#mandateStatus#" name="mandatestatus">
		</td>
		</tr>
						
		<cfif mandateStatus eq "locked">
		<tr>
			<td class="labelmedium" width="100px"><cf_tl id="Mode">:</td>
			<td colspan="2" class="labelmedium">
			   <table cellspacing="0" cellpadding="0" class="formpadding">
			    <tr>
				<td><input type="radio" value="Loan" class="radiol" name="updateParent" id="updateParent"></td><td style="padding-left:5px" class="labelmedium">Loan Position or</td>
				<td style="padding-left:10px;" class="labelmedium"><input class="radiol" type="radio" value="Transfer" name="updateParent" id="updateParent" checked></td><td style="padding-left:5px" class="labelmedium">Transfer responsability</td>
				
				<td class="labelmedium" style="padding-left:4px"><cf_tl id="effective">:</td>
				<td colspan="3" style="padding-left:5px">
				
					<cf_intelliCalendarDate9 
							FieldName="transferDate" 
							DateValidStart="#Dateformat(Mandate.DateEffective, 'YYYYMMDD')#" 
							DateValidEnd="#Dateformat(Mandate.DateExpiration, 'YYYYMMDD')#" 
							Default    = "" 
							message    ="Please select a transfer effective date"
							Required   = "yes"
							AllowBlank = "False" 
							class      ="regularxl">
				</td>
				
				
				</tr>
				</table>
			</td>
		</tr>
		</cfif>
		
		<tr>
			<td class="labelmedium"  width="100px"><cf_tl id="Unit">:</td>
				 
			<td width="20px" class="labelmedium"> 
			
				<cfset link = "#SESSION.root#/staffing/application/position/positionparent/movepositions/getUnit.cfm?x=1">
				
				<cf_selectlookup
				    class        = "Organization"
				    box          = "processmove"
					modal        = "false"
					close		 = "yes"
					icon         = "move.png"
					title        = "Select"
					height		 = "150"
					width		 = "500"
					style        = "height:22;width:250"
					button       = "yes"							
					link         = "#link#"			
					dbtable      = "Organization.dbo.Organization"
					des1         = "OrgUnit"
					filter1      = "Mission"
					filter1Value = "#URL.Mission#"
					filter2      = "MandateNo"
					filter2Value = "#URL.MandateNo#">
			</td>
			<td style="padding-left:5px" class="labelmedium" id="processmove">
					
			</td>
		</tr>
			
		<tr><td colspan="3" id="positions">
			
		<cfquery name="getPosition" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	
			SELECT *, M.MissionOwner
			FROM   Position P, Organization.dbo.Organization O, Organization.dbo.Ref_Mission M
			<cfif mandateStatus neq "locked">
			WHERE  P.PositionParentId IN (#preservesinglequotes(url.positions)#)		
			<cfelse>
			WHERE  P.PositionNo IN (#preservesinglequotes(url.positions)#)	
			</cfif>
			AND    O.OrgUnit   = P.OrgUnitOperational
			AND    P.Mission   = '#url.mission#'
			AND    P.MandateNo = '#url.mandateno#'		
			AND    P.Mission = P.MissionOperational <!--- no intermission loans --->
			AND    P.Mission = M.Mission
			
			
		</cfquery>
			
		<table width="100%" class="navigation_table">
		
					
			<tr class="labelmedium line fixlengthlist">
				<td width="100px">PositionNo</td>
				<td>Current unit</td>
				<td></td>
				<td>Title</td>
				<td>Effective</td>
				<td>Expiration</td>
			</tr>
					
			<cfloop query="getPosition">
			
			<tr class="labelmedium line navigation_row fixlengthlist" style="height:20px">
				<td><cfif sourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionNo#</cfif></td>
				<td>#orgunitname#</td>
				<td>
					<cf_img icon="edit" onclick="selectfunction('lookup','functionno_#positionNo#','functiondescription_#positionNo#','#MissionOwner#','','')">
				</td>
				<td>
					<input type="hidden" name="functionno_#positionNo#" id="functionno_#positionNo#" value="#FunctionNo#">
					<input type    = "text"   
						   name    = "functiondescription_#positionNo#" 
						   id      = "functiondescription_#positionNo#" 
						   value   = "#FunctionDescription#" onfocus="this.blur()" 
						   style   = "border:0px; background-color:transparent; color:##0080C0; font-family: calibri; font-size: 12pt;"
						   class   = "labelit"
						   onclick = "selectfunction('lookup','functionno_#positionNo#','functiondescription_#positionNo#','#MissionOwner#','','')" readonly>
				</td>
				<td>#dateformat(DateEffective,client.dateformatshow)#</td>
				<td>#dateformat(DateExpiration,client.dateformatshow)#</td>
			</tr>
			
			</cfloop>
			<tr></tr>
		
		</table>	
		
		</td></tr>
		
		<tr class="line" style="height:40px">
			<td colspan="3" align="center" style="padding-top:5px">
				<input type="submit" name="submit" id="submit" value="Apply" class="button10g" style="font-size:13px;width:170px" onclick="movevalidate()">
			</td>
		</tr>
		
		<tr><td id="moveprocess"></td></tr>
				
		</table>
	
	</cfform>
	
	</cf_divscroll>
	
	<cfset ajaxonload("doCalendar")>
	<cfset ajaxonload("doHighlight")>
	
</cfoutput>
