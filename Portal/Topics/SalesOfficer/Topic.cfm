

<cfoutput>

	<script>
	
		function doChangeSO(link,mis,cactor,csort,cstage,miscont) {	
		   				   		    
			if ($('##divSalesOfficerDetail_'+miscont).length > 0) { 			
				ptoken.navigate(link+'&status='+$('##fldstatus_'+miscont).val()+'&actor='+cactor.value+'&sort='+csort.value+'&stage='+cstage.value+'&layout='+$('input[name=\'layout_'+miscont+'\']:checked').val(),'divSalesOfficerDetail_'+miscont);				
			}		
		}		
	
		function doPersonEvent(mis,org,per,srt,mth,act,fld,val,sts,miscont) {
		    _cf_loadingtexthtml='';			
			ptoken.navigate('SalesOfficer/SalesDetail.cfm?mission='+mis+'&orgunit='+org+'&period='+per+'&sort='+srt+'&month='+mth+'&actor='+act+'&field='+fld+'&value='+val+'&status='+sts,'PersonEventDetail_'+miscont);							
		}
		
		function salesdialog(key) {
	    	ptoken.open('#SESSION.root#/Warehouse/Application/Stock/Batch/BatchView.cfm?portal=0&id='+key,'_blank')			
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

		<cf_pane id="SalesOfficer" search="No">
		
		<cfset mis = valueList(MissionList.ConditionValue)>
		
		<cfset mis = replace(mis,",","__","ALL")> 
		
		<cfquery name="PeriodList" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		
		    SELECT   DISTINCT Year(TransactionDate) as Year
			FROM     ItemTransaction 
			WHERE    Mission IN (#quotedValueList(MissionList.ConditionValue)#) 	
			
		</cfquery>		
		
		<cfif PeriodList.year gte year(now())>
			<cfset yr = year(now())>
		<cfelse>
			<cfset yr = PeriodList.year>	
		</cfif>			
						
		<cf_paneItem         id  = "SalesOfficer_all" 
		       systemfunctionid  = "#systemfunctionid#"  
			   source            = "#session.root#/Portal/Topics/SalesOfficer/SalesView.cfm?mission=#mis#"
			   customFilter	     = "#session.root#/Portal/Topics/SalesOfficer/CustomFilter.cfm?mission=#mis#"
			   width             = "98%"
			   height            = "auto"
			   Mission           = "all"			   
			   Period            = "All,#valuelist(PeriodList.Year)#"			   
			   DefaultPeriod     = "#yr#"		
			   Label             = "Sales Officer for all selected entities"
			   filterValue       = "Staffing"
			   ShowPrint		 = "1"
			   PrintCallback 	 = "$('##SalesOfficerMainContainer').attr('style','width:100%;'); $('##SalesOfficerMainContainer').parent('div').attr('style','width:100%;');">					   
		
	    </cf_pane>
	
</cfif>	


<cfoutput query="MissionList">

    <!--- multiple missions selected --->
	
	<cfset mission = "#ConditionValue#">
	
	<cfquery name="PeriodList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   DISTINCT Year(TransactionDate) as Year
		FROM     ItemTransaction
		WHERE    Mission = '#mission#' 		
		ORDER BY  Year(TransactionDate) DESC	
		
	</cfquery>	
				
	<cf_pane id="SalesOfficer_#mission#" search="No">
				
			<cf_paneItem          id = "SalesOfficer_#mission#" 
		        systemfunctionid = "#systemfunctionid#"  
				source           = "#session.root#/Portal/Topics/SalesOfficer/SalesView.cfm?mission=#mission#"
				customFilter	 = "#session.root#/Portal/Topics/SalesOfficer/CustomFilter.cfm?mission=#mission#"
				width            = "99%"
				height           = "auto"
				Mission          = "#mission#"
				Option           = "Parent"
				Period           = "#valuelist(PeriodList.Year)#"
				DefaultOrgUnit   = "#ConditionValueAttribute1#"
				DefaultPeriod    = "#ConditionValueAttribute2#"		
				Label            = "#mission# Sales"
				filterValue      = "Staffing"
				ShowPrint		 = "1"
				PrintCallback 	 = "$('##SalesOfficerMainContainer').attr('style','width:100%;'); $('##SalesOfficerContainer').parent('div').attr('style','width:100%;');">		
		
	</cf_pane>
	
</cfoutput>

