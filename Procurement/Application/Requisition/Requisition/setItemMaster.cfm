
<!--- set --->

<cfparam name="url.mode" default="">

<cfquery name="get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT I.*, 
	       C.CustomDialog
    FROM #CLIENT.LanPrefix#ItemMaster I INNER JOIN Ref_EntryClass C
		ON C.Code = I.EntryClass 
	WHERE I.Code = '#url.itemmaster#'		
</cfquery>

<cfif get.CustomDialogOverwrite neq "">			
	<cfset dlg = get.CustomDialogOverwrite>				
<cfelse>				
	<cfset dlg = get.CustomDialog>			
</cfif>


<cfset des = replaceNoCase("#get.description#",","," ","ALL")>
<cfset des = replaceNoCase("#des#","'","","ALL")>
<cfset des = replaceNoCase("#des#",'"',"","ALL")>

<cfoutput>

<script language="JavaScript">

	document.getElementById('itemmaster').value            = "#get.Code#"
	document.getElementById('itemmasterdescription').value = "#des#"	
						
	<cfif url.mode neq "single">
	
	try {	
	
		processmas('#get.Code#','requestcostprice','#get.Costprice#','#dlg#','#get.EnforceWarehouse#','single')	
		} catch(e) {	
			try {
			processmas('#get.Code#','requestcurrencyprice','#get.Costprice#','#dlg#','#get.EnforceWarehouse#','single')	
			} catch(e) {}					
	}	
	
	</cfif>		

		
</script>	

</cfoutput>
