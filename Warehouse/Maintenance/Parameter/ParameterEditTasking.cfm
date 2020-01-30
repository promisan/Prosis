
<cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="6"></td></tr>		
		
	<TR class="labelmedium">
    <td width="200">Taskorder Prefix/LastNo:</b></td>
    <TD>
 		<input type="text" class="regularxl" name="TaskOrderPrefix" id="TaskOrderPrefix" value="#TaskOrderPrefix#" size="6" maxlength="6" style="text-align: right;">
		<input type="text" class="regularxl" name="TaskOrderSerialNo" id="TaskOrderSerialNo" value="#TaskOrderSerialNo#" size="6" maxlength="6" style="text-align: right;">
    </TD>
	</TR>
		
	<TR class="labelmedium">
    <td>External Funding Order Type:</b></td>
    <TD>
  	   
		<cfquery name="OrderType" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_OrderType
			WHERE  Code IN (SELECT Code 
			                FROM   Ref_OrderTypeMission 
							WHERE  Mission = '#url.mission#')
		</cfquery>
		
		<cfif OrderType.recordcount eq "0">
		
			<cfquery name="OrderType" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  *
				FROM    Ref_OrderType		
			</cfquery>
		
		</cfif>
		
		<select name="FundingOrderType" id="FundingOrderType" class="regularxl">
		
			<cfloop query="OrderType">
			<option value="#Code#" <cfif get.FundingOrderType eq Code>selected</cfif>>#Description#</option>
			</cfloop>
			
		</select>
	   
    </TD>
	</TR>
		
	<tr><td height="4"></td></tr>
		
	</table>
	
</cfoutput>	