<!---
	..Travel/Reporting/PersonAssignmentEditSubmit.cfm  (formerly PersonDepartureEditSubmit.cfm)
	
	Write user edits to the PersonAssignment record.
	
	Called by: PersonAssignmentEdit.cfm
	
	Modification History:
	23Feb04 - created code
	27Apr04 - added code to handle updating of the FunctionNo and FunctionDescription fields
			- note for the future: SEE IF NEED TO UPDATE ABOVE FIELDS ALSO IN THE POSITION AND POSITIONPARENT tables
	08Sep04 - renamed module to PersonAssignmentEditSubmit.cfm
	25Sep04 - added code to log user updates on PersonAssignment table
	04Oct04 - commented out line saving changes to DateEffective field. this field is no longer available in PersonAssignmentEdit.cfm.
	01Nov04 - modified code to handle new uses for DateExpiration and DateDeparture fields
--->
			  
<!-- Process Arrival Date --->
<cfset dateValue = "">
<cfif #Form.DateArrival# NEQ "">
	<CF_DateConvert Value="#Form.DateArrival#">
	<cfset arrdt = #dateValue#>
<cfelse>
	<cfset arrdt = "">
</cfif>

<!-- Process Actual Departure Date 9 Nov 2004 --->
<cfset dateValue = "">
<cfif #Form._tsDateActualDeparture# NEQ "">
	<CF_DateConvert Value="#Form._tsDateActualDeparture#">
	<cfset actdt = #dateValue#>
<cfelse>
	<cfset actdt = "">
</cfif>

<!-- Process Departure Date (this field now contains the expected rotation date) --->
<cfset dateValue = "">
<cfif #Form.DateDeparture# NEQ ''>	
	<CF_DateConvert Value="#Form.DateDeparture#">
	<cfset depdt = #dateValue#>	
<cfelse>
	<cfset depdt = "">	
</cfif>

<!--- verify that person assignment record is there; also retrieve Position.DateExpiration value --->
<cfquery name="Check" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
<!---
	 SELECT PA.*, PO.DateExpiration AS PoDateExpiration
	 FROM PersonAssignment PA INNER JOIN Position PO ON PA.PositionNo = PO.PositionNo
--->
	 SELECT * FROM PersonAssignment	 
	 WHERE AssignmentNo = '#Form.AssignNo#'
</cfquery>	

<cfif #Check.RecordCount# GT 0>

	<!--- 04Oct04 - read EffectiveDate from Check query as this field no longer exists in AssignmentDetails page --->
	<cfset dateValue = "">
	<CF_DateConvert Value="#Dateformat(Check.DateEffective, CLIENT.DateFormatShow)#">
	<cfset effdt = #dateValue#>

	<cfset dateValue = "">
	<CF_DateConvert Value="#Dateformat(Check.DateExpiration, CLIENT.DateFormatShow)#">
	<cfset expdt = #dateValue#>

<!---
	<cfset dateValue = "">
	<CF_DateConvert Value="#Dateformat(Check.PoDateExpiration, CLIENT.DateFormatShow)#">
	<cfset poexpdt = #dateValue#>
--->

	<cfif #AllowAssignEditFlag#>
		<cfquery name="GetFunctionDesc" maxrows="1" datasource="AppsSelection" username="#SESSION.login#" password="#SESSION.dbpw#">
			SELECT FunctionDescription FROM FunctionTitle WHERE FunctionNo = '#Form.FunctionNo#'
		</cfquery>
	
		<cfquery name="UpdateAssignment" datasource="AppsEmployee" 
		 username="#SESSION.login#" password="#SESSION.dbpw#">
		 UPDATE PersonAssignment
		 SET 
			FunctionNo 			= '#Form.FunctionNo#',
			FunctionDescription = '#GetFunctionDesc.FunctionDescription#',
	 	    DateArrival   		= #arrdt#,
		 	DateDeparture 		= #depdt#,
			<cfif #actdt# NEQ "">
		 		_tsDateActualDeparture	= #actdt#,
			<cfelse>
		 		_tsDateActualDeparture	= NULL,
			</cfif>			 
			Remarks        		= '#Form.Remarks#'
		 WHERE AssignmentNo 	= '#Form.AssignNo#'
		</cfquery>
		
	</cfif>	

	<!-- added 25 Sep 04 - to log all updates to PersonAssignment records.
	     Just in case PersonAssignment records get updated by another batch process,
		 Travel.PersonAssignmentUpdateLog serves as backup. --->		 
	<cfquery name="LogUpdateAssignment" datasource="AppsTravel" 
	 username="#SESSION.login#" password="#SESSION.dbpw#">
		 INSERT INTO PersonAssignmentUpdateLog
		   (AssignmentNo, FunctionNo, FunctionDescription, 
		    DateArrival, DateEffective, DateExpiration, DateDeparture, 
			DateActualDeparture,
			Remarks, OfficerUserId)
		 VALUES
		   ('#Form.AssignNo#', '#Form.FunctionNo#', '#GetFunctionDesc.FunctionDescription#',
		     #arrdt#, #effdt#, #expdt#, #depdt#, 
						
		    <cfif #actdt# NEQ ""> 
			     #actdt#, 		 
		    <cfelse>
			 	 NULL,
			</cfif> 
			
			'#Form.Remarks#', '#SESSION.acc#')
	</cfquery>

</cfif>

<cflocation url="PersonAssignmentEdit.cfm?ID=#Form.AssignNo#" addtoken="No">