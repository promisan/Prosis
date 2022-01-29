
   <cfquery name="Check" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT A.*, 
		        P.PostType, 
				P.Mission, 
				P.MandateNo,
				P.DateEffective  as PositionEffective,
				P.DateExpiration as PositionExpiration
		 FROM   PersonAssignment A, 
		        Position P
		 WHERE  A.AssignmentNo = '#url.AssignmentNo#'
		 AND    A.PositionNo = P.PositionNo
    </cfquery>	

	<cfoutput>

	<cftry>	
		
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td class="labelmedium" style="padding-left:10px;padding-top:5px;border:0px solid silver">
		
		<cfset dateValue = "">
	    <CF_DateConvert Value="#url.DateEffective#">
		<cfset eff = dateValue>
	
		<cfset dateValue = "">
	    <CF_DateConvert Value="#url.DateExpiration#">
		<cfset exp = dateValue>	
		
		<cfif eff lt check.PositionEffective or eff gt check.PositionExpiration>
		      <font color="FF0000">Assignment Effective #DateFormat(eff,CLIENT.DateFormatShow)# lies outside the position effective period: #DateFormat(check.PositionEffective,CLIENT.DateFormatShow)# - #DateFormat(check.PositionExpiration,CLIENT.DateFormatShow)#</font>				
		      <cfabort>		
		</cfif>
					
		<cfif exp gt check.PositionExpiration or exp lt check.PositionEffective>
		      <font color="FF0000">Assignment Expiration #DateFormat(exp,CLIENT.DateFormatShow)# lies outside the position effective period: #DateFormat(check.PositionEffective,CLIENT.DateFormatShow)# - #DateFormat(check.PositionExpiration,CLIENT.DateFormatShow)#</font>				  
		      <cfabort>		
		</cfif>
				
		<cfcatch>
		   <font color="FF0000"><cf_tl id="You entered an invalid date"></font>
		   <cfabort>
		   
		</cfcatch>
		
		</td>
	</tr>
	</table>	
	
	</cftry>	
	
	</cfoutput>
	
	<cfquery name="Period" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT A.*, 
	        P.PostType, 
			P.Mission, 
			P.MandateNo
	 FROM   PersonAssignment A, 
	        Position P
	 WHERE  A.AssignmentNo = '#url.AssignmentNo#'
	 AND    A.PositionNo = P.PositionNo
	 AND    A.DateEffective = #eff#
	 AND    A.DateExpiration = #exp#
</cfquery>	

<cfoutput>
	  
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td bgcolor="E6E6E6" style="padding:7px;border:1px solid silver">
		  
	<table width="100%">
	
	<cfif Period.recordcount eq "0">
		
		<cfif Check.FunctionNo neq url.FunctionNo 
				                  OR
			          Check.OrgUnit neq url.OrgUnit
					   			  OR
			          Check.LocationCode neq url.LocationCode
								  OR
			          Check.AssignmentClass neq url.AssignmentClass
					   			  OR
			          Check.Incumbency neq url.Incumbency>
			
		<tr class="labelmedium2">
			<td align="center" >Your action generates a NEW assignment starting #url.DateEffective# and <br>expires the existing assignment per the same date.</td>
		</tr>
	
		<cfelse>
	
		<tr class="labelmedium2">
			<td align="center">Your action overwrites the existing assignment record and <br> a copy of the old record is logged.</td>
		</tr>
		
		</cfif>
		
	<cfelse>
	
		<tr class="labelmedium2">
			<td align="center">Your changes will overwrite the existing assignment record.</td>
		</tr>
		
	</cfif>
	
	<tr>
		<td align="center" height="34">
		 <!---
	 	 <cf_tl id="Close" var="1">
	     <input class="button10g" style="width:140" type="reset" name="Close" value="<cfoutput>#lt_text#</cfoutput>" onclick="window.close()">	
		 --->
		 <cf_tl id="Apply Now" var="1">
		 <input class="button10g" style="border:1px solid silver;width:140" type="submit" name="Submit" value="<cfoutput>#lt_text#</cfoutput>">
		</td>
	</tr>
	
	</table>	
	
</tr>
</table>	

</cfoutput>