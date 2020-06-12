
<cfinclude template="StaffingPositionPreparation.cfm">

<cfif Position.recordCount eq 0>
    <div style="text-align:center; padding-top:15%; color:#808080; font-size:20px;">
        [ <cf_tl id="No records found for the selected criteria"> ]
    </div>
</cfif>

<div id="process"></div>

<cfset vCols = 4>

<cfoutput query="Position" group="HierarchyCode">

    <cfset vLeftBorder = "">
    <cfset vCnt = 0>

    <cf_mobileRow class="clsUnitContainer">

        <div class="clsUnit">#OrgUnitCode# - #OrgUnitName#</div>

        <cfoutput>
            <cfset vLeftBorder = "">
            <cfif (vCnt%vCols) eq 0>
                <cfset vLeftBorder = "border-left: 1px solid ##EDEDED;">
            </cfif>

            <cf_MobileCell style="#vLeftBorder#" class="clsPosition col-xs-12 col-md-6 col-lg-#floor(12/vCols)#">
                <cfinclude template="StaffingPositionDetail.cfm">	
            </cf_MobileCell>

            <cfset vCnt = vCnt + 1>
        </cfoutput>

    </cf_mobileRow>

</cfoutput>	