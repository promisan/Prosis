<cfparam name="URL.pMission" 		default="SCBD">
<cfparam name="URL.pFund" 			default="">
<cfparam name="URL.pYear" 			default="2019">
<cfparam name="URL.pDonor" 			default="">
<cfparam name="url.sortdirection" 	default="ASC">
<cfparam name="url.sortfield" 		default="name">
<cfparam name="url.showDivision" 	default="0">
<cfparam name="url.country" 		default="">

<cfoutput>
	<input type="Hidden" name="pSortDirection" id="pSortDirection" value="#url.sortdirection#">
	<input type="Hidden" name="pSortField" id="pSortField" value="#url.sortfield#">
</cfoutput>

<cfset vParameters = "pMission=#url.pMission#&pFund=#url.pFund#&pYear=#url.pYear#&pDonor=#url.pDonor#&sortdirection=#url.sortdirection#&sortfield=#url.sortfield#&showDivision=#url.showDivision#">

<cfdiv id="divCollectionMap" bind="url:Collection/SummaryMap.cfm?#vParameters#">

<cfdiv id="divCollectionTable" bind="url:Collection/SummaryTable.cfm?#vParameters#">



