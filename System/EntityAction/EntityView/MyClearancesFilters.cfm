
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
		
		    <table style="background-color:eaeaea;width:100%;border:0px solid silver">
			<tr class="labelmedium">
			<td valign="top" style="padding-top:4px;background-color:e1e1e1;border-right:1px solid silver;font-size:14px;padding-left:6px;min-width:100px;"><cf_tl id="Summary">:</td>
			<td style="height:45px;font-weight:280;font-size:23px;padding:9px;width:100%" id="summary">
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
			</td></tr>			
			</table>
			<br>
        
        <cf_mobilerow>
            <cf_mobilecell class="#vColClass#">
                <select id="sMission" name="sMission" class="form-control" onchange="doRefresh(document.getElementById('sEntityGroup').value,this.value,document.getElementById('sOwner').value,document.getElementById('sUser').checked,'1')">
                    <option value="" <cfif url.EntityGroup eq "">selected</cfif>><cf_tl id="All Entities"></option>
                    <cfloop query="qMission">
                        <option value="#qMission.Mission#" <cfif url.Mission eq qMission.Mission>selected</cfif>>#qMission.Mission#</option>
                    </cfloop>
                </select>
            </cf_mobilecell>

            <cf_mobilecell class="#vColClass#">
                <cfif qEntityGroup.recordcount gt 1>
                    <select id="sEntityGroup" name="sEntityGroup" class="form-control" onchange="doRefresh(this.value,document.getElementById('sMission').value,document.getElementById('sOwner').value,document.getElementById('sUser').checked,'1')">
                        <option value="" <cfif url.EntityGroup eq "">selected</cfif>><cf_tl id="All Groups"></option>
                        <cfloop query="qEntityGroup">
                            <option value="#qEntityGroup.EntityGroup#" <cfif url.EntityGroup eq qEntityGroup.EntityGroup>selected</cfif>>#qEntityGroup.EntityGroup#</option>
                        </cfloop>
                    </select>	
                <cfelse>
                    <input type="hidden" id="sEntityGroup" name="" value="">	
                </cfif>	
            </cf_mobilecell>

            <cf_mobilecell class="#vColClass#">
                <cfif qOwner.recordcount gt 1>

                    <select id="sOwner" name="sOwner" class="form-control" onchange="doRefresh(document.getElementById('sEntityGroup').value,document.getElementById('sMission').value,this.value,'1')">
                        <option value="" <cfif url.Owner eq "">selected</cfif>><cf_tl id="All Owners"></option>
                        <cfloop query="qOwner">
                            <option value="#qOwner.Owner#" <cfif url.Owner eq qOwner.Owner>selected</cfif>>#qOwner.Owner#</option>
                        </cfloop>
                    </select>				

                <cfelse>
                    <input type="hidden" id="sOwner" name="sOwner" value="">					
                </cfif>	
            </cf_mobilecell>
			
			
            <cf_mobilecell class="#vColClass# clsSearchContent" style="display:none;">
                <button class="form-control" onclick="collapseAll()"><cf_tl id="Collapse All"></button>
            </cf_mobilecell>

            <cf_mobilecell class="#vColClass#" style="align:right;min-width:260px;padding-top:2px">
			
				<table>
				<tr class="labelmedium"><td>
			    <input type="radio" id="sUser" name="sUser" class="radiol" value="false" checked onclick="doRefresh(document.getElementById('sEntityGroup').value,document.getElementById('sMission').value,document.getElementById('sOwner').value,'false','1')">
				</td>
				<td style="padding-left:4px"><cf_tl id="Role"></td>
				<td style="padding-left:8px">
				<input type="radio" id="sUser" name="sUser" class="radiol" value="true" onclick="doRefresh(document.getElementById('sEntityGroup').value,document.getElementById('sMission').value,document.getElementById('sOwner').value,'true','1')">
				</td>
				<td style="padding-left:4px"><cf_tl id="Explicitly assigned"></td>
               </tr>
			   </table>
			   <!---
                <select id="sUser" name="sUser" class="form-control" onchange="doRefresh(document.getElementById('sEntityGroup').value,document.getElementById('sMission').value,document.getElementById('sOwner').value,this.value,'1')">
                    <option value="false" <cfif url.me eq "false">selected</cfif>><cf_tl id="All Users"></option>
                    <option value="true" <cfif url.me eq "true">selected</cfif>><cf_tl id="Only me"></option>
                </select>	
				--->
            </cf_mobilecell>

			<!---
            <cfif getAdministrator("*") eq "1">
                <cf_mobilecell class="#vColClass#">
                    <button class="form-control" onclick="entity()"><cf_tl id="View All"></Button>
                </cf_mobilecell>
            </cfif>		
			--->


        </cf_mobilerow>
                
        <cf_mobilerow>
			           
             <cf_mobilecell class="col-xs-5 mainGroupTitle">
                 <cf_tl id="Search for action" var="1">
				<form class="form-inline clsSearchContent" style="height:10px;display:none;">				
                 <input class="form-control" type="text" placeholder="#lt_text#" id="fltSearchTextbox" onkeyup="doTextSearch($.trim(this.value));">
				  <i class="fas fa-search" style="padding-top:9px"></i>
				</form>
             </cf_mobilecell>
				
        </cf_mobilerow>
        

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

<input type="hidden" id="actioncenter_refresh" onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/System/EntityAction/EntityView/getSummary.cfm','summary')">  

</cfoutput> 

   
