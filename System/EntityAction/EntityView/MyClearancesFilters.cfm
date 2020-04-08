
<cfquery name="ResultListing" datasource="AppsQuery">
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
    ORDER BY  ListingOrder, SystemModule, EntityOrder, EntityCode 	
</cfquery>

<cf_verifyOperational 
    datasource= "AppsOrganization"
    module    = "Procurement" 
    Warning   = "No">

<cfquery name="Roles" datasource="AppsOrganization">
    SELECT   *
    FROM     Ref_AuthorizationRole
    WHERE    Role IN ('ProcReqCertify','ProcReqObject','ProcReqReview','ProcReqApprove','ProcReqBudget','ProcManager','ProcBuyer')	
    <cfif operational eq 0>
        AND 1=0
    </cfif>	
    ORDER BY ListingOrder
</cfquery>	

<cfif operational>
    <cfloop query="Roles">
        <cfinvoke component = "Service.PendingAction.Check"  
            method           = "#Role#"
            returnvariable   = "rCheck_#Role#">
    </cfloop>
</cfif>	

<cfquery name="qMission" dbtype="query">
    SELECT DISTINCT Mission
    FROM   ResultListing
    WHERE  Mission IS NOT NULL
    <cfloop query="Roles">
        UNION
        SELECT DISTINCT Mission
        FROM rCheck_#Role# 
    </cfloop>						
    ORDER BY Mission
</cfquery>

<cfquery name="qEntityGroup" dbtype="Query">
    SELECT DISTINCT EntityGroup
    FROM   ResultListing
    WHERE  EntityGroup IS NOT NULL AND EntityGroup !=''
    ORDER BY EntityGroup
</cfquery>

<cfquery name="qOwner" dbtype="Query">
    SELECT DISTINCT Owner
    FROM ResultListing
    WHERE Owner IS NOT NULL
    ORDER BY Owner
</cfquery>	

<cfset vColClass = "col-md-2">

<cfoutput>

    <cf_mobilepanel bodystyle="border:0px; padding-top:10px; padding-bottom:10px;">
        <h2 id="summary">
            <cfif ResultListing.recordcount eq "0">
                <cfset cl = "##59C25B">
            <cfelse>
                <cfset cl = "##EF5555">   
            </cfif>
            <cfif ResultListing.recordcount eq "0"><cf_tl id="No"><cfelse><span style="color:#cl#">#ResultListing.recordcount#</span></cfif>
            <cfif ResultListing.recordcount eq "1">
                    <cf_tl id="action">
            <cfelse>
                    <cf_tl id="actions">
            </cfif>
    
            <cf_tl id="and"> <span id="batch"></span>
         
        </h2>
        <cf_mobilerow>
            <cf_mobilecell class="#vColClass#">
                <select id="sMission" name="sMission" class="form-control" onchange="doRefresh(document.getElementById('sEntityGroup').value,this.value,document.getElementById('sOwner').value,document.getElementById('sUser').checked)">
                    <option value="" <cfif url.EntityGroup eq "">selected</cfif>><cf_tl id="All Entities"></option>
                    <cfloop query="qMission">
                        <option value="#qMission.Mission#" <cfif url.Mission eq qMission.Mission>selected</cfif>>#qMission.Mission#</option>
                    </cfloop>
                </select>
            </cf_mobilecell>

            <cf_mobilecell class="#vColClass#">
                <cfif qEntityGroup.recordcount gt 1>
                    <select id="sEntityGroup" name="sEntityGroup" class="form-control" onchange="doRefresh(this.value,document.getElementById('sMission').value,document.getElementById('sOwner').value,document.getElementById('sUser').checked)">
                        <option value="" <cfif url.EntityGroup eq "">selected</cfif>><cf_tl id="All Groups"></option>
                        <cfloop query="qEntityGroup">
                            <option value="#qEntityGroup.EntityGroup#" <cfif url.EntityGroup eq qEntityGroup.EntityGroup>selected</cfif>>#qEntityGroup.EntityGroup#</option>
                        </cfloop>
                    </select>	
                <cfelse>
                    <cf_tl id="n/a">
                    <input type="hidden" id="sEntityGroup" name="" value="">	
                </cfif>	
            </cf_mobilecell>

            <cf_mobilecell class="#vColClass#">
                <cfif qOwner.recordcount gt 1>

                    <select id="sOwner" name="sOwner" class="form-control" onchange="doRefresh(document.getElementById('sEntityGroup').value,document.getElementById('sMission').value,this.value)">
                        <option value="" <cfif url.Owner eq "">selected</cfif>><cf_tl id="All Owners"></option>
                        <cfloop query="qOwner">
                            <option value="#qOwner.Owner#" <cfif url.Owner eq qOwner.Owner>selected</cfif>>#qOwner.Owner#</option>
                        </cfloop>
                    </select>				

                <cfelse>
                    <input type="hidden" id="sOwner" name="sOwner" value="">					
                </cfif>	
            </cf_mobilecell>

            <cf_mobilecell class="#vColClass#">
                <select id="sUser" name="sUser" class="form-control" onchange="doRefresh(document.getElementById('sEntityGroup').value,document.getElementById('sMission').value,document.getElementById('sOwner').value,this.value)">
                    <option value="false" <cfif url.me eq "false">selected</cfif>><cf_tl id="All Users"></option>
                    <option value="true" <cfif url.me eq "true">selected</cfif>><cf_tl id="Only me"></option>
                </select>	
            </cf_mobilecell>


            <cfif getAdministrator("*") eq "1">
                <cf_mobilecell class="#vColClass#">
                    <button class="form-control" onclick="entity()"><cf_tl id="View All"></Button>
                </cf_mobilecell>
            </cfif>		

            <cf_mobilecell class="#vColClass# clsSearchContent" style="display:none;">
                <button class="form-control" onclick="collapseAll()"><cf_tl id="Collapse All"></Button>
            </cf_mobilecell>

        </cf_mobilerow>
        
        <form class="form-inline clsSearchContent" style="display:none;">
            <cf_mobilerow>
                <cf_mobilecell class="col-xs-2 mainGroupTitle" style="width:30px;">
                    <i class="fas fa-search"></i>
                </cf_mobilecell>
                <cf_mobilecell class="col-xs-5 mainGroupTitle">
                    <cf_tl id="Search" var="1">
                    <input class="form-control" type="text" placeholder="#lt_text#" id="fltSearchTextbox" onkeyup="doTextSearch($.trim(this.value));">
                </cf_mobilecell>
            </cf_mobilerow>
        </form>

    </cf_mobilepanel>
	
</cfoutput>

<cfoutput>
    <input type="hidden" id="batchtotal" value="0">
</cfoutput>

<cfset ajaxonload("doSummary")>	

<cfquery name="get" 
 datasource="AppsSystem"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT   TOP 1 * 
	FROM     Ref_ModuleControl					
</cfquery>	

<cfinvoke component = "Service.Connection.Connection"  
   method           = "setconnection"   
   object           = "actioncenter"
   scopeid          = "#get.SystemFunctionid#"   
   objectcontent    = "#Roles#"  
   delay            = "40">	  

<!--- button to be clicked once it was determined that underlying data for this user has changed ---> 

<cfoutput>   

<input type="hidden" id="actioncenter_refresh" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/System/EntityAction/EntityView/getSummary.cfm','summary')">  

</cfoutput> 

   
