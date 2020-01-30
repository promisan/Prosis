
<cftransaction isolation="READ_UNCOMMITTED">

<cfquery name="TimeDetails" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">			
		SELECT 	P.*,
		        (SELECT ViewColor   FROM Ref_TimeClass    WHERE TimeClass  = P.TimeClass) as ViewColor,
				(SELECT ActionColor FROM Ref_WorkActivity WHERE ActionCode = P.ActionCode) as ActionColor,
				
				(SELECT  COUNT(*)				
				 FROM 	 PersonWorkDetail D 
				 WHERE	 PersonNo         = P.PersonNo
				 AND	 CalendarDate     = P.CalendarDate
				 AND     TransactionType  = '2') as hasSchedule,
					 
				(SELECT  Count(*)				
				 FROM 	 PersonWorkDetail D 
				 WHERE	 PersonNo         = P.PersonNo
				 AND	 CalendarDate     = P.CalendarDate
				 -- AND     TransactionType  = P.TransactionType
				 AND     ActionMemo > '' ) as hasComment,
				 
				(SELECT  Count(*)				
				 FROM 	 PersonWorkDetail D 
				 WHERE	 PersonNo         = P.PersonNo
				 AND	 CalendarDate     = P.CalendarDate
				 AND     TransactionType  = P.TransactionType
				 AND     BillingMode != 'Contract' ) as hasOvertime,
				 
				(SELECT  Count(*)				
				 FROM 	 PersonWorkDetail D 
				 WHERE	 PersonNo         = P.PersonNo
				 AND	 CalendarDate     = P.CalendarDate
				 AND     TransactionType  = P.TransactionType
				 AND     ActionClass IN (SELECT  R.ActionClass
										 FROM    Ref_WorkAction AS R INNER JOIN
						                         Ref_TimeClass AS C ON R.ActionParent = C.TimeClass
										 WHERE   C.TimeParent = 'Absent')) as hasLeave,
				 
				(SELECT  Count(*)				
				 FROM 	 PersonWorkDetail D 
				 WHERE	 PersonNo         = P.PersonNo
				 AND	 CalendarDate     = P.CalendarDate
				 AND     TransactionType  = P.TransactionType
				 AND     Leaveid is not NULL ) as hasLeaveRequest
			
				 
		FROM 	PersonWorkClass P 
		WHERE	PersonNo            = '#per#'
		AND	    CalendarDate >= #session.timesheet["DateStart"]#
		AND     CalendarDate <= #session.timesheet["DateEnd"]#  
		AND     TransactionType  = '1'
		AND     TimeClass IN (SELECT TimeClass FROM Ref_TimeClass WHERE ShowInAttendance = 1)
		AND     TimeMinutes      > 0		
			  
</cfquery>
				
<cfloop index="day" from="#str#" to="#end#">

    <cfif session.timesheet["presentation"] eq "month">
		<cfset datecur = Createdate(year(session.timesheet["DateStart"]),month(session.timesheet["DateStart"]),day)>		
	<cfelse>
	    <cfset datecur = dateAdd("d",day,date)>		
	</cfif>	
	
	<cfquery name="TimeDetail" dbtype="query">
		SELECT *
		FROM   TimeDetails
		WHERE  CalendarDate = #datecur#	
	</cfquery>		
				
	<!--- verify if person has an assignment at this date --->
	
	<cfset assignment = "0">
	
	<cfif DateEffective lte datecur	AND DateExpiration gte datecur>
		   <cfset assignment = "1">
	</cfif>
	
	<cfset dow = DayOfWeek(datecur)>
						
	<cfset maxk = timedetail.recordcount>
				   			
	<cfif assignment eq "0">
					
		<td style="min-width:<cfoutput>#cwd#</cfoutput>" bgcolor="f1f1f1"></td>
	  
	<cfelse>
	
		<cfset url.x   = day(datecur)>
		<cfset url.mth = month(datecur)>
		<cfset url.yr  = year(datecur)>
	
		<cfoutput>	
	
		<td bgcolor="<cfif #dow# gt "1" and #dow# lt "7">transparent<cfelse>EAF4FF</cfif>"		  
		  align       = "center" 		  
		  id          = "#per#_#day#"
		  onMouseOver = "hl(this,true,'#url.x#-#url.mth#-#url.yr#')" 
		  onMouseOut  = "hl(this,false,'')"
		  style       = "min-width:#cwd#px;border-left:1px solid silver;cursor:pointer;height:100%" 
		  onClick     = "opendate('#Per#','#url.x#','#url.mth#','#url.yr#','0')">
		  				  		  
		 <cfinclude template="TimeSheetDetailCell.cfm">
		 			
	    </td> 
		
		</cfoutput>
	
	</cfif>
			
</cfloop>

</cftransaction>

<cfset ajaxonload("doHighlight")>