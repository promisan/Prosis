

<cfparam name="url.mode"             default="default">
<cfparam name="url.orgunit"          default="0">
<cfparam name="url.personNo"         default="">
<cfparam name="url.caldate"          default="">
<cfparam name="url.transactiontype"  default="1">


<cfif url.mode eq "cell">

	<cftransaction isolation="READ_UNCOMMITTED">	
		
		<cfquery name="TimeDetail" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
	        password="#SESSION.dbpw#">		
			SELECT 	P.*,
			        (SELECT ViewColor   FROM Ref_TimeClass    WHERE TimeClass = P.TimeClass)   as ViewColor,
					(SELECT ActionColor FROM Ref_WorkActivity WHERE ActionCode = P.ActionCode) as ActionColor,
					
					(SELECT  COUNT(*)				
					 FROM 	 PersonWorkDetail D 
					 WHERE	 PersonNo         = P.PersonNo
					 AND	 CalendarDate     = P.CalendarDate
					 AND     TransactionType  = '2') as hasSchedule,
					
					(SELECT  COUNT(*)			
					 FROM 	 PersonWorkDetail D 
					 WHERE	 PersonNo         = P.PersonNo
					 AND	 CalendarDate     = P.CalendarDate
					 -- AND     TransactionType  = P.TransactionType
					 AND     ActionMemo > '' ) as hasComment,
					 				 
					 
					 (SELECT  COUNT(*)				
					 FROM 	 PersonWorkDetail D 
					 WHERE	 PersonNo         = P.PersonNo
					 AND	 CalendarDate     = P.CalendarDate
					 AND     TransactionType  = P.TransactionType
					 AND     BillingMode != 'Contract' ) as hasOvertime,
					 
					(SELECT  COUNT(*)				
					 FROM 	 PersonWorkDetail D 
					 WHERE	 PersonNo         = P.PersonNo
					 AND	 CalendarDate     = P.CalendarDate
					 AND     TransactionType  = P.TransactionType
					 AND     ActionClass IN (SELECT  R.ActionClass
											 FROM    Ref_WorkAction AS R INNER JOIN
							                         Ref_TimeClass AS C ON R.ActionParent = C.TimeClass
											 WHERE   C.TimeParent = 'Absent')) as hasLeave,
					 
					(SELECT  COUNT(*)				
					 FROM 	 PersonWorkDetail D 
					 WHERE	 PersonNo         = P.PersonNo
					 AND	 CalendarDate     = P.CalendarDate
					 AND     TransactionType  = P.TransactionType
					 AND     Leaveid is not NULL ) as hasLeaveRequest
				
					
			FROM 	PersonWorkClass P 
			WHERE	PersonNo         = '#url.personNo#'
			AND	    CalendarDate     = #Createdate(URL.yr,URL.mth,URL.x)#
			AND     TransactionType = '#url.transactiontype#'
			AND     TimeClass IN (SELECT TimeClass FROM Ref_TimeClass WHERE ShowInAttendance = 1)
			AND     TimeMinutes      > 0								  
		</cfquery>
		
		<cfquery name="CalendarDay" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
	        password="#SESSION.dbpw#">		
			SELECT 	*				
			FROM 	PersonWork
			WHERE	PersonNo         = '#url.personNo#'
			AND	    CalendarDate     = #Createdate(URL.yr,URL.mth,URL.x)#
			AND     TransactionType  = '#url.transactiontype#'						
		</cfquery>	
		
		<!--- refresh the activity summary for that date in the context of the people shown  ---> 
			
		<cfquery name="Activity" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">	
			 SELECT  DISTINCT ActionCode
			 FROM 	 PersonWorkDetail 
			 WHERE	 PersonNo         = '#url.personNo#'
			 AND     TransactionType = '#url.transactiontype#'	
			 AND     ActionCode <> '0'
		</cfquery>
		
		<cfoutput>
		<script> 					  			   
			personrefresh('#url.personno#','#CalendarDay.orgunit#','#URL.x#','#URL.mth#','#URL.yr#')				  			 
	    </script>	
		</cfoutput>	
	 
	 	<cfoutput query="Activity">			 		 
			
			 <script> 			  
			     activityrefresh('#actioncode#','#CalendarDay.orgunit#','#URL.x#','#URL.mth#','#URL.yr#')						 			  
			  </script>		  
				  
		</cfoutput>		
	
	</cftransaction>
		
</cfif>
		
<cfif TimeDetail.recordcount EQ 0>		
		
    <span class="caltxt">&nbsp;</span>		    
	
<cfelse>				
  
	<table width="100%"  
	    style="height:22px;<cfif TimeDetail.hasSchedule gte '1'>;border-bottom:2px solid brown<cfelse>;border-bottom:2px solid lime</cfif>">					
		<tr width="100%" height="100%">			
																															
			<cfoutput query="TimeDetail">		
						
			<cfif ActionColor neq "">			
				<cfset color = ActionColor>
			<cfelse>			
				<cfset color = viewColor>
			</cfif>		
			
			<cfif hasOvertime gte "1">	
			    <cfset com = "background: repeating-linear-gradient(45deg, transparent,transparent 20px, ##ffffff 20px, ##ffffff 39px ),  linear-gradient( ###color#99, ###color#99 );">				
			<cfelseif hasComment gte "1">						
			    <cfset com = "background: repeating-linear-gradient(45deg, transparent,transparent 20px, ##FF0000 20px, ##FF0000 39px ),  linear-gradient( ###color#99, ###color#99 );">			
			<cfelse>			
				<cfset com ="">   
			</cfif>	
			
			<cfif hasLeave eq "0" or hasLeaveRequest gte "1">				   				
			   <!--- we keep the same --->			   
			<cfelse>			
			    <!--- we indicate something is pending to be done in Prosis leave --->
				<cfset com = "#com#;text-decoration: line-through; color:red;-moz-text-decoration-style: wavy;">
			</cfif>
						
			<!--- E6: 90, CC: 80 B3: 70 99: 60 80: 50 --->								
			<td bgcolor="#color#" class="labelit" style="font-size:10px;height:100%;background-color:###color#99;#com#" align="center">											
			#Left(TimeClass,1)#								
			</td>				
																		
			</cfoutput>																		
		</tr>					
	 </table>					 
      	  
</cfif>  
			