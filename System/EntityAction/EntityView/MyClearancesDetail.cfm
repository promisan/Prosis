
<cfquery name = "ResultListing" datasource="AppsQuery">
    SELECT  * 
    FROM    #Session.acc#_ActionResultDataset
    WHERE   1=1
    <cfif URL.EntityGroup neq "">
        AND EntityGroup = '#URL.EntityGroup#'
    </cfif>
    <cfif URL.Mission neq "">
        AND Mission = '#URL.Mission#'
    </cfif>
    <cfif URL.Owner neq "">
        AND Owner = '#URL.Owner#'
    </cfif>		
    ORDER BY ListingOrder, SystemModule, EntityOrder, EntityCode 	
</cfquery>

<cf_mobilepanel bodystyle="border:0px; padding-top:0px; padding-bottom:0px;">
    <cfoutput query="ResultListing" group="application">
        <cf_mobilerow>
            <cf_mobilecell class="col-lg-12 mainGroupTitle">
                #Application#
            </cf_mobilecell>
        </cf_mobilerow>
        <cfoutput group="entitycode">
            <cf_mobilerow class="rowHighlight" onclick="toggleGroup('#entityCode#', '#url.entitygroup#', '#url.mission#', '#url.owner#', '#url.me#');" style="cursor:pointer; padding-left:20px;">
                <cf_mobilecell class="col-xs-8 subGroupTitle clsHeader clsHeader_#entityCode#">
                    <i class="fal fa-plus entityIcon entityIcon_#entityCode#"></i>
                    #EntityDescription#
                </cf_mobilecell>	

                <cf_mobilecell class="col-xs-4 subGroupTitle pullTextRight clsHeader clsHeader_#entityCode#">
                    <cfquery name="Total" dbtype="query">
                        SELECT     *
                        FROM       ResultListing
                        WHERE      EntityCode = '#EntityCode#'
                    </cfquery>			 
                
                    <cfquery name="Overdue" dbtype="query">
                        SELECT count(*)
                        FROM   ResultListing
                        WHERE  EntityCode = '#EntityCode#'
                        AND    due > ActionLeadTime+5 
                    </cfquery>	

                    <span class="subGroupSubTitle">#Total.Recordcount# (&nbsp;#Overdue.recordcount#&nbsp;|&nbsp;<span style="color:##FF0000;">#Total.Recordcount-Overdue.recordcount#</span>&nbsp;)</span>
                </cf_mobilecell>
			
            </cf_mobilerow>
            <cf_mobilerow class="clsRow_#EntityCode# clsEntityContainer" id="container_#entityCode#" style="display:none; padding-left:60px; width:98%;" />
        </cfoutput>
    </cfoutput>
</cf_mobilepanel>