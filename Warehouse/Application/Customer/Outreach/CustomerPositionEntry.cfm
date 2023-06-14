
<!--- customer position add --->

<cfoutput>
	
	<cfquery name="Position" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Position
			WHERE PositionNo = '#url.PositionNo#'		
	</cfquery>
	
	<cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Organization
			WHERE OrgUnit = '#Position.OrgunitOperational#'		
	</cfquery>
	
	<cfform method="POST" name="positionform">
	
	<table style="width:100%" class="formpadding formspacing">
	<tr><td style="padding-left:30px;padding-right:30px">
	
		<table style="width:100%" class="formpadding formspacing">
		<tr class="labelmedium2">
		    <td><cf_tl id="Position">:</td>
			<td style="font-weight:bold">#url.positionno# #Position.FunctionDescription#</td>
			</tr>
		<tr class="labelmedium2">
		    <td><cf_tl id="Organization">:</td>
			<td style="font-weight:bold">#org.OrgUnitName#</td>
			</tr>	
		<tr class="labelmedium2">
		    <td><cf_tl id="Incumbent">:</td>
			
			<cfquery name="per" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   PA.DateEffective, 
			          PA.DateExpiration, 
					  P.FullName, 
					  P.Gender, 
					  P.Nationality, 
					  P.IndexNo, 
					  P.PersonNo
			 FROM     PersonAssignment PA INNER JOIN
		              Person P ON PA.PersonNo = P.PersonNo
			 WHERE    PA.DateEffective <= GETDATE() 
			     AND  PA.DateExpiration >= GETDATE()
				 AND  PA.AssignmentStatus IN ('0','1')
			 	 AND  PA.PositionNo = '#url.PositionNo#'
		    </cfquery>
			
			<cfif per.recordcount gte "1">
			<td style="font-weight:bold">#per.Fullname# #dateformat(per.dateexpiration,client.dateformatshow)#</td>
			<cfelse>
			<td><cf_tl id="Vacant"></td>
			
			</cfif>
			
			
		</tr>
		<tr class="labelmedium2">
		    <td><cf_tl id="Effective">:</td>
			<td>
			
				 <cf_intelliCalendarDate9
							FieldName="DateEffective" 
							class="regularxl"
							Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
							DateValidEnd="#Dateformat(Position.DateExpiration, 'YYYYMMDD')#"
							AllowBlank="False">	
			</td>
		</tr>
		<tr class="labelmedium2">
		    <td><cf_tl id="Expiration">:</td>
			<td>		
			
				 <cf_intelliCalendarDate9
							FieldName="DateExpiration" 
							class="regularxl"
							Default="#Dateformat(Position.DateExpiration, CLIENT.DateFormatShow)#"
							DateValidEnd="#Dateformat(Position.DateExpiration, 'YYYYMMDD')#"
							AllowBlank="False">	
			
			</td>
		</tr>
		<tr class="labelmedium2">
		    <td valign="top" style="padding-top:4px"><cf_tl id="Memo">:</td>
			<td><textarea style="padding:5px;font-size:14px;width:100%;height:90px" name="Memo"></textarea></td>
		</tr>
		
		<tr class="line">
		    <td colspan="2"></td>
		</tr>
		
		<tr><td colspan="2" align="center">	
		   <input type="button" name="Submit" value="Submit" class="button10g" style="width:130px" onclick="ptoken.navigate('#session.root#/Warehouse/Application/Customer/Outreach/CustomerPositionSubmit.cfm?customerid=#url.customerid#&positionno=#url.positionno#','processcustomer','','','POST','positionform')">	
		</td></tr>
		</table>

	</td></tr>
	</table>
	
	</cfform>
	
</cfoutput>

<cfset ajaxOnLoad("doCalendar")>