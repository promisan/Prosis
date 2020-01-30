<cfparam name="URL.EntityGroup" default="">
<cfparam name="URL.Me" default="true">

<cftry>

    <!--- fastest result from tools/entityaction/myclearances/ --->
		
	<cfif url.me eq "true">
	
		<cf_myClearancesPrepare mode="table" role="0">
	
	<cfelse>
	
		<cf_myClearancesPrepare mode="table" role="1">
	
	</cfif>

	<cfcatch>
	    <cf_waitend>
		<cf_message message="<span style='color:red;font-size:24px;font-weight:200'>Your request was interrupted.</span> <br><br><b><span style='color:blue;font-size:24px;font-weight:200'>Please reload your pending for actions view.</font>" return="No">
		<cfabort>
	
	</cfcatch>

</cftry>

<cfquery name="Module" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ModuleControl
		WHERE    SystemModule  = 'Portal' 
		AND      FunctionClass = 'Procurement'
		AND      FunctionName  = 'Application' 
</cfquery>	

<!--- ------------------------------------------------------------- --->
<!--- define the last date that an action was taken for this object --->
<!--- ------------------------------------------------------------- --->

<table width="100%" height="100%">
	
	<tr><td colspan="6" height="100%" align="center" valign="top" style="padding:15px">
	
		<cfparam name="url.mode" default="">
	    <cfparam name="url.mission" default="">
		<cfparam name="url.owner" default="">
		<cfparam name="url.entitygroup" default="">
		<cfdiv style="width:100%;height:100%" bind="url:#SESSION.root#/system/entityaction/entityview/MyClearancesListing.cfm?mode=#url.mode#&EntityGroup=#URL.EntityGroup#&Mission=#URL.Mission#&Owner=#URL.Owner#&me=#url.me#" id="listing"/>
		
	</td></tr>

</table>
