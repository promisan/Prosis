
<cfset Mission = "#URL.Mission#">

<cfquery name="Default" 
datasource="AppsOrganization" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT MandateNo 
    FROM   Ref_Mandate
   	WHERE  Mission    = '#Mission#'
	AND    MandateDefault = 1
</cfquery>
	  
<cfset MandateDefault = "#Default.MandateNo#">	  

<cftree name="root"
   font="calibri"
   fontsize="12"		
   bold="No"   
   format="html"    
   required="No">   
    
<cfoutput>

<cfquery name="Mandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT MandateNo, Description, DateEffective, DateExpiration, MandateDefault
      FROM   Ref_Mandate
   	  WHERE  Mission = '#Mission#'
	  ORDER BY DateEffective DESC
  </cfquery>

  <cfloop query="Mandate">
  
  	<cfif MandateDefault eq "1">
	   <cfset exp = "Yes">
	<cfelse>
	   <cfset exp = "No">   
	</cfif>	
		      
     <cftreeitem value="#MandateNo#"
        display="<span style='padding-bottom:13px;height:39px;font-size:17px;color: black;' class='labelmedium'>#dateformat(Mandate.DateExpiration,client.dateformatshow)#</span>"
		parent="root"					
        expand="#exp#">	
			   
	  <cfset MandateNo = Mandate.MandateNo>
  
	  <cfquery name="Action" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT   DISTINCT R.ActionCode, R.ListingOrder, R.Description, R.ActionSource 
	      FROM     EmployeeAction S, Ref_Action R
		  WHERE    S.ActionCode = R.ActionCode
		  AND      Mission      = '#Mission#'
		  AND      MandateNo    = '#MandateNo#' 
		  ORDER BY R.ActionSource,R.ListingOrder, R.Description 
	  </cfquery>
	  
	 <cftreeitem value="#MandateNo#_inc"
        display="<span style='padding-top:3px;padding-bottom:3px;color : black;' class='labelmedium'>Mandate Inception</span>"
		parent="#MandateNo#"	
		href="../../Inception/MandateEdit.cfm?ID=#Mission#&ID1=#MandateNo#&Mission=0"
		target="right">	
		
	 <cftreeitem value="#MandateNo#_dur"
        display="<span style='padding-top:3px;padding-bottom:3px;color : black;' class='labelmedium'>During Mandate</span>"
		parent="#MandateNo#"			
        expand="Yes">	
		
	 <cftreeitem value="#MandateNo#_dur_act"
        display="<span style='padding-top:3px;padding-bottom:3px;color : black;font-size:18px;' class='labelit'>Personnel Action</b></span>"
		parent="#MandateNo#_dur"					
        expand="#exp#">	
	 
	  <cfset prior = "">
       
	  <cfloop query="action">
	  
	   <cfif actionsource neq prior>
	   
	     <cfset prior = actionsource>
	   
	      <cftreeitem value="#MandateNo#_dur_act_#prior#"
	        display="<span style='padding-top:3px;padding-bottom:3px;font-size:17px;' class='labelit'>#ActionSource#</span>"
			parent="#MandateNo#_dur_act"				
			target="right"				
	        expand="Yes">	
	   
	   </cfif>
	  
	   <cfset ActionCode = Action.ActionCode>
	  
	   <cftreeitem value="#MandateNo#_dur_act_#prior#_#ActionCode#"
	        display="<span style='padding-top:0px;padding-bottom:0px;color:0080C0;' class='labelit'>#ActionCode# #Description#</span>"
			parent="#MandateNo#_dur_act_#prior#"	
			href="TransactionViewGeneral.cfm?ID=CDE&ID1=#ActionCode#&Mission=#Mission#&ID3=#MandateNo#&ID4=0"
			target="right"				
	        expand="No">	
		    
		  <cfquery name="ActionStatus" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
		      SELECT   *, 
			           (SELECT count(DISTINCT ActionDocumentNo) 
					    FROM   EmployeeAction 
						WHERE  Mission    = '#Mission#' 
						AND    MandateNo  = '#MandateNo#' 
						AND    ActionCode = '#ActionCode#' 
						AND    ActionPersonNo is not NULL
						AND    ActionStatus = R.Status) as Counted 
		      FROM     Ref_Status R			 
			  <cfif Action.actionsource eq "Assignment">
			  WHERE    R.Class = 'Assignment'
			  <cfelse>
			  WHERE    R.Class = 'Action'
			  </cfif>			
			  ORDER BY R.Status
			  
		  </cfquery>		  		  
	
		  <cfloop query="actionstatus">
		  		  
			   <cftreeitem value="#MandateNo#_dur_act_#prior#_#ActionCode#_#Status#"
			        display="<span style='padding-top:3px;padding-bottom:3px;color : black;' class='labelit'>#Description# [#counted#]</span>"
					parent="#MandateNo#_dur_act_#prior#_#ActionCode#"	
					href="TransactionViewGeneral.cfm?ID=CDE&ID1=#ActionCode#&Mission=#Mission#&ID3=#MandateNo#&ID4=#Status#"
					target="right"				
			        expand="No">	 		  
		 		    
		  </cfloop>
	        
	  </cfloop>
  
  <cfquery name="ActionStatus" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT R.Status, R.Description 
      FROM  Ref_Status R
	  WHERE Class = 'Assignment'	 
	  ORDER BY R.Status
  </cfquery>
  
  <!--- disalbed as the status can be mixed per action 
  
  <cftreeitem value="#MandateNo#_dur_sta"
        display="<b>Approval Status"
		parent="#MandateNo#_dur"				
        expand="Yes">	  
     
	  <cfloop query="actionstatus">
	  
	     <cfset Status = "#ActionStatus.Status#">
	  
	     <cftreeitem value="#MandateNo#_dur_sta_#Status#"
          display="#Description#"
   		  parent="#MandateNo#_dur_sta"	
		  href="TransactionViewGeneral.cfm?ID=STA&ID1=all&Mission=#Mission#&ID3=#MandateNo#&ID4=#Status#"
		  target="right"				
          expand="Yes">	  
	    
		  <cfquery name="Action" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT DISTINCT R.ActionCode, R.Description 
		      FROM   EmployeeAction S, Ref_Action R
			  WHERE  S.ActionCode = R.ActionCode
			  AND    Mission        = '#Mission#'
			  AND    MandateNo      = '#MandateNo#'
			  AND    S.ActionStatus = '#Status#'
			  ORDER BY R.Description 
		  </cfquery>
	  
			  <cfloop query="action">
			  			    
			   <cftreeitem value="#MandateNo#_dur_sta_#Status#_#ActionCode#"
			        display="#Description#"
					parent="#MandateNo#_dur_sta_#Status#_#ActionCode#"	
					href="TransactionViewGeneral.cfm?ID=STA&ID1=#ActionCode#&Mission=#Mission#&ID3=#MandateNo#&ID4=#Status#"
					target="right"				
			        expand="Yes">	 	
			  			    
			  </cfloop>
	        
	  </cfloop>
	  
  --->  
  
  <cfquery name="Posttype" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT PostType 
      FROM   EmployeeAction 
	  WHERE  Mission = '#Mission#'
	  AND    MandateNo = '#MandateNo#'		
  </cfquery>
    
  <cftreeitem value="#MandateNo#_dur_tpe"
        display="<span style='padding-top:3px;padding-bottom:3px;color : black;' class='labelmedium'>Posttype</span>"
		parent="#MandateNo#_dur"				
        expand="No">	
      
  <cfloop query="Posttype">
  
     <cfset tpe = "#Posttype.Posttype#">
  
     <cftreeitem value="#MandateNo#_dur_tpe_#tpe#"
          display="#tpe#"
   		  parent="#MandateNo#_dur_tpe"						
          expand="Yes">	  
  
		  <cfquery name="ActionStatus" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT DISTINCT R.Status, R.Description 
		      FROM   EmployeeAction S, Ref_Status R
			  WHERE  S.ActionStatus = R.Status
			  AND    R.Class = 'Assignment'
			  AND    Mission = '#Mission#'
			  AND    MandateNo = '#MandateNo#'
			  AND    Posttype = '#tpe#'
			  ORDER BY R.Status
		  </cfquery>
  
			  <cfloop query="actionstatus">
			  
				    <cftreeitem value="#MandateNo#_dur_tpe_#tpe#_#Status#"
			          display="#Description#"
			   		  parent="#MandateNo#_dur_tpe_#tpe#"	
					  href="TransactionViewGeneral.cfm?ID=TPE&ID1=#tpe#&Mission=#Mission#&ID3=#MandateNo#&ID4=#Status#'"
					  target="right"				
			          expand="Yes">	  
			  
			  </cfloop>
		        
		  </cfloop>
		 		  		  		  
  </cfloop>  
    
</cfoutput>

</cftree>
 



