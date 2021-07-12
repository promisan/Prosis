
<!--- reset the listing filter and reopen the listing blank --->

<cfoutput>

<cfif url.systemfunctionid neq "">

	<!--- reset the filtering --->
		
	<cfquery name="init" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   UserModule
		WHERE  Account          = '#SESSION.acc#'
		AND    SystemFunctionId = '#url.SystemFunctionId#'			
	</cfquery>
	
</cfif>

<cfset show = "1">

<!--- apply the base query --->

<cfset listquery  = session.listingdata[url.box]['sqlorig']>  
<cfset datasource = session.listingdata[url.box]['datasource']> 
<cfset annotation = session.listingdata[url.box]['annotation']>

<cfquery name="SearchResult" 
	datasource="#datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 										
	#preserveSingleQuotes(listquery)# 					
</cfquery>	

<!--- update the data to be shown --->

<cfset session.listingdata[box]['recordsinit']      = searchresult.recordcount> 
<cfset session.listingdata[box]['datasetinit']      = searchresult>			     <!--- the generate data itself --->	
<cfset session.listingdata[box]['dataprep']         = cfquery.executiontime>      
<cfset session.listingdata[box]['dataprepsort']     = 0>		    
<cfset session.listingdata[box]['records']          = searchresult.recordcount>  <!--- page count 1 of 20 from 300 3: --->
<cfset session.listingdata[box]['dataset']          = searchresult>	



<!--- filter fields to be shown --->
<cfset attributes.listlayout = session.listingdata[url.box]['listlayout']>

<!-- <cfform> -->
<!--- now we render the filter again --->
<cfinclude template="ListingFilter.cfm">


<!-- </cfform> -->

<cfset ajaxOnLoad("doCalendar")>


<script>
  applyfilter('1','','content')
  Prosis.busyRegion('no','_divSubContent');  
</script>

</cfoutput>

