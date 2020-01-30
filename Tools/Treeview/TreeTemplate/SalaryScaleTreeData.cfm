
<cfform>
<cfoutput>

<cftree name="root"
   font="calibri"
   fontsize="14"		
   bold="No"   
   format="html"    
   required="No">   

<cfquery name="Schedule" 
  datasource="AppsPayroll" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">  
      SELECT * 
	  FROM   SalarySchedule
      WHERE  SalarySchedule IN (SELECT DISTINCT SalarySchedule FROM SalaryScale)	 
      ORDER BY ListingOrder
  </cfquery>

  <cfloop query="Schedule">
  
  <cfquery name="SalarySchedule" 
  datasource="AppsPayroll" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT * 
	  FROM   SalarySchedule
      WHERE  SalarySchedule = '#Schedule.SalarySchedule#'	 
  </cfquery>	
  
  <cfset sch = Schedule.SalarySchedule>
  
   <cftreeitem value="#sch#"
	        display="#SalarySchedule.Description#"
			parent="Root"	
			expand="No">	    
   
	  <cfquery name="Location" 
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT DISTINCT ServiceLocation, Description 
	      FROM   SalaryScale S, 
		         Ref_PayrollLocation R
	   	  WHERE  SalarySchedule    = '#sch#'
		  AND    S.ServiceLocation = R.LocationCode
		  ORDER BY ServiceLocation
	  </cfquery>
    
	  <cfloop query="location">
	  
	       <cfset loc = Location.ServiceLocation>
		   
		    <cftreeitem value="#sch#_#loc#"
				    display="#Location.Description#"
					parent="#sch#"								
					href="#session.root#/Payroll/Application/SalaryScale/SalaryScaleListing.cfm?ID=#sch#&ID1=#loc#&ID2=all&contractid=#contractid#"							
					target="scaleright"
				    expand="No">	
						
				 <cfquery name="Service" 
				       datasource="AppsPayroll" 
				       username="#SESSION.login#" 
				       password="#SESSION.dbpw#">
				        SELECT   DISTINCT 
						         S.ServiceLevel, 
							     R.PostOrderBudget 
				        FROM     SalaryScale K,
						         SalaryScaleLine S, 
						         Employee.dbo.Ref_PostGrade R
				     	WHERE    K.ScaleNo   = S.ScaleNo
						AND      K.SalarySchedule = '#sch#'
						AND      K.ServiceLocation = '#loc#'
						AND      R.PostGrade   =  S.ServiceLevel
						AND	     S.Operational = '1'
						ORDER BY R.PostOrderBudget
				  </cfquery>
					  
				  <cfloop query="Service">
					   	  
		  			 <cftreeitem value="#sch#_#loc#_#ServiceLevel#"
				        display="#ServiceLevel#"
						parent="#sch#_#loc#"								
						href="#session.root#/Payroll/Application/SalaryScale/SalaryScaleListing.cfm?ID=#sch#&ID1=#loc#&ID2=#ServiceLevel#&contractid=#contractid#"							
						target="scaleright"
				        expand="No">	
						
				  </cfloop>	  
   
	  </cfloop>
  
 </cfloop>
 
 </cftree>
 
</cfoutput>

</cfform>



