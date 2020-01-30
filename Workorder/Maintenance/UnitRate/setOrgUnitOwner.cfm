<cfquery name="getMandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM	Ref_Mandate
		WHERE	Mission = '#url.mission#'
		AND		Operational = 1
		AND		MandateDefault = 1
		ORDER BY Created DESC
</cfquery>
		
<cfoutput>	
			
    <table><tr class="labelmedium"><td>
    
	<cf_img icon="add" 
	  onClick="selectOrgUnitOwner('#url.costId#','webdialog','orgunit','orgunitcode','mission2','orgunitname','orgunitclass', '#url.mission#', '#getMandate.MandateNo#');">
	
	</td>
	
	<td style="padding-left:3px">
	<cfif url.costId neq "">
		<a href="javascript:selectOrgUnitOwner('#url.costId#','webdialog','orgunit','orgunitcode','mission2','orgunitname','orgunitclass', '#url.mission#', '#getMandate.MandateNo#');" style="color:4A81F7;">
			<cf_tl id="Limit rate to implementer">
		</a>
	</cfif>
	
	</td>
	
	<cfset vShow = "hidden">
	<cfif url.costId eq "">
		<cfset vShow = "text">
	</cfif>
	
	<td>
	<input type="#vShow#" 	name="orgunitcode" 	id="orgunitcode"  	value="" class="regularxl" size="5" readonly>
	</td>
	<td>
	<input type="#vShow#" 	name="orgunitname" 	id="orgunitname" 	value="" class="regularxl" size="35" readonly>
	</td>
	<input type="hidden" 	name="orgunit" 		id="orgunit"      	value="">
	<input type="hidden" 	name="mission2" 	id="mission2"      	value="">
	<input type="hidden" 	name="orgunitclass" id="orgunitclass"	value="" class="disabled" size="20" maxlength="20" readonly>
	
	</tr>
	</table>
			
</cfoutput>