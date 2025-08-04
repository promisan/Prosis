<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="url.type" default="Item">

<cfset vField = "ItemNo">
<cfset vPrefix = "">
<cfset vLabel = "Master">

<cfif url.type eq "AssetItem">
	<cfset vField = "AssetId">
	<cfset vPrefix = "Asset">
	<cfset vLabel = "Asset">
</cfif>

<cfset vLocationId = "00000000-0000-0000-0000-000000000000">

<cfparam name="url.type" default="Item">

<cfset vField = "ItemNo">
<cfset vPrefix = "">
<cfset vLabel = "Master">

<cfif url.type eq "AssetItem">
	<cfset vField = "AssetId">
	<cfset vPrefix = "Asset">
	<cfset vLabel = "Asset">
</cfif>

<cfif url.locationid neq "">
	<cfset vLocationId = url.locationid>
</cfif>

<cftry>
	<cfquery name="insertMetric" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  	INSERT INTO #vPrefix#ItemSupplyMetric
			(#vField#,
			SupplyItemNo,
			SupplyItemUoM,
			Metric,
			TargetRatio,
	  		OfficerUserId,
		 	OfficerLastName,
			OfficerFirstName)					
		VALUES ('#url.id#',
			  '#url.SupplyItemNo#',
			  '#url.SupplyItemUom#',
			  '#url.metric#',
			  0,			  
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#')
	</cfquery>
	<cfcatch></cfcatch>
</cftry>


<cfquery name="getSupplyMetricTarget" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT 	I.*,
			(SELECT ItemDescription FROM Item WHERE ItemNo = I.SupplyItemNo) as SupplyItemDescription,
			(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = I.SupplyItemNo AND UoM = I.SupplyItemUoM) as SupplyItemUoMDescription
	FROM 	#vPrefix#ItemSupplyMetricTarget I
	WHERE 	I.#vField# = '#URL.id#'
	AND 	I.SupplyItemNo = '#URL.SupplyItemNo#'
	AND		I.SupplyItemUoM = '#URL.SupplyItemUoM#'
	AND		I.Metric = '#url.metric#'
	<cfif url.type eq "Item">
		AND 	I.Location  <cfif url.locationid eq "">IS NULL<cfelse>= '#vLocationid#'</cfif>
		<cfif url.mission neq "">AND I.Mission = '#url.mission#'<cfelse>AND 1=0</cfif>
	</cfif>
	
</cfquery>

<cfquery name="getMetric" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	I.*,
			(SELECT ItemDescription FROM Item WHERE ItemNo = I.SupplyItemNo) as SupplyItemDescription,
			(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = I.SupplyItemNo AND UoM = I.SupplyItemUoM) as SupplyItemUoMDescription,
			(SELECT Description FROM Ref_Metric WHERE Code = I.Metric) as MetricDescription
	FROM 	#vPrefix#ItemSupplyMetric I
	WHERE 	I.#vField#        = '#URL.id#'
	AND   	I.SupplyItemNo  = '#url.SupplyItemNo#'
	AND		I.SupplyItemUom = '#url.SupplyItemUom#'
	AND		I.Metric        = '#url.metric#'
</cfquery>

<cfset vMetricQuantity = 0>
<cfif getMetric.recordCount gt 0>
	<cfset vMetricQuantity = getMetric.MetricQuantity>
</cfif>

<cfquery name="getHeader" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	I.ItemDescription, U.UoMDescription
	FROM 	Item I
			INNER JOIN ItemUoM U
				ON I.ItemNo = U.ItemNo
	WHERE	I.ItemNo = '#URL.SupplyItemNo#'
	AND		U.UoM = '#URL.SupplyItemUoM#'
</cfquery>

<cfset vLabel = "">

<cfif url.type eq "Item">
	<cfset vLabel = "Location">
</cfif>

<cfif url.type eq "AssetItem">
	<cfset vLabel = "Effective Date">
</cfif>

<cfif url.action neq "new">

	<cf_screentop height="100%" 
	   scroll="Yes" 
	   html="Yes" 
	   label="Metric #vLabel#" 
	   option="Consumption Ratio [#getHeader.ItemDescription# - #getMetric.SupplyItemUoMDescription# per #getMetric.MetricQuantity# #getMetric.MetricDescription#]" 
	   layout="webapp" 
	   banner="gray" 
	   bannerheight="50"
	   user="no">
	   
<cfelse>

	<cf_screentop height="100%" 
	   scroll="Yes" 
	   html="Yes" 
	   label="Metric #vLabel#" 
	   option="Add Consumption Ratio [#getHeader.ItemDescription# - #getMetric.SupplyItemUoMDescription# per #getMetric.MetricQuantity# #getMetric.MetricDescription#]" 
	   layout="webapp"
	   banner="blue" 
	   bannerheight="50"
	   user="no">
	
</cfif>

<table class="hide">
	<tr><td><iframe name="processItemSupplyMetricTarget" id="processItemSupplyMetricTarget" frameborder="0"></iframe></td></tr>
</table>

<cfform action="Consumption/ItemSupplyMetricTargetEditSubmit.cfm?id=#url.id#&SupplyItemNo=#url.SupplyItemNo#&SupplyItemUoM=#url.SupplyItemUoM#&mission=#url.mission#&locationid=#url.locationid#&metric=#url.metric#&dateEffective=#url.dateEffective#&action=#url.action#&type=#url.type#&supplyitemuomdescription=#url.supplyitemuomdescription#" method="POST" name="frmItemSupplyMetricTarget" target="processItemSupplyMetricTarget">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfoutput>
	<tr><td height="15"></td></tr>    			
    <TR>	    	  
		<TD width="25%" class="labelit">
			<cfif url.type eq "Item">
				<cf_tl id="Mission">
			</cfif>
			
			<cfif url.type eq "AssetItem">
				<cf_tl id="Effective Date">
			</cfif>
			:
		</TD>
		<td>
			<cfif url.type eq "Item">
				<cfif url.action eq "new">
				
					<cfquery name="getLookup" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT 	*
						FROM 	Ref_ParameterMission
						WHERE	Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'Warehouse')
					</cfquery>
					
					<select name="mission" id="mission" class="regularxl" onchange="javascript: ColdFusion.navigate('Consumption/ItemSupplyMetricTargetLocation.cfm?mission='+this.value+'&location=&action=#url.action#','divItemSupplyMetricTargetLocation');">
						<cfloop query="getLookup">
						  <option value="#getLookup.mission#" <cfif getLookup.mission eq #getSupplyMetricTarget.mission#>selected</cfif>>#getLookup.mission#</option>
					  	</cfloop>
					</select>	
					
					<input type="Hidden" name="MissionOld" id="MissionOld" value="#getSupplyMetricTarget.mission#">	
				
				<cfelse>
					
					#getSupplyMetricTarget.mission#
					
					<input type="Hidden" name="Mission" id="Mission" value="#getSupplyMetricTarget.mission#">	
					<input type="Hidden" name="MissionOld" id="MissionOld" value="#getSupplyMetricTarget.mission#">	
					
				</cfif>
			</cfif>
			<cfif url.type eq "AssetItem">
				<cfif url.action eq "new">
				
					<cf_intelliCalendarDate9
						FieldName="DateEffective"
						Default="#dateformat(now(),'#CLIENT.DateFormatShow#')#"
						AllowBlank="False">
						
					<input type="Hidden" name="DateEffectiveOld" id="DateEffectiveOld" value="#dateformat(getSupplyMetricTarget.dateEffective,'#CLIENT.DateFormatShow#')#">
				<cfelse>
					
					#dateformat(getSupplyMetricTarget.dateEffective,'#CLIENT.DateFormatShow#')#
					
					<input type="Hidden" name="DateEffective" id="DateEffective" value="#dateformat(getSupplyMetricTarget.dateEffective,'#CLIENT.DateFormatShow#')#">	
					<input type="Hidden" name="DateEffectiveOld" id="DateEffectiveOld" value="#dateformat(getSupplyMetricTarget.dateEffective,'#CLIENT.DateFormatShow#')#">
					
				</cfif>
			</cfif>
		</td>
	</TR>
	<cfif url.type eq "Item">
	<TR>
		<td colspan="2">
			<cfdiv id="divItemSupplyMetricTargetLocation"
			    bind="url:Consumption/ItemSupplyMetricTargetLocation.cfm?mission=#getSupplyMetricTarget.mission#&location=#getSupplyMetricTarget.location#&action=#url.action#">	
		</td>
	</TR>
	</cfif>
	<TR>	    	  
		<TD valign="top" class="labelit"><cf_tl id="Consumption">:</TD>
		<td>
			<table width="100%">
				<tr>
					<td width="15%" align="center" class="labelit"><cf_tl id="Load Factor"></td>
					<td align="center" class="labelit"><cf_tl id="Consumption"></td>
					<td align="center" class="labelit"><cf_tl id="Direction"></td>
					<td align="center" class="labelit"><cf_tl id="Range"></td>
				</tr>
				<tr><td class="line" colspan="4"></td></tr>
				<cfset factorList = "0,25,50,75,100">
				<cfloop index="factor" list="#factorList#">
				
					<cfquery name="qTarget" dbtype="query">
						SELECT 	*
						FROM 	getSupplyMetricTarget
						WHERE	OperationMode = #factor#
					</cfquery>
					
					<cfset vTargetRatio = getMetric.TargetRatio>
					<cfset vTargetId = "">
					<cfset vTargetRange = 10>
					<cfif qTarget.recordCount gt 0>
						<cfset vTargetRatio = qTarget.TargetRatio>
						<cfset vTargetId = qTarget.TargetId>
						<cfset vTargetRange = qTarget.TargetRange>
					</cfif>
					
					<tr>
						<td align="center" class="labelit">#factor#%&nbsp;&nbsp;</td>
						<td align="center" class="labelit">  
							<input type="Hidden" name="TargetId_#factor#" id="TargetId_#factor#" value="#vTargetId#">
							<cfinput type="Text"
						       name="TargetRatio_#factor#"
						       value="#lsNumberFormat(vTargetRatio * vMetricQuantity, ',.__')#"
						       validate="numeric"
						       required="Yes"
							   message="Please enter a valid numeric consumption ratio for load factor #factor#."
						       size="3"
						       maxlength="10"
						       class="regularxl" style="text-align=center;">
							&nbsp;#getMetric.SupplyItemUoMDescription#&nbsp;/&nbsp;#getMetric.MetricQuantity# #getMetric.MetricDescription#
							
						</td>
						<td align="center">
							<select name="TargetDirection_#factor#" id="TargetDirection_#factor#" class="regularxl">
								<option value="Up" <cfif lcase(qTarget.TargetDirection) eq "up">selected</cfif>>Up
								<option value="Down" <cfif lcase(qTarget.TargetDirection) eq "down">selected</cfif>>Down
							</select>
						</td>
						<td align="center">
						
							<cfinput type="Text"
						       name="TargetRange_#factor#"
						       value="#vTargetRange#"
						       validate="integer"
						       required="Yes"
							   message="Please enter a valid integer target range for load factor #factor#."
						       size="1"
						       maxlength="5"
						       class="regularxl" style="text-align=center;">
							   
						</td>
					</tr>
					
				</cfloop>
			</table>
		</td>
	</TR>
</cfoutput>

	<tr><td height="10"></td></tr>
	<tr><td class="line" colspan="3"></td></tr>
	<tr><td height="10"></td></tr>
	
	<tr>
	<cfif url.action eq "edit">
			
		<td align="center" colspan="3">
	    	<input class="button10g" type="submit" name="Update" id="Update" value="Update">
		</td>	
		
	<cfelse>
	
		<td align="center" colspan="3">
	    	<input class="button10g" type="submit" name="Insert" id="Insert" value="Save">
		</td>	
		
	</cfif>	
	
	</tr>
	
</table>

</cfform>	

<cfset ajaxonload("doCalendar")>