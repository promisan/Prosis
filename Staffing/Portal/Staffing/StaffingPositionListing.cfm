
<cfinclude template="StaffingPositionPrepare.cfm">

<cfif Position.recordCount eq 0>
    <div style="text-align:center; padding-top:15%; color:#808080; font-size:20px;">
        [ <cf_tl id="No records found for the selected criteria"> ]
    </div>
<cfelse>

	<cf_mobileRow class="clsSearchContainer">
		<cfoutput>
			<div class="input-group">
				<cf_tl id="Search for name, index number, grade, function, post number or nationality" var="1">
			    <input type="text" class="form-control" placeholder="#lt_text#" onkeyup="doSearch(this.value)">
			    <span class="input-group-addon">
			        <i class="fa fa-search"></i>
			    </span>
			</div>
		</cfoutput>
	</cf_mobileRow>

</cfif>

<cfset vCols = 3>

<cfoutput query="Position" group="HierarchyCode">

    <cfset vLeftBorder = "">
    <cfset vCnt = 0>

    <cf_mobileRow class="clsUnitContainer">
	
		<cfquery name="Level00" 
          datasource="AppsEmployee" 
          username="#SESSION.login#" 
          password="#SESSION.dbpw#">
          SELECT * 
          FROM   Organization.dbo.Organization
          WHERE  OrgUnit = '#OrgUnitOperational#'
	    </cfquery>					  
		
	    <cfset Mission   = Level00.Mission>
	    <cfset MandateNo = Level00.MandateNo>
		<cfset Parent    = Level00.ParentOrgUnit>
		
		<cfif Parent neq "">
		  <cfset List = "'#Level00.OrgUnitCode#','#parent#'">
		<cfelse>
		  <cfset List = "'#Level00.OrgUnitCode#'"> 
		</cfif>  
	      
	    <cfloop condition="Parent neq ''">
				
		    <cfquery name="LevelUp" 
	          datasource="AppsOrganization" 
	          username="#SESSION.login#" 
	          password="#SESSION.dbpw#">
	          SELECT * 
	          FROM   Organization
	          WHERE  OrgUnitCode = '#Parent#'
			    AND  Mission     = '#Mission#'
			    AND  MandateNo   = '#MandateNo#'
		   </cfquery>	    
		   
		   <cfif LevelUp.ParentOrgUnit neq "">
			   <cfset List = "#list#,'#LevelUp.ParentOrgUnit#'">			   
		   </cfif>		
		   
		   <cfset Parent = LevelUp.ParentOrgUnit>
		
		</cfloop>
				
		 <cfquery name="Org" 
          datasource="AppsEmployee" 
          username="#SESSION.login#" 
          password="#SESSION.dbpw#">
	          SELECT   * 
	          FROM     Organization.dbo.Organization
			  WHERE    Mission     = '#Mission#'
			  AND      MandateNo   = '#MandateNo#'
	          AND      OrgUnitCode IN (#preservesinglequotes(List)#)
			  ORDER BY HierarchyCode DESC
	   </cfquery>

        <div class="clsUnit clsSearchable">
		<cfset spaces = "">
		<cfloop query="Org">
			
			<cfif currentrow neq "1">
			<span style="font-size:12px">&nbsp;#OrgUnitName# - #OrgUnitNameShort#</span>&nbsp;<cfif currentrow neq recordcount>|</cfif>
			<cfelse>
			#spaces##OrgUnitName# - #OrgUnitNameShort#<br>
			</cfif>
			<cfset spaces = "#spaces#&nbsp;">
		</cfloop>
		
		<!---
		<a href>Record Position</a>
		--->
		
		</div>
		
		<div onclick="toggleActions('#OrgUnitOperational#');" class="actionsHeader clsSearchable">
			<i class="fa fa-plus-circle actionsIcon actionsIcon_#OrgUnitOperational#" aria-hidden="true"></i>&nbsp;&nbsp;&nbsp;<cf_tl id="Events recorded for unit">
		</div>
		
		<div class="actionsContainer actions_#OrgUnitOperational#" style="display:none;" id="events_#OrgUnitOperational#"></div>

        <cfoutput>
            <cfset vLeftBorder = "">
            <cfif (vCnt%vCols) eq 0>
                <cfset vLeftBorder = "border-left: 1px solid ##EDEDED;">
            </cfif>

            <cf_MobileCell style="#vLeftBorder#" class="clsPosition clsSearchable toggleScroll-y col-xs-12 col-lg-6 col-xl-#INT(12/vCols)#">
                <cfinclude template="StaffingPositionContainer.cfm">	
            </cf_MobileCell>

            <cfset vCnt = vCnt + 1>
        </cfoutput>

    </cf_mobileRow>

</cfoutput>	