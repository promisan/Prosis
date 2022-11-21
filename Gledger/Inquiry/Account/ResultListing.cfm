



<cfparam name="URL.Mission"    default="">
<cfparam name="URL.Period"     default="">
<cfparam name="URL.GLCategory" default="Actuals">
<cfparam name="URL.OrgUnit"    default="">

<cf_screentop html="No" jquery="Yes">
<cf_listingscript>

<cfoutput>

<cfsavecontent variable="sqlselect">

		      H.Mission,
			  <cfif url.orgunit neq "">
			  H.OrgUnitOwner,
			  </cfif>
              G.AccountGroup, 
			  G.Description AS AccountGroupDescription, 
			  R.GLAccount, 
			  R.Description, 
			  R.AccountType, 
			  R.AccountClass, 
			  R.AccountCategory, 
			  R.MonetaryAccount, 
              R.ForceCurrency, 
			  MAX(H.Created) as LastDate,
			  count(*) as Lines,
			  ROUND(SUM(L.AmountBaseDebit), 2) AS AmountDebit, 
			  ROUND(SUM(L.AmountBaseCredit), 2) AS AmountCredit, 
              ROUND(SUM(L.AmountBaseDebit - L.AmountBaseCredit), 2) AS Balance
 
</cfsavecontent>	
	  
<!--- body --->

<cfsavecontent variable="sqlbody">
			          TransactionLine AS L INNER JOIN
		              TransactionHeader AS H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo INNER JOIN
		              Ref_Account AS R ON L.GLAccount = R.GLAccount INNER JOIN
		              Ref_AccountGroup AS G ON R.AccountGroup = G.AccountGroup
		WHERE         H.Mission       = '#url.mission#' 
		AND           H.AccountPeriod = '#url.period#' 
		AND           H.ActionStatus IN ('0', '1') 
		AND           H.RecordStatus <> '9' 
		<cfif url.orgunit neq "">
		AND           H.OrgUnitOwner = '#url.orgunit#'
		</cfif>
		AND           R.AccountClass = 'Result'
		AND           H.Journal IN (SELECT Journal 
		                            FROM   Journal 
									WHERE  Journal = H.Journal 
									AND    JournalType = 'General' 
									AND    GLCategory = '#URL.GLCategory#')
</cfsavecontent>
 
<!--- pass the view --->

	<cfsavecontent variable="myquery">  
		SELECT *
		FROM (	SELECT   #preserveSingleQuotes(sqlselect)#					 	
				FROM     #preserveSingleQuotes(sqlbody)#			
				GROUP BY H.Mission,
						 <cfif url.orgunit neq "">
				         H.OrgUnitOwner,
						 </cfif>
						 G.AccountGroup, 
				         G.Description, 
						 R.GLAccount, 
						 R.Description, 
						 R.AccountType, 
						 R.AccountClass, 
						 R.AccountCategory, 
						 R.ForceCurrency, 
						 R.MonetaryAccount ) as B
		WHERE 1=1
		--condition		
					
	</cfsavecontent>	
		  
</cfoutput>
	
	

<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
	
<cfset itm = itm+1>		
<cf_tl id="Group" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
                    width             = "0", 
					field             = "AccountGroupDescription",
					filtermode        = "2",
					search            = "text"}>				
			
<cfset itm = itm+1>		
<cf_tl id="Code" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
                    width             = "0", 
					field             = "GLAccount",
					filtermode        = "2",
					search            = "text"}>
					
									
<cfset itm = itm+1>		
<cf_tl id="Description" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 
                    width      = "0", 
					field      = "Description",
					filtermode = "2",
					search     = "text"}>

<!---					
<cfset itm = itm+1>					
<cf_tl id="Cur" var="1">
<cfset fields[itm] = {label      = "#lt_text#.",    
					width      = "0", 
					field      = "ForceCurrency",
					filtermode = "2",
					alias      = "",
					search     = "text"}>						
					
--->					

					
<cfset itm = itm+1>								
<cf_tl id="Type" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 
					width      = "0", 
					field      = "AccountType",							
					filtermode = "2",    
					search     = "text"}>		
					
<cfset itm = itm+1>								
<cf_tl id="Category" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 
					width      = "0", 
					field      = "AccountCategory",							
					filtermode = "2",    
					search     = "text"}>												

<!---					
<cfset itm = itm+1>					
<cf_tl id="F" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 
                    width      = "0", 
					alias      = "",
					field      = "MonetaryAccount"}>									
					
--->					

						
<cfset itm = itm+1>											
					
<cf_tl id="Date" var="1">
<cfset fields[itm] = {label      = "#lt_text#",    
					width        = "0", 
					field        = "LastDate",		
					labelfilter  = "Last transaction",			
					formatted    = "dateformat(LastDate,CLIENT.DateFormatShow)",
					search       = "date"}>
					
								
<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "L",    
					width      = "0", 
					align      = "right",
					field      = "Lines",
					alias      = ""}>							
									
											
					
<cfset itm = itm+1>					

<cf_tl id="Debit" var="1">
<cfset fields[itm] = {label      = "#lt_text#",
					width      = "0", 
					field      = "AmountDebit",
					align      = "right",
					aggregate  = "sum",
					search     = "",
					formatted  = "numberformat(AmountDebit,',.__')"}>	
					
<cfset itm = itm+1>					

<cf_tl id="Credit" var="1">
<cfset fields[itm] = {label      = "#lt_text#",
					width      = "0", 
					field      = "AmountCredit",
					align      = "right",
					aggregate  = "sum",
					search     = "",
					formatted  = "numberformat(AmountCredit,',.__')"}>		
					
<cfset itm = itm+1>					

<cf_tl id="Balance" var="1">
<cfset fields[itm] = {label      = "#lt_text#",
					width      = "0", 
					field      = "Balance",
					align      = "right",
					aggregate  = "sum",
					search     = "number",
					formatted  = "numberformat(Balance,',.__')"}>										
	

<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">
<tr><td style="padding:6px">
										
	<cf_listing
    	header          = "lsResult"
    	box             = "lsResult"
		link            = "#SESSION.root#/GLedger/Inquiry/Account/ResultListing.cfm?#cgi.query_string#"		
    	html            = "No"
		show	        = "200"
		datasource      = "AppsLedger"
		queryfiltermode = "query"		
		listquery       = "#myquery#"
		listkey         = "GLAccount"
		listgroup       = "AccountGroupDescription"	
		listgrouporder  = "AccountGroup"	
		listorder       = "GLAccount"
		listorderalias  = ""
		listorderdir    = "ASC"
		headercolor     = "ffffff"
		listlayout      = "#fields#"		
		filterShow      = "Yes"
		excelShow       = "Yes"
		drillmode       = "tab"	
		drillstring     = "mission=#url.mission#&orgunitOwner=#url.orgunit#&period=#url.period#&glcategory=#url.glcategory#"
		drilltemplate   = "Gledger/Application/Lookup/AccountResult.cfm?account="
		drillkey        = "GLAccount">

</td></tr></table>

<script>
	parent.Prosis.busy('no')
</script>

