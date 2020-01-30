<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   ServiceItem
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfquery name="lookup" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Topic
	WHERE  TopicClass = 'Usage'
</cfquery>

<cfform action="SelfserviceSubmit.cfm?id1=#url.id1#" method="post" name="selfServiceform">

<table width="94%" class="formpadding" cellspacing="0" cellpadding="0" align="center">

        <tr><td></td></tr>
		<tr>
		    <td width="20%" style="height:25px" class="labelmedium">Show in selfservice module:&nbsp;</td>
		    <td class="labelmedium">
			  	<input type="radio" class="radiol" name="SelfService" id="SelfService" value="0" <cfif Get.SelfService neq "1">checked</cfif>>&nbsp;No
				<input type="radio" class="radiol" name="SelfService" id="SelfService" value="1" <cfif Get.SelfService eq "1">checked</cfif>>&nbsp;Yes	
		  	</td>
		</tr>
		
		<tr>
		    <td class="labelmedium">Usage topic group:</td>
		    <td class="labelmedium">
			  	<select name="UsageTopicGroup" id="UsageTopicGroup" class="regularxl">
					<option value="">
					<cfoutput query="lookup">
						<option value="#Code#" <cfif code eq get.UsageTopicGroup>selected</cfif>>#Description#
					</cfoutput>
				</select>
		  	</td>
		</tr>
		
		<tr>
		    <td class="labelmedium">Usage topic detail:</td>
		    <td class="labelmedium">
			  	<select name="UsageTopicDetail" id="UsageTopicDetail" class="regularxl">
					<option value="">
					<cfoutput query="lookup">
						<option value="#Code#" <cfif code eq get.UsageTopicDetail>selected</cfif>>#Description#
					</cfoutput>
				</select>
		  	</td>
		</tr>
		
		<tr>
		    <td class="labelmedium">Usage action close:</td>
		    <td class="labelmedium">
			
				<cfquery name="lookupAction" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM   	Ref_Action A
					WHERE 	EXISTS
						(
							SELECT 	ServiceItem
							FROM 	Ref_ActionServiceItem SI
							WHERE	SI.Code = A.Code
							AND		ServiceItem = '#url.id1#'
						)
					ORDER BY ListingOrder
				</cfquery>
				
				<cfif lookupAction.recordCount gt 0>
				
					<select name="UsageActionClose" id="UsageActionClose" class="regularxl">
						<option value="">
						<cfoutput query="lookupAction">
							<option value="#Code#" <cfif code eq get.UsageActionClose>selected</cfif>>#Description#
						</cfoutput>
					</select>
				
				<cfelse>
				
					<label title="No actions defined for this service item.">N/A</label>
					<input type="Hidden" name="UsageActionClose" id="UsageActionClose" value="">
				</cfif>
							  		
		  	</td>
		</tr>
		
		
		<tr><td height="5"></td></tr>		
		<tr><td height="1" colspan="2" class="line"></td></tr>
		<tr><td colspan="2" align="center" height="36">
			<input class="button10g" type="Submit" name="save" id="save" value=" Save ">	
		</td></tr>
	

</table>

</cfform>