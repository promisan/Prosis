<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfinvoke component = "Service.Access"  
   method           = "staffing" 
   mission          = "#URL.Mission#"
   mandate          = "#URL.Mandate#"
   returnvariable   = "mandateAccessStaffing">	
      
<cfinvoke component = "Service.Access"  
   method           = "position" 
   mission          = "#URL.Mission#"
   mandate          = "#URL.Mandate#"
   returnvariable   = "mandateAccessPosition">	
     

<cfif mandateAccessStaffing eq "NONE" and mandateAccessPosition eq "NONE">

	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">

		<tr><td align="center" class="labelmedium" style="padding-top:40px"><font color="FF0000">You have no access to this staffing period.<br>Please contact your administrator</td></tr>
	
	</table>	

<cfelse>
		
	<table width="98%" align="center" height="100%">
	   
	 <tr class="line"> 
	     <td>
		 		 
		  <cfquery name="Parent" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			SELECT * 
			FROM Ref_PostGradeParent WHERE Code IN (

				SELECT R.PostGradeParent FROM PersonContract AS P INNER JOIN Ref_PostGrade AS R ON P.ContractLevel = R.PostGrade
				WHERE P.Mission = '#url.Mission#'
				UNION 
				SELECT R.PostGradeParent FROM PersonContract AS P INNER JOIN Ref_PostGrade AS R ON P.ContractLevel = R.PostGrade
				WHERE EXISTS (SELECT 'X' FROM PersonAssignment PA, Position Pos WHERE PA.PositionNo = Pos.PositionNo AND PA.PersonNo = P.PersonNo AND Pos.Mission = '#url.Mission#') 

			) 

			ORDER BY Vieworder
			
		   </cfquery>
		   		   
	   
	   <table cellspacing="0" cellpadding="0">
	   
	   <tr><td height="10"></td></tr>
	   
	   <tr>  
	   
	   <td class="labellarge" style="font-size: 18px;height: 30px;padding-top: 4px;padding-right: 5px;top: -2px;position: relative"><cf_tl id="Select">:</td>
	         
	   <cfoutput query="Parent">
	   
			 <td id="contract#currentrow#" 
			     style="padding:5" #stylescroll# 
				 onclick="submenu('contract','#currentrow#','#recordcount#');ptoken.open('#SESSION.root#/Staffing/Application/Contract/ContractListing.cfm?header=1&id=par&id1=#code#&mission=#url.mission#&mandateno=#url.mandate#','contractbox')">
		  						
					<table border="0" style="cursor:pointer">
				  		<tr>
						<td height="26" align="center" style="padding-left:6px">
							<img src="#SESSION.root#/Images/Contract.png" height="24" width="24">
						</td>						
						<td align="center" style="padding:0 20px 0 2px;font-size:14px;border-right:1px solid ##cccccc;" class="labelmedium">#Description#<td>
						</tr>				
			  		</table>
					
			 </td>
	   
	   	</cfoutput>
				   
	   </tr>
	   
	   </table>
	   
	   </td>
		 	 
	 </tr>
	  		
	 <tr>
	  <td height="100%" valign="top">
	  
	      <iframe name="contractbox"
		     id="contractbox" 
			 width="100%"
			 height="100%" 
			 frameborder="0"></iframe>
	  
	  </td>
	 </tr>
						  
	</table>   
	
</cfif>	

<cfoutput>4.#now()#</cfoutput> 