<cfparam name="url.idmenu"      		default="">
<cfparam name="url.systemfunctionid"    default="">

<cfif trim(url.idmenu) neq "" AND trim(url.systemfunctionid) eq "">
	<cfset url.systemfuctionid = url.idmenu>
</cfif>

<html>
<head>
<TITLE><cfoutput>#URL.Mission# staffing summary</cfoutput></TITLE>

<cfquery name="System" 
   datasource="AppsSystem">
      SELECT * 
	  FROM Parameter 
</cfquery> 

<cfif System.VirtualDirectory neq "">
	<cfset CLIENT.VirtualDir  = "/#System.VirtualDirectory#">
<cfelse>
    <cfset CLIENT.VirtualDir  = "">
</cfif>
 
<!--- Table generation checking by Armin 08/30/2014 ---->
<cfinclude template="PostViewInit.cfm">
<cf_systemscript>
  
<cfquery name="Mandate" 
 datasource="AppsOrganization" 
 maxrows=1 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT   * 
    FROM     Ref_Mandate
	WHERE    Mission = '#URL.Mission#'
	AND      Operational = 1	
	ORDER BY MandateDefault DESC
</cfquery>

<cfparam name="URL.Mandate"      default="#Mandate.MandateNo#">
<cfparam name="CLIENT.Filter_ST" default="">

<body bgcolor="FFFFFF">

<cfoutput>
	
	<cfif CLIENT.Filter_ST neq "">
	    <cfset link = "&filterid=#CLIENT.Filter_ST#">
	<cfelse>
	    <cfset link = ""> 
	</cfif>
	
	<script>
	 ptoken.location("#SESSION.root#/Staffing/Reporting/PostView/Staffing/PostViewLoop.cfm?systemfunctionid=#url.systemfunctionid#&acc=#SESSION.acc#&Mission=#URL.Mission#&Mandate=#URL.Mandate#&tree=Operational&Unit=cum#link#")
	</script>	
	
</cfoutput>

</body>
</html>