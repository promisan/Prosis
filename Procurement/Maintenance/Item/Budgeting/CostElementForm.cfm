
<cfquery name="Last" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     ItemMasterStandardCost 
	WHERE    OfficerUserid = '#session.acc#'
	ORDER BY Created DESC	
</cfquery>

<cfquery name="qItemList" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemMasterList
	WHERE    ItemMaster = '#URL.id#'
	ORDER BY ListOrder
</cfquery>

<cfquery name="Location" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_PayrollLocation L, System.dbo.Ref_Nation N
	WHERE    L.LocationCountry = N.Code
	<!---
	WHERE    LocationCode IN (selected mission)
	--->
	ORDER BY Name, LocationCode,Description
</cfquery>

<cfform id="fCostElement" name="fCostElement">

<table width="100%" height="100%" class="formpadding">

<tr><td valign="top" style="padding:20px">

<table width="100%" class="formpadding formspacing">

	<tr height="30">
		<cfoutput>
			<td colspan="5" style="padding-left:4px" class="labelmedium">Budget Standard cost Element Definition - #Form.MissionList#</b>			
				<input type="hidden" id="Code" name="Code" value="#URL.id#">
				<input type="hidden" id="MissionList" name="MissionList" value="#Form.MissionList#">
			</td>
		</cfoutput>			
	</tr>
	<tr><td colspan="5" class="line"></td></tr>
	<tr><td height="5"></td></tr>	
	
	<tr>
		<td></td>	
		<td class="labelit"><cf_tl id="Location">:</td>		
		<td>
			<cfselect name="Location" selected="#last.Location#" queryposition="below" group="Name" query="Location" value="LocationCode" display="Description" id="Location" class="regularxl">
				<option value="">Any</option>				
			</cfselect>			
		</td>
		<td></td>		
	</tr>			
	
	<tr>
		<td width="5%"></td>
		<td class="labelit">Date Effective:</td>		
		<td>
		    <cfif Last.dateEffective neq "">
			
				  <cf_intelliCalendarDate9
				FieldName="DateEffective"
				class="regularxl" 				
				Default="#Dateformat(last.DateEffective, CLIENT.DateFormatShow)#"
				AllowBlank="False">	
			
			<cfelse>
			
		      <cf_intelliCalendarDate9
				FieldName="DateEffective"
				class="regularxl" 				
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				AllowBlank="False">				
								
			</cfif>	
		</td>	
		<td width="2%"></td>		
	</tr>
	
	<tr><td colspan="4" class="line"></td></tr>
		
	<tr>
		<td></td>	
		<td class="labelit"><cf_tl id="Applies to">:</td>
		<td colspan="3" align="left" class="labelit" style="height:25px">
		
		    <cfif qItemList.recordcount eq "0">			
				<font color="FF0000">No items defined</font>
			<cfelse>			

			<table cellspacing="0" cellpadding="0" class="formpadding">
			<cfoutput>
				
			<cfset cnt=0>
			<cfloop query="qItemList">
			
				<cfif cnt eq "0">
				<tr>
				</cfif>
				<cfset cnt=cnt+1>
								
				<td><input class="radiol" type="checkbox" id="TopicValueCode" name="TopicValueCode" value="#TopicValueCode#" <cfif topicValueCode eq last.TopicValueCode>checked</cfif>></td>
				<td class="labelit" style="padding-left:4px;padding-right:8px">#TopicValue#</td>	
				<cfif cnt eq "4">
					</tr>		
					<cfset cnt=0>		
				</cfif>	
			</cfloop>
			</cfoutput>
			</table>
			
			</cfif>
		</td>
	</tr>
	
	<tr>
		<td width="5%"></td>
		<td class="labelit"><cf_tl id="Order">:</td>				
		<td>		   
			<cfinput type="text" size="4" style="text-align:center" id="CostOrder" name="CostOrder" maxlength="2" class="regularxl" required="Yes">
		</td>	
		<td width="2%"></td>		
	</tr>
	
	<tr>
		<td width="5%"></td>
		<td class="labelit"><cf_tl id="Cost Element">:</td>				
		<td>
			<cfinput type="text" size="20" id="CostElement" name="CostElement" maxlength="20" class="regularxl" required="Yes">
		</td>	
		<td width="2%"></td>		
	</tr>
	
	<tr>
		<td></td>	
		<td class="labelit"><cf_tl id="Number">:</td>		
		<td>
		  <table><tr><td>
			<input type="text" style="text-align:right" name="CostAmount" id="CostAmount" size="9" maxlength="9" class="regularxl">		
			</td>
			<td style="padding-left:3px">
			<select id="CostBudgetMode" name="CostBudgetMode" class="regularxl">
				<option value="2">Amount</option>
				<option value="1">Percentage</option>				
			</select>		
			</td>
			</tr>
			</table>	
		</td>
		<td></td>		
	</tr>	
		
	<tr><td colspan="5" class="line"></td></tr>	
	
	<tr>
		<td style="padding-top:4px" colspan="4" align="center" id="resultx">
			<input class="button10g" style="width:120;height:25" type="button" name="Save" id="Add" value="Add" onclick="submit_costelement()">
		</td>
	</tr>		
	
</table>

</td></tr>
</table>

</cfform>

<cfset ajaxonload("doCalendar")>