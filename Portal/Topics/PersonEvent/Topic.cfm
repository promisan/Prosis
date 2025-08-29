<!--
    Copyright © 2025 Promisan B.V.

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
<cfoutput>

	<script>
	
		function doChangeActor(link,mis,cactor,csort,cstage,miscont) {
		   
			if ($('##divPersonEventDetail_'+miscont).length > 0) { 			
				ColdFusion.navigate(link+'&status='+$('##fldstatus_'+miscont).val()+'&actor='+cactor.value+'&sort='+csort.value+'&stage='+cstage.value+'&layout='+$('input[name=\'layout_'+miscont+'\']:checked').val(),'divPersonEventDetail_'+miscont);				
			}		
		}		
	
		function doPersonEvent(mis,org,per,srt,mth,act,fld,val,sts,miscont) {
		    _cf_loadingtexthtml='';			
			ptoken.navigate('PersonEvent/EventDetail.cfm?mission='+mis+'&orgunit='+org+'&period='+per+'&sort='+srt+'&month='+mth+'&actor='+act+'&field='+fld+'&value='+val+'&status='+sts,'PersonEventDetail_'+miscont);							
		}
		
		function eventdialog(key) {
	    	ptoken.open('#SESSION.root#/Staffing/Application/Employee/Events/EventDialog.cfm?portal=0&id='+key,'_blank')
			
		}		
		
		
	</script>
	
</cfoutput>

<style>

	.hover:hover { 
	    background-color: silver;	
	}
	
</style>

<cfquery name="MissionList" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     UserModuleCondition C
	WHERE    C.Account   = '#SESSION.acc#'
	AND      C.SystemFunctionId = '#SystemFunctionId#'  
</cfquery>

<cfif MissionList.recordcount gte "2">


		<cf_pane id="Event" search="No">
		
		<cfset mis = valueList(MissionList.ConditionValue)>
		
		<cfset mis = replace(mis,",","__","ALL")> 
		
		<cfquery name="PeriodList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   DISTINCT Year(DateEvent) as Year
			FROM     PersonEvent 
			WHERE    Mission IN (#quotedValueList(MissionList.ConditionValue)#) 	
			AND      DateEvent >= '01/01/2015'
			AND      year(DateEvent) < 2030	
			AND      ActionStatus <> '9'
			UNION
			SELECT   DISTINCT Year(ActionDateEffective) as Year
			FROM     PersonEvent 
			WHERE    Mission IN (#quotedValueList(MissionList.ConditionValue)#) 	
			AND      ActionDateEffective >= '01/01/2015'	
			AND      ActionStatus <> '9'	
			AND      year(ActionDateEffective) < 2030	
			ORDER BY Year(DateEvent) DESC	
			
		</cfquery>		
		
		
		<cfif PeriodList.year gte year(now())>
			<cfset yr = year(now())>
		<cfelse>
			<cfset yr = PeriodList.year>	
		</cfif>		
		
						
		<cf_paneItem         id  = "Event_all" 
		       systemfunctionid  = "#systemfunctionid#"  
			   source            = "#session.root#/Portal/Topics/PersonEvent/EventView.cfm?mission=#mis#"
			   customFilter	     = "#session.root#/Portal/Topics/PersonEvent/CustomFilter.cfm?mission=#mis#"
			   width             = "98%"
			   height            = "auto"
			   Mission           = "all"			   
			   Period            = "All,#valuelist(PeriodList.Year)#"			   
			   DefaultPeriod     = "#yr#"		
			   Label             = "Personnel Events for all selected entities"
			   filterValue       = "Staffing"
			   ShowPrint		 = "1"
			   PrintCallback 	 = "$('##PersonEventMainContainer').attr('style','width:100%;'); $('##PersonEventMainContainer').parent('div').attr('style','width:100%;');">					   
		
	    </cf_pane>
	
</cfif>	


<cfoutput query="MissionList">

    <!--- multiple missions selected --->
	
	<cfset mission = "#ConditionValue#">
	
	<cfquery name="PeriodList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   DISTINCT Year(DateEvent) as Year
		FROM     PersonEvent 
		WHERE    Mission = '#mission#' 	
		AND      DateEvent >= '01/01/2015'
		AND      year(DateEvent) < 2030	
		AND      ActionStatus <> '9'

		<!--- added by rfuentes because year 2021 was not showing in dppadpo --->
		UNION
		SELECT   DISTINCT Year(ActionDateEffective) as Year
		FROM     PersonEvent 
		WHERE    Mission = '#mission#' 	
		AND      ActionDateEffective >= '01/01/2015'		
		AND      ActionStatus <> '9'	
		AND      year(ActionDateEffective) < 2030			

		ORDER BY Year(DateEvent) DESC	
	</cfquery>	
				
	<cf_pane id="Event_#mission#" search="No">
				
			<cf_paneItem          id = "Event_#mission#" 
		        systemfunctionid = "#systemfunctionid#"  
				source           = "#session.root#/Portal/Topics/PersonEvent/EventView.cfm?mission=#mission#"
				customFilter	 = "#session.root#/Portal/Topics/PersonEvent/CustomFilter.cfm?mission=#mission#"
				width            = "99%"
				height           = "auto"
				Mission          = "#mission#"
				Option           = "Parent"
				Period           = "#valuelist(PeriodList.Year)#"
				DefaultOrgUnit   = "#ConditionValueAttribute1#"
				DefaultPeriod    = "#ConditionValueAttribute2#"		
				Label            = "#mission# Personnel Events"
				filterValue      = "Staffing"
				ShowPrint		 = "1"
				PrintCallback 	 = "$('##PersonEventMainContainer').attr('style','width:100%;'); $('##PersonEventMainContainer').parent('div').attr('style','width:100%;');">		
		
	</cf_pane>
	
</cfoutput>

