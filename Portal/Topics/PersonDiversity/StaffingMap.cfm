<cfparam name="url.orgunit"     default="">
<cfparam name="url.cstf"        default="">
<cfparam name="url.postclass"   default="">
<cfparam name="url.category"    default="All">
<cfparam name="url.authorised"  default="">
<cfparam name="url.period"      default="">

<cfquery name="getFunctionId" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ModuleControl M
	WHERE    M.SystemFunctionId = '#url.SystemFunctionId#'
</cfquery>

<cf_screentop 
    label="#url.mission# #getFunctionId.FunctionMemo#" 
    height="100%"
	layout="webapp" 
	scroll="No" 	
	JQuery="yes">	

<cf_layoutScript>
<cf_PresentationScript>
<cf_DialogStaffing>	

<style>
	#mymap {
	  height: 100%;
	  width: 100%:
	  background-color:#EEEEEE;
	}

	.chartwrapper {
	  width: 100%;
	  height: 100%;
	  position: relative;
	  padding-bottom: 40%;
	  box-sizing: border-box;
	}

	.chartdiv {
	  position: absolute;
	  width: 100%;
	  height: 100%;
	}
</style>

<cfinclude template="StaffingPreparation.cfm">

<cfquery name="getMapData" dbtype="query">
		SELECT   ISOCODE2,
			   	 COUNT(DISTINCT PersonNo) AS CountPersons
		FROM	 getStaff
		GROUP BY ISOCODE2
</cfquery>

<cfset vDataList = "">
<cfoutput query="getMapData">
	<cfset vDataList = vDataList & "{id:'#ISOCODE2#', value:#CountPersons#}">
	<cfif currentrow neq recordCount>
		<cfset vDataList = vDataList & ", ">
	</cfif>
</cfoutput>

<cfquery name="getMax" dbtype="query">
	SELECT 	MAX(CountPersons) as MaxValue
	FROM 	getMapData
</cfquery>

<cfquery name="getTotal" dbtype="query">
	SELECT 	SUM(CountPersons) as Total
	FROM 	getMapData
</cfquery>

<cf_tl id="Employees" var="vLblEmployee">
<cf_tl id="out of" var="vLblOutOf">

<cf_ProsisMap 
	id="1" 
	target="mymap" 
	maxValue="#getMax.maxValue#"
	colorFrom="##E9D460"
	colorTo="##1E824C"
	showSmallMap="false"
	autoZoom="false"
	label="<span style='font-size:14px;'><b>[[title]]</b>: [[value]]/#getTotal.Total# #vLblEmployee#</span>"
	onClick="clickMap"
	onHomeClick="clickHome">

<cfoutput>
	<script>
		_cf_loadingtexthtml='';	

		function clickMap(e){
		    expandArea('mainLayout', 'detailArea');
			ptoken.navigate('#session.root#/Portal/Topics/PersonDiversity/StaffingDetail.cfm?systemFunctionId=#url.systemFunctionId#&mission=#url.mission#&orgunit=#url.orgunit#&cstf=#url.cstf#&postclass=#url.postclass#&category=#category#&authorised=#authorised#&period=#url.period#&nationality='+e.mapObject.id,'detailArea')
		}

		function clickHome(e){
			collapseArea('mainLayout', 'detailArea');
		}
		
		var vData =	[#vDataList#];
		loadMapData_1(vData);
	</script>

</cfoutput>
			
<cf_layout type="border" id="mainLayout" width="100%">		

	<cf_layoutArea name="center" position="center">
		<div class="chartwrapper">
  			<div id="mymap" class="chartdiv"></div>
		</div>
	</cf_layoutArea>
	
	<cf_layoutarea position="left" name="detailArea" max-size="33%" size="400px" initCollapsed="true" collapsible="Yes"></cf_layoutarea>	

</cf_layout>						