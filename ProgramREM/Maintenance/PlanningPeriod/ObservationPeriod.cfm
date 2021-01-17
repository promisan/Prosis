
<!--- 
step 1 : generate a table that defines the moment of observation for each persion + sub
--->

<cfquery name="Delete" 
datasource="AppsProgram">
DELETE FROM stPeriod
</cfquery>

<cfquery name="Period" 
datasource="AppsProgram">
SELECT *
FROM Ref_Period
</cfquery>

<cfquery name="Sub" 
datasource="AppsProgram">
SELECT *
FROM Ref_SubPeriod
</cfquery>

<cfset span = "#12/Sub.recordcount#">

<cfloop query="Period">

   <cfset dateValue = "">
   <CF_DateConvert Value="#DateFormat(Period.DateEffective, CLIENT.DateFormatShow)#">
   <cfset sel = dateValue>
                      
   <cfset per = #Period.Period#>
   	   
   <cfloop query="Sub">
		
	     <cfset seldte = #sel#>
		 <cfset pr = #span#*#Sub.currentRow#>
		 
		 <cfset seldte = dateAdd("m", #pr#, #seldte#)>
		     
	     <cfloop index="inc" from="0" to="9" step="#span#">
		 		 
		 <cfif seldte lte now()+90>	 
				 
		    <cfif #inc# eq "0">
			   <cfset obs = "In time">
			<cfelse>
			   <cfset obs = "#inc# months">
			</cfif>
							     		 	 		 
			<cfquery name="Insert" 
			datasource="AppsProgram">
			INSERT INTO stPeriod
			(Period, SubPeriod, Observation, SelectionDate, SubPeriodDescription, SelectionDateText)
			VALUES ('#Per#', '#Sub.SubPeriod#', '#obs#', #seldte#, '#Sub.Description#','#DateFormat(seldte, CLIENT.DateFormatShow)#')
			</cfquery>
	
			<cfset seldte = dateAdd("m", #span#, #seldte#)>
			
		 </cfif>	
			
		 </cfloop>	
			
   </cfloop>

</cfloop>

<cfquery name="Correct" 
datasource="AppsProgram">
	UPDATE stPeriod
	SET    SelectionDateText = '#dateformat(now(), CLIENT.DateFormatShow)#',
	       SelectionDate = #now()#
	WHERE  SelectionDate > getDate()
</cfquery>

<!---

<cftry>

<CF_DropTable dbName="AppsOLAP" tblName="stSubPeriod">	

<cfquery name="Correct" 
datasource="AppsProgram">
	SELECT distinct Period, SubPeriod
	INTO ProsisOLAP.dbo.stSubPeriod
	FROM stPeriod
</cfquery>

<cfcatch></cfcatch>

</cftry>

--->

<cfoutput>
<script language="JavaScript">
  alert("Observation periods have been updated")
  window.location = "RecordListing.cfm?idmenu=#url.idmenu#"
</script>
</cfoutput>
